//
//  ViewController.h
//  GunterPlay
//
//  Created by TianYuan on 2020/4/11.
//  Copyright © 2020 TianYuan. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GCDAsyncSocket.h"

#import <GCDWebServer.h>
#import <GCDWebServer/GCDWebServerDataResponse.h>

@interface ViewController : NSViewController<NSNetServiceDelegate,GCDAsyncSocketDelegate,GCDWebServerDelegate>
{
    NSNetService *service;
    GCDAsyncSocket *socket;
    NSThread *heartThread;
    NSMutableArray *clientSocket;
    GCDWebServer *webServer;

}

@end

