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
#import "ReadBinaryPList.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *macAddress = [OAUtil getMacAddressForInterface:UseNetworkInterface];
    NSNetService *services = [[NSNetService alloc] initWithDomain:PublishingDomain type:AirPlayServiceType name:PublishingName port:AirPlayPort];
    services.delegate = self;


    NSDictionary *txtRecordDic = @{
    @"features":@"0x4A7FFFF7,0xE",
    @"flags":@"0x4",
    @"srcvers":@"220.68",
    @"vv":@"2",
    @"pi":@"4de11299-e97b-479b-8207-8359b12039a5",
    @"pk":@"d84264f17cbb4c4f23c3037203f0d171c86b4a613c0c7ff15f8aac0028981259",
    @"model":@"AppleTV5,3",
    @"deviceid":macAddress
    };
    
    NSData* txtRecordData = txtRecordData = [NSNetService dataFromTXTRecordDictionary: txtRecordDic];
    [services setTXTRecordData:txtRecordData];
    
    [services scheduleInRunLoop: [NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];

    [services publish];
    
    service = services;
    
    
    
    
    webServer =  [[GCDWebServer alloc] init];
    webServer.delegate = self;
    
    
    [webServer addHandlerWithMatchBlock:^GCDWebServerRequest *(NSString* requestMethod, NSURL* requestURL, NSDictionary* requestHeaders, NSString* urlPath, NSDictionary* urlQuery) {
        
        return [[GCDWebServerRequest alloc] initWithMethod:requestMethod url:requestURL headers:requestHeaders path:urlPath query:urlQuery];
        
    } processBlock:^GCDWebServerResponse *(GCDWebServerRequest* request) {
        
        NSString *method = request.method;
        NSString *url = request.URL.relativePath;
        NSString *path = request.path;
        NSString *contentType = request.contentType;
        
        
//        id  dics =   [ReadBinaryPList ReadBinaryPListData:];

        
        NSLog(@"method=%@ url=%@ path=%@ contentType=%@",method,url,path,contentType);
        
        GCDWebServerResponse *response = nil;
        
        
        if ([method isEqualToString:@"POST"]) {
            
            if ([path isEqualToString:@"/pair-setup"]) {
                
                response = [[GCDWebServerResponse alloc] init];
                response.contentType = @"application/octet-stream";
                response.contentLength = 32;//string.length;
                response.statusCode = 200;
                [response setValue:@"AirTunes/220.68" forAdditionalHeader:@"Server"];
                [response setValue:@"0" forAdditionalHeader:@"CSeq"];
                
                
            }
            
            if ([path isEqualToString:@"/pair-verify"]) {
                
                response = [[GCDWebServerResponse alloc] init];
                response.contentType = @"application/octet-stream";
                response.contentLength = 96;//string.length;
                response.statusCode = 200;
                [response setValue:@"AirTunes/220.68" forAdditionalHeader:@"Server"];
                [response setValue:@"1" forAdditionalHeader:@"CSeq"];
                
                
            }
            
            
        }else if([method isEqualToString:@"GET"])
          {
              if ([path isEqualToString:@"/info"])
              {
                   response = [[GCDWebServerResponse alloc] init];
                   response.contentType = @"text/x-apple-plist+xml";
                   response.contentLength = 96;//string.length;
                   response.statusCode = 200;
                   [response setValue:@"AirTunes/220.68" forAdditionalHeader:@"Server"];
                   [response setValue:@"1" forAdditionalHeader:@"CSeq"];
                               
              }
        }
        
        return response;
        
    }];
    
    [webServer startWithOptions:@{GCDWebServerOption_AutomaticallyMapHEADToGET:@NO
                                  ,GCDWebServerOption_Port: @7000,
                                   GCDWebServerOption_BonjourName:PublishingName
                                   
                                   } error:nil];
       
       
}

- (void)disconnectAction {
    [socket disconnect];
}


