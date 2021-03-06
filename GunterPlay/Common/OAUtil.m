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



+ (NSData *)UTF8Data:(NSData *)sourceData
{
    //保存结果
    NSMutableData *resData = [[NSMutableData alloc] initWithCapacity:sourceData.length];

    //无效编码替代符号(常见 � □ ?)
    NSData *replacement = [@"�" dataUsingEncoding:NSUTF8StringEncoding];

    uint64_t index = 0;
    const uint8_t *bytes = sourceData.bytes;

    while (index < sourceData.length)
    {
        uint8_t len = 0;
        uint8_t header = bytes[index];

        //单字节
        if ((header&0x80) == 0)
        {
            len = 1;
        }
        //2字节(并且不能为C0,C1)
        else if ((header&0xE0) == 0xC0)
        {
            if (header != 0xC0 && header != 0xC1)
            {
                len = 2;
            }
        }
        //3字节
        else if((header&0xF0) == 0xE0)
        {
            len = 3;
        }
        //4字节(并且不能为F5,F6,F7)
        else if ((header&0xF8) == 0xF0)
        {
            if (header != 0xF5 && header != 0xF6 && header != 0xF7)
            {
                len = 4;
            }
        }

        //无法识别
        if (len == 0)
        {
            [resData appendData:replacement];
            index++;
            continue;
        }

        //检测有效的数据长度(后面还有多少个10xxxxxx这样的字节)
        uint8_t validLen = 1;
        while (validLen < len && index+validLen < sourceData.length)
        {
            if ((bytes[index+validLen] & 0xC0) != 0x80)
                break;
            validLen++;
        }

        //有效字节等于编码要求的字节数表示合法,否则不合法
        if (validLen == len)
        {
            [resData appendBytes:bytes+index length:len];
        }else
        {
            [resData appendData:replacement];
        }

        //移动下标
        index += validLen;
    }

    return resData;
}



@end
