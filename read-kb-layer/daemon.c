#include <assert.h>
#include <dirent.h>
#include <fcntl.h>
#include <linux/hidraw.h>
#include <pthread.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/poll.h>
#include <sys/select.h>
#include <sys/socket.h>
#include <sys/un.h>
#include <unistd.h>

#define HIDRAW_DIR "/dev"

struct LayeredKeyboard {
  int fd;
  char *path;
  char layer;
};

struct MaybeLKB {
  int result;
  struct LayeredKeyboard kb;
};

void *probe_device(void *out) {
  assert(out != NULL);
  struct MaybeLKB *result = out;
  unsigned char data[32] = {0};
  data[0] = 'S';
  struct timeval timeout = {1, 0};
  if (result->kb.path == NULL) {
    result->result = -2;
    return NULL;
  }

  // indicates issues that have set errno
  result->result = -1;
  result->kb.fd = open(result->kb.path, O_RDWR);
  if (result->kb.fd == -1) {
    goto end;
  }
  int res = write(result->kb.fd, data, sizeof(data));
  if (res == -1) {
    goto end;
  }

  fd_set read_fds;
  FD_ZERO(&read_fds);
  FD_SET(result->kb.fd, &read_fds);
  res = select(result->kb.fd + 1, &read_fds, NULL, NULL, &timeout);
  if (res <= -1) {
    goto end;
  } else if (res == 0) {
    result->result = 0;
    goto end;
  }

  res = read(result->kb.fd, data, sizeof(data));
  if (res > 0 && data[0] == 'S' && data[1] == 1) {
    result->result = 1;
    result->kb.layer = data[31];
  } else {
    result->result = 0;
  }
end:
  printf("probed %s\tresult: %3i\n", result->kb.path, result->result);
  return NULL;
}

struct LayeredKeyboards {
  struct LayeredKeyboard *kbs;
  size_t len;
};

struct LayeredKeyboards probe_devices() {
  struct dirent *entry;
  DIR *dir = opendir(HIDRAW_DIR);
  size_t hd = strlen(HIDRAW_DIR);
  size_t devices = 0, device_cap = 20, name_len;
  size_t layerd_devices = 0;
  char **device_paths = calloc(device_cap, sizeof(*device_paths));
  struct LayeredKeyboards result = {NULL, 0};

  if (dir == NULL) {
    perror("Failed to open /dev directory");
    free(device_paths);
    return result;
  }

  while ((entry = readdir(dir)) != NULL) {
    if (strncmp(entry->d_name, "hidraw", 6) == 0) {
      if (devices == device_cap) {
        device_cap *= 2;
        device_paths =
            realloc(device_paths, device_cap * sizeof(*device_paths));
      }
      name_len = hd + strlen(entry->d_name) + 2;
      device_paths[devices] = calloc(1, name_len);

      snprintf(device_paths[devices], name_len, "%s/%s", HIDRAW_DIR,
               entry->d_name);
      devices += 1;
    }
  }
  closedir(dir);
  struct MaybeLKB layered[devices];
  pthread_t threads[devices];

  for (size_t i = 0; i < devices; ++i) {
    layered[i].kb.path = device_paths[i];
    pthread_create(&threads[i], NULL, probe_device, (void *)&layered[i]);
  }

  for (size_t i = 0; i < devices; ++i) {
    pthread_join(threads[i], NULL);
    if (layered[i].result == 1) {
      layerd_devices += 1;
    } else {
      free(layered[i].kb.path);
      close(layered[i].kb.fd);
    }
  }

  size_t ri = 0;
  result.len = layerd_devices;
  result.kbs = malloc(result.len * sizeof(*result.kbs));
  for (size_t i = 0; i < devices; ++i) {
    if (layered[i].result == 1) {
      result.kbs[ri] = layered[i].kb;
      ri += 1;
    }
  }
  free(device_paths);
  return result;
}

static int read_hid(struct LayeredKeyboard *kb) {
  char data[32];
  if (read(kb->fd, data, sizeof(data)) == -1) {
    perror("unable to read from hid device\n");
    return -1;
  }
  if (data[0] == 'S') {
    kb->layer = data[31];
    printf("%s\tlayer: %u\n", kb->path, kb->layer);
    return 1;
  } else {
    fprintf(stderr, "%s\tunknown message: %c\t size: %u\n", kb->path, data[0],
            data[1]);
    return 0;
  }
}

