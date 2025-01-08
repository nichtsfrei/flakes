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
#include <omp.h>

#define HIDRAW_DIR "/dev"


struct LayeredKeyboard{
    int fd;
    const char *path;
    char layer;
};

struct EitherLayered {
    char *path;
    int fd;
    int result;
    char layer;
};

struct EitherLayered is_layer_device(char* device_path) {
    unsigned char data[32] = {0};
    data[0] = 'S';
    struct timeval timeout = { 1, 0};
    int fd = open(device_path, O_RDWR);
    struct EitherLayered result = {device_path, fd, -1, -1};
    if (fd == -1) {
        return result;
    }
    int res = write(fd, data, sizeof(data));
    if (res == -1) {
        return result;
    }
    
    fd_set read_fds;
    FD_ZERO(&read_fds);
    FD_SET(fd, &read_fds);
    res = select(fd + 1, &read_fds, NULL, NULL, &timeout);
    if (res == -1) {
        return result;
    } else if (res == 0) {
        result.result = -2;
    } else {
        res = read(fd, data, sizeof(data));
        if (res == -1) {
            result.result = -3;
        } else if (data[0] == 'S' && data[1] == 1) {
            result.result = 1;
            result.layer = data[31];
        } else {
            result.result = 0;
        }
    }
    return result;
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
    #pragma omp parallel for
    for (int i = 0; i < devices; ++i){
        printf("%u => %s\n", i, device_paths[i]);
        layered[i] = is_layer_device(device_paths[i]);
    }

    

    for (int i = 0; i < devices; ++i){
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
    for (int i = 0; i < devices; ++i){
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

int main() {
    char layer;
    int res;
    char data[32] = {0};
    struct sockaddr_un addr;
    const char *socket_path = "/tmp/rofl.sock";
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

    for (int i = 0; i < kbs.len; ++i) {
        fds[i + 1].fd = kbs.kbs[i].fd;
        fds[i + 1].events = POLLIN;
    }
    
    printf("Layer: %u\n", layer);
    
    while (1) {
        res = poll(fds, kbs.len + 1, -1);
        if (res == -1) {
            perror("poll failed\n");
            break;
        }
        if (fds[0].revents & POLLIN) {
            int client_fd = accept(fds[1].fd, NULL, NULL);
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
                // TODO: combine each ...
                int size = snprintf(answer, 1024, "%u\n", layer);
                
                res = write(client_fd, answer, size);
                if (res == -1) {
                    perror("Failed to send state to Unix socket client");
                }
                printf("Sent layer state response to Unix socket client.\n");
            } 

            close(client_fd);
        }
        for (int i = 0; i < kbs.len; ++i) {
            if (fds[i + 1].revents & POLLIN && read_hid(&kbs.kbs[i]) == -1){
                perror("unable to read from hid device\n");
                res = -3;
                break;
            }
        }

    }
result:
    // TODO: cleanup
    for (int i = 0; i < kbs.len + 1; i++) {
        close(fds[i].fd);
    }
    return res;
}
