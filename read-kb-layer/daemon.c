#include <assert.h>
#include <stddef.h>
#include <stdio.h>
#include <fcntl.h>
#include <stdlib.h>
#include <unistd.h>
#include <linux/hidraw.h>
#include <sys/ioctl.h>
#include <string.h>
#include <sys/select.h>
#include <sys/poll.h>
#include <sys/socket.h>
#include <sys/un.h>
#include <dirent.h>
#include <pthread.h>

#define HIDRAW_DIR "/dev"


struct LayeredKeyboard{
    int fd;
    char *path;
    char layer;
};

struct EitherLayered {
    char *path;
    int fd;
    int result;
    char layer;
};

void *probe_device(void *out) {
    assert(out != NULL);
    struct EitherLayered *result = out;
    unsigned char data[32] = {0};
    data[0] = 'S';
    struct timeval timeout = { 1, 0};
    if (result->path == NULL) {
        result->result = -2;
        return NULL;
    }

    // indicates issues that have set errno
    result->result = -1;
    result->fd = open(result->path, O_RDWR);
    if (result->fd == -1) {
        goto end;
    }
    int res = write(result->fd, data, sizeof(data));
    if (res == -1) {
        goto end;
    }
    
    fd_set read_fds;
    FD_ZERO(&read_fds);
    FD_SET(result->fd, &read_fds);
    res = select(result->fd + 1, &read_fds, NULL, NULL, &timeout);
    if (res <= -1) {
        goto end;
    } else if (res == 0) {
        result->result = 0;
        goto end;
    }
    
    res = read(result->fd, data, sizeof(data));
    if (res > 0 && data[0] == 'S' && data[1] == 1) {
        result->result = 1;
        result->layer = data[31];
    } else {
        result->result = 0;
    }
end:
    printf("probed %s\tresult: %3i\n", result->path, result->result);
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
    size_t devices = 0, device_cap = 20, name_len, layerd_devices = 0;
    char **device_paths = calloc(device_cap, sizeof(*device_paths));
    
    if (dir == NULL) {
        perror("Failed to open /dev directory");
        free(device_paths);
        exit(1);
    }

    while ((entry = readdir(dir)) != NULL) {
        if (strncmp(entry->d_name, "hidraw", 6) == 0) {
            if (devices == device_cap) {
                device_cap *= 2;
                device_paths = realloc(device_paths, device_cap * sizeof(*device_paths));
            }
            name_len =  hd + strlen(entry->d_name) + 2;
            device_paths[devices] = calloc(1, name_len);

            snprintf(device_paths[devices], name_len, "%s/%s", HIDRAW_DIR, entry->d_name);
            devices += 1;
        }
    }
    closedir(dir);
    struct EitherLayered layered[devices];
    pthread_t threads[devices]; 

    for (size_t i = 0; i < devices; ++i){
        layered[i].path = device_paths[i];
        pthread_create(&threads[i], NULL, probe_device, (void*) &layered[i]);
    }
 
    for (size_t i = 0; i < devices; ++i){
        pthread_join(threads[i], NULL);
    }

    for (size_t i = 0; i < devices; ++i){
        if (layered[i].result == 1) {
            layerd_devices += 1;
        } else {
            free(layered[i].path);
            close(layered[i].fd);
        }
    }
    size_t ri = 0;
    struct LayeredKeyboards result;
    result.len = layerd_devices;
    result.kbs = malloc(result.len * sizeof(*result.kbs));
    for (size_t i = 0; i < devices; ++i){
        if (layered[i].result == 1) {
            result.kbs[ri].fd = layered[i].fd;
            result.kbs[ri].path = layered[i].path;
            result.kbs[ri].layer = layered[i].layer;
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
        fprintf(stderr, "%s\tunknown message: %c\t size: %u\n", kb->path, data[0], data[1]);
        return 0;
    }
}

int main(int argc, char *argv[]) {
    int res;
    char data[32] = {0};
    struct sockaddr_un addr;
    const char *socket_path = argc == 2 ? argv[1] : "/tmp/rofl.sock";
    struct LayeredKeyboards kbs = probe_devices();
    struct pollfd fds[kbs.len + 1];

    
    if (kbs.len == 0) {
        perror("No device found.\n");
        return 42;
    }

    fds[0].fd = socket(AF_UNIX, SOCK_STREAM, 0);
    fds[0].events = POLLIN;
    if (fds[0].fd == -1) {
        perror("Failed to create socket");
        goto result;
    }
    unlink(socket_path);
    memset(&addr, 0, sizeof(struct sockaddr_un));
    addr.sun_family = AF_UNIX;
    strncpy(addr.sun_path, socket_path, sizeof(addr.sun_path) - 1);
    if ((res = bind(fds[0].fd, (struct sockaddr*)&addr, sizeof(struct sockaddr_un))) == -1) {
        perror("Failed to bind socket");
        goto result;
    }
    if ((res = listen(fds[0].fd, 5)) == -1) {
        perror("Failed to listen on socket");
        goto result;
    }
    printf("listening on %s\n", socket_path);
    for (int i = 0; i < kbs.len; ++i) {
        fds[i + 1].fd = kbs.kbs[i].fd;
        fds[i + 1].events = POLLIN;
    }
 
    while (1) {
        res = poll(fds, kbs.len + 1, -1);
        if (res == -1) {
            perror("poll failed");
            break;
        }
        if (fds[0].revents & POLLIN) {
            int client_fd = accept(fds[0].fd, NULL, NULL);
            if (client_fd == -1) {
                perror("Failed to accept Unix socket connection");
                continue;
            }

            res = read(client_fd, data, sizeof(data));
            if (res == -1) {
                perror("Failed to read from Unix socket");
                close(client_fd);
                continue;
            }

            if (data[0] == 'S') {
                char answer[1024] = {0};
                char *header =  "device\tlayer\n";
                size_t header_len =  strlen(header);
                if (write(client_fd, header, header_len) == -1) {
                   perror("Failed to send header to client");
                } else {
                   for (size_t i = 0; i < kbs.len; ++i) {
                        int size = snprintf(answer, 1024, "%s\t%u\n", kbs.kbs[i].path, kbs.kbs[i].layer);
                        res = write(client_fd, answer, size);
                        if (res == -1) {
                            perror("Failed to send state to client");
                        }
                   }
                }
           } 
           close(client_fd);
        }
        for (int i = 0; i < kbs.len; ++i) {
            if (fds[i + 1].revents & POLLIN && read_hid(&kbs.kbs[i]) == -1){
                perror("unable to read from hid device");
                res = -3;
                break;
            }
        }

    }
result:
    close(fds[0].fd);
    for (int i = 0; i < kbs.len; i++) {
        close(fds[i + 1].fd);
        free(kbs.kbs[i].path);
    }
    free(kbs.kbs);
    return res;
}