int listen_socket(const char *path) {
  int fd = socket(AF_UNIX, SOCK_STREAM, 0);
  if (fd == -1)
    return -1;
  struct sockaddr_un addr = {0};

  unlink(path);
  addr.sun_family = AF_UNIX;
  strncpy(addr.sun_path, path, sizeof(addr.sun_path) - 1);
  if (bind(fd, (struct sockaddr *)&addr, sizeof(struct sockaddr_un)) == -1) {
    goto failure;
  }
  if (listen(fd, 5) == -1) {
    goto failure;
  }
  printf("listening on %s\n", path);
  return fd;
failure:
  close(fd);
  return fd;
}

void alloc_polls(const struct LayeredKeyboards kbs, struct pollfd **out) {
  *out = malloc(sizeof(struct pollfd) * kbs.len);
  for (size_t i = 0; i < kbs.len; ++i) {
    (*out)[i].fd = kbs.kbs[i].fd;
    (*out)[i].events = POLLIN;
  }
}
pthread_rwlock_t rwlock;

struct LayeredKeyboards kbs = {0};

void *unix_socket(void *arg) {
  const char *path = arg;
  char data[32] = {0};

  char answer[1024] = {0};
  char *header = "device\tlayer\n";
  size_t header_len = strlen(header);
  struct pollfd fds[1];


  fds[0].fd = listen_socket(path);
  if (fds[0].fd == -1) {
    perror("Failed to create socket");
    exit(1);
  }
  fds[0].events = POLLIN;
  // TODO: read client

  while (1) {
    if (poll(fds, 1, -1) == -1) {
      perror("poll failed");
      exit(1);
    }
    if (fds[0].revents & POLLERR) {
      printf("Unix socket lost. Reinitilizing.\n");
      close(fds[0].fd);
      fds[0].fd = listen_socket(path);
      if (fds[0].fd == -1) {
        perror("Failed to create socket");
        exit(1);
      }
    }
    if (fds[0].revents & POLLIN) {
      int client_fd = accept(fds[0].fd, NULL, NULL);
      if (client_fd == -1) {
        perror("Failed to accept Unix socket connection");
        continue;
      }

      if (read(client_fd, data, sizeof(data)) == -1) {
        perror("Failed to read from Unix socket");
        close(client_fd);
        continue;
      }

      if (data[0] == 'S') {
        if (write(client_fd, header, header_len) == -1) {
          perror("Failed to send header to client");
        } else {

          pthread_rwlock_rdlock(&rwlock);
          for (size_t i = 0; i < kbs.len; ++i) {
            int size = snprintf(answer, 1024, "%s\t%u\n", kbs.kbs[i].path,
                                kbs.kbs[i].layer);
            if (write(client_fd, answer, size) == -1) {
              perror("Failed to send state to client");
            }
          }
          pthread_rwlock_unlock(&rwlock);
        }
      }
      close(client_fd);
    }
  }
}

int main(int argc, char *argv[]) {
  int res = -1;
  const char *socket_path = argc == 2 ? argv[1] : "/tmp/rofl.sock";
  unsigned char timeout = 30;
  struct pollfd *fds = NULL;
  pthread_rwlock_init(&rwlock, NULL);

  pthread_t threads_id;
  // TODO: proper destroy?
  pthread_create(&threads_id, NULL, unix_socket, (void *)socket_path);

probe:
  for (size_t i = 0; i < kbs.len; i++) {
    close(fds[i].fd);
    free(kbs.kbs[i].path);
  }
  free(fds);
  kbs = probe_devices();
  printf("found %zu devices. Timeout is at %u seconds.\n", kbs.len, timeout);
  alloc_polls(kbs, &fds);

  while (1) {
    res = poll(fds, kbs.len + 1, timeout * 1000);
    if (res == 0) {
      printf("timeout reached, reprobing.\n");
      goto probe;
    }
    if (res == -1) {
      perror("poll failed");
      break;
    }
    pthread_rwlock_wrlock(&rwlock);
    for (size_t i = 0; i < kbs.len; ++i) {

      if (fds[i].revents & POLLERR) {
        printf("Device %s lost. Reprobing.\n", kbs.kbs[i].path);
        goto probe;
      }
      if (fds[i].revents & POLLIN && read_hid(&kbs.kbs[i]) == -1) {
        perror("unable to read from hid device");
        goto probe;
      }
    }
    pthread_rwlock_unlock(&rwlock);
  }
result:
  close(fds[0].fd);
  for (size_t i = 0; i < kbs.len; i++) {
    close(fds[i].fd);
    free(kbs.kbs[i].path);
  }
  free(kbs.kbs);
  return res;
}
