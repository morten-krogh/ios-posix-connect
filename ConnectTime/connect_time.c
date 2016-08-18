//
//  connect_time.c
//  ConnectTime
//
//  Created by Morten Krogh on 17/08/16.
//  Copyright © 2016 Amber Biosicences. All rights reserved.
//

#include "connect_time.h"

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/ip.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <errno.h>

int connect_to_server()
{
    int sock_fd = socket(PF_INET, SOCK_STREAM, 0);

    if (sock_fd == -1)
        return -1;

    struct sockaddr_in sa;

    const char* ip_addr = "212.116.89.62";
    uint16_t port = 80;

    memset(&sa, 0, sizeof(struct sockaddr_in));
    sa.sin_family = AF_INET;
    sa.sin_addr.s_addr = inet_addr(ip_addr);
    sa.sin_port = htons(port);

    int rc = connect(sock_fd, (struct sockaddr *)&sa, sizeof(sa));
    if (rc == -1) {
        printf("Error in connect: %s\n", strerror(errno));
        return -2;
    }

    const char request[] = "GET http://www.amberbio.com/connect_time HTTP/1.1\r\n\r\n";

    ssize_t bytes_written = write(sock_fd, request, sizeof(request) - 1);
    if (bytes_written != sizeof(request) - 1) {
        close(sock_fd);
        return -3;
    }

    char response[1000];
    ssize_t bytes_read = read(sock_fd, response, 1000);
    if (bytes_read < 12) {
        close(sock_fd);
        return -4;
    }
//    printf("bytes read = %zd\n\n", bytes_read);

//    printf("%s\n", response);

    if (strncmp(response, "HTTP/1.1 400", 12) != 0) {
//        printf("incorrect response\n");
        close(sock_fd);
        return -4;
    }

    rc = close(sock_fd);
    if (rc == -1) {
//        printf("Error in close: %s\n", strerror(errno));
        return -5;
    }
    
    return 0;
}
