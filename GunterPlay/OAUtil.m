#include <sys/types.h>
#include <stdio.h>
#include <string.h>
#include <sys/socket.h>
#include <net/if_dl.h>
#include <ifaddrs.h>

#define IFT_ETHER 0x6

#import "OAUtil.h"

@implementation OAUtil

+ (NSString *) getMacAddressForInterface:(NSString *)ifName {
    struct ifaddrs           *addrs;
    struct ifaddrs           *cursor;
    const struct sockaddr_dl *dlAddr;
    const unsigned char      *base;
    char                      macAddress[18];
    
    if (getifaddrs(&addrs) == 0) {
        cursor = addrs;
        
        while (cursor != 0) {
            if ((cursor->ifa_addr->sa_family == AF_LINK) &&
                (((const struct sockaddr_dl *) cursor->ifa_addr)->sdl_type == IFT_ETHER) &&
                [ifName isEqualToString:[NSString stringWithUTF8String:cursor->ifa_name]]) {
                
                dlAddr = (const struct sockaddr_dl *) cursor->ifa_addr;
                base = (const unsigned char *) &dlAddr->sdl_data[dlAddr->sdl_nlen];
                
                strcpy(macAddress, "");
                
                for (int i = 0; i < dlAddr->sdl_alen; i++) {
                    if (i > 0) {
                        strcat(macAddress, ":");
                    }
                    char partialAddr[3];
                    sprintf(partialAddr, "%02X", base[i]);
                    strcat(macAddress, partialAddr);
                }
            }
            
            cursor = cursor->ifa_next;
        }
        
        freeifaddrs(addrs);
    }
    
    return [[NSString alloc] initWithCString:macAddress encoding:NSMacOSRomanStringEncoding];
}

@end
