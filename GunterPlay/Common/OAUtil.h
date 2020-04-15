#import <Foundation/Foundation.h>

@interface OAUtil : NSObject

+ (NSString *) getMacAddressForInterface:(NSString *)ifName;
+ (NSData *)UTF8Data:(NSData *)sourceData;

@end
