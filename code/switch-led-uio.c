#include <sys/mman.h>
#include <stdio.h>
#include <errno.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>

int read_value(char *filename, long *dst){
    int fd;
    char tmp_buf[64];
    long val;

    fd = open(filename, O_RDONLY);
    if (fd < 0)
        return -1;

    if(read(fd, tmp_buf, sizeof(tmp_buf)) <= 0) {
        close(fd);
        return -1;
    }

    close(fd);

    *dst = strtol(tmp_buf, NULL, 16);
    return 0;
}

int main(){
    int dev_file, status;
    long offset, len;
    
    void *ptr_uio;

    if(read_value("/sys/class/uio/uio0/maps/map0/offset", &offset)){
        perror("Failed to read uio0 driver map0 offset.");
        return 1;
    }

    if(read_value("/sys/class/uio/uio0/maps/map0/size", &len)){
        perror("Failed to read uio0 driver map0 size.");
        return 1;
    }

    printf("Offset is 0x%x\n", offset);
    printf("Size is 0x%x\n", len);

    dev_file = open("/dev/uio0", O_RDWR | O_SYNC);
    if(dev_file < 0){
        perror("Failed to open device file /dev/uio0");
        return 1;
    }

    ptr_uio = mmap(NULL, len, PROT_READ | PROT_WRITE, MAP_SHARED, dev_file, 0*4096);

    if(ptr_uio == MAP_FAILED){
        perror("mmap failed to map /dev/uio0");
        close(dev_file);
        return 1;
    }

    if(*((char*) ptr_uio))
        *((char*) ptr_uio) = 0;
    else
        *((char*) ptr_uio) = 1;

    munmap(ptr_uio, len);
    close(dev_file);

    return 0;
}
