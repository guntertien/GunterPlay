//
//  ViewController.h
//  GunterPlay
//
//  Created by TianYuan on 2020/4/11.
//  Copyright © 2020 TianYuan. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController<NSNetServiceDelegate,NSNetServiceBrowserDelegate>
{
    NSNetService *service;
    NSNetServiceBrowser* browser;

}

@end