- (void)connectAction{
    
    if (![socket isConnected]) {
        socket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        NSError *err = nil;
        if(![socket acceptOnPort:7000 error:&err])
        {
            NSLog(@"connect err%@",err);
        }else
        {
            NSLog(@"connect sucess");
        }
    }else{
        NSLog(@"has connect");
    }
    
}

- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket{
    NSLog(@"%s",__func__);
    
    //解决clientsocket是局部变量导致连接关闭的状况
    [clientSocket addObject:newSocket];

    //-1表示永不超时
    [newSocket readDataWithTimeout:-1 tag:0];
}

//读取客户端的数据
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSData * dataStr = [OAUtil UTF8Data:data];
    NSString * str  =[[NSString alloc] initWithData:dataStr encoding:NSUTF8StringEncoding];
    NSLog(@"didReadData：%@",str);

    [socket readDataWithTimeout:-1 tag:0];
}

-(void)netServiceDidPublish:(NSNetService *)sender{
    NSLog(@"%s",__func__);

    NSLog(@"netServiceDidPublish-%@",sender);
    
    [self connectAction];
}
-(void)netServiceWillPublish:(NSNetService *)sender{
    NSLog(@"%s",__func__);

    NSLog(@"netServiceWillPublish-%@",sender);

}

-(void)netService:(NSNetService *)sender didNotPublish:(NSDictionary<NSString *,NSNumber *> *)errorDict{
    NSLog(@"%s",__func__);

}

-(void)netServiceDidStop:(NSNetService *)sender{
    NSLog(@"%s",__func__);

}

-(void)netServiceWillResolve:(NSNetService *)sender{
    NSLog(@"%s",__func__);

}

-(void)netService:(NSNetService *)sender didNotResolve:(NSDictionary<NSString *,NSNumber *> *)errorDict{
    NSLog(@"%s",__func__);

}

-(void)netServiceDidResolveAddress:(NSNetService *)sender{
    NSLog(@"%s",__func__);
}

-(void)netService:(NSNetService *)sender didUpdateTXTRecordData:(NSData *)data{
    NSLog(@"%s",__func__);

}


-(void)netService:(NSNetService *)sender didAcceptConnectionWithInputStream:(NSInputStream *)inputStream outputStream:(NSOutputStream *)outputStream{
    NSLog(@"%s",__func__);

}


/**
 *  This method is called after the server has successfully started.
 */
- (void)webServerDidStart:(GCDWebServer*)server
{
    

}

/**
 *  This method is called after the Bonjour registration for the server has
 *  successfully completed.
 *
 *  Use the "bonjourServerURL" property to retrieve the Bonjour address of the
 *  server.
 */
- (void)webServerDidCompleteBonjourRegistration:(GCDWebServer*)server
{
    
}

/**
 *  This method is called after the NAT port mapping for the server has been
 *  updated.
 *
 *  Use the "publicServerURL" property to retrieve the public address of the
 *  server.
 */
- (void)webServerDidUpdateNATPortMapping:(GCDWebServer*)server
{
    
}

/**
 *  This method is called when the first GCDWebServerConnection is opened by the
 *  server to serve a series of HTTP requests.
 *
 *  A series of HTTP requests is considered ongoing as long as new HTTP requests
 *  keep coming (and new GCDWebServerConnection instances keep being opened),
 *  until before the last HTTP request has been responded to (and the
 *  corresponding last GCDWebServerConnection closed).
 */
- (void)webServerDidConnect:(GCDWebServer*)server
{
    
}

/**
 *  This method is called when the last GCDWebServerConnection is closed after
 *  the server has served a series of HTTP requests.
 *
 *  The GCDWebServerOption_ConnectedStateCoalescingInterval option can be used
 *  to have the server wait some extra delay before considering that the series
 *  of HTTP requests has ended (in case there some latency between consecutive
 *  requests). This effectively coalesces the calls to -webServerDidConnect:
 *  and -webServerDidDisconnect:.
 */
- (void)webServerDidDisconnect:(GCDWebServer*)server
{
    
}

/**
 *  This method is called after the server has stopped.
 */
- (void)webServerDidStop:(GCDWebServer*)server
{
    
}



- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
