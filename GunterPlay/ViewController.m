//
//  ViewController.m
//  GunterPlay
//
//  Created by TianYuan on 2020/4/11.
//  Copyright © 2020 TianYuan. All rights reserved.
//

#import "ViewController.h"
#import <Foundation/Foundation.h>
#import "OAUtil.h"
#import "Constants.h"



@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CFSocketContext context = { 0, (__bridge void *) self, NULL, NULL, NULL };


    
    NSString *publishingDomain =  @"local.";
    NSString *macAddress = [OAUtil getMacAddressForInterface:UseNetworkInterface];
     
     NSString *publishingName = @"GunterPlay";
 
    NSNetService *service = [[NSNetService alloc] initWithDomain:publishingDomain type:AirPlayServiceType name:publishingName port:AirPlayPort];
    
    NSDictionary *txtRecordDic = @{
    @"features":@"0x4A7FFFF7,0xE",
    @"flags":@"0x44",
    @"srcvers":@"220.68",
    @"vv":@"2",
    @"pi":@"fad7d0c8-b455-4d94-97e9-8f7829208e82",
    @"pk":@"6b589171628bf0e052aedd517fbb751164a4e3f0ecd33fb37c4e956475da24a6",
    @"model":@"AppleTV5,3",
    @"deviceid":macAddress
    };
    
    

    NSData*txtRecordData = nil;
    service.delegate = self;

    if(txtRecordDic)
    txtRecordData = [NSNetService dataFromTXTRecordDictionary: txtRecordDic];
    [service setTXTRecordData:txtRecordData];
    
    self->service = service;

    
     NSRunLoop *mainRunLoop = [NSRunLoop currentRunLoop];
      
    [service scheduleInRunLoop:mainRunLoop forMode:NSDefaultRunLoopMode];

    [service publish];

    
}



-(void)netServiceDidPublish:(NSNetService *)sender{
    NSLog(@"netServiceDidPublish-%@",sender);
    
//    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//
//    dispatch_async(concurrentQueue, ^{
//    NSRunLoop *mainRunLoop = [NSRunLoop currentRunLoop];
//    NSNetServiceBrowser* browser = [[NSNetServiceBrowser alloc] init];
//    browser.delegate = self;
//    [browser scheduleInRunLoop:mainRunLoop forMode:NSRunLoopCommonModes];
//    [browser searchForServicesOfType:AirPlayServiceType inDomain:@"local."]; [mainRunLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:30]]; });
//
}
-(void)netServiceWillPublish:(NSNetService *)sender{
    NSLog(@"netServiceWillPublish-%@",sender);

}

-(void)netService:(NSNetService *)sender didNotPublish:(NSDictionary<NSString *,NSNumber *> *)errorDict{
    
}

-(void)netServiceDidStop:(NSNetService *)sender{
    
}

-(void)netServiceWillResolve:(NSNetService *)sender{
    
}

-(void)netService:(NSNetService *)sender didNotResolve:(NSDictionary<NSString *,NSNumber *> *)errorDict{
    
}

-(void)netServiceDidResolveAddress:(NSNetService *)sender{
    NSLog(@"%s",__func__);
    NSData *address = [sender.addresses firstObject];
    struct sockaddr_in *socketAddress = (struct sockaddr_in *) [address bytes];
    NSString *hostName = [sender hostName];
    Byte *bytes = (Byte *)[[sender TXTRecordData] bytes];
    int8_t lenth = (int8_t)bytes[0];
    const void*textData = &bytes[1];
    NSLog(@"server info: ip:%s, hostName:%@, text:%s, length:%d",socketAddress,hostName,textData,lenth);
    
}

-(void)netService:(NSNetService *)sender didUpdateTXTRecordData:(NSData *)data{
    
}


-(void)netService:(NSNetService *)sender didAcceptConnectionWithInputStream:(NSInputStream *)inputStream outputStream:(NSOutputStream *)outputStream{
    
}






/*
 * 即将查找服务
 */
- (void)netServiceBrowserWillSearch:(NSNetServiceBrowser *)browser {
    NSLog(@"-----------------netServiceBrowserWillSearch");
}

/*
 * 停止查找服务
 */
- (void)netServiceBrowserDidStopSearch:(NSNetServiceBrowser *)browser {
    NSLog(@"-----------------netServiceBrowserDidStopSearch");
}

/*
 * 查找服务失败
 */
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didNotSearch:(NSDictionary<NSString *, NSNumber *> *)errorDict {
    NSLog(@"----------------netServiceBrowser didNotSearch");
}

/*
 * 发现域名服务
 */
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didFindDomain:(NSString *)domainString moreComing:(BOOL)moreComing {
    NSLog(@"---------------netServiceBrowser didFindDomain");
}

/*
 * 发现客户端服务
 */
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didFindService:(NSNetService *)service moreComing:(BOOL)moreComing {
    NSLog(@"didFindService---------=%@  =%@  =%@",service.name,service.addresses,service.hostName);

}

/*
 * 域名服务移除
 */
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didRemoveDomain:(NSString *)domainString moreComing:(BOOL)moreComing {
    NSLog(@"---------------netServiceBrowser didRemoveDomain");
}

/*
 * 客户端服务移除
 */
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didRemoveService:(NSNetService *)service moreComing:(BOOL)moreComing {
    NSLog(@"---------------netServiceBrowser didRemoveService");
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
