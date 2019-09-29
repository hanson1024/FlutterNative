//
//  YXXFlutterNativePlugn.m
//  contact
//
//  Created by luo on 2019/9/29.
//  Copyright © 2019 gdtech. All rights reserved.
//

#import "YXXFlutterNativePlugn.h"

@implementation YXXFlutterNativePlugn

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"lianchu"
                                     binaryMessenger:[registrar messenger]];
    YXXFlutterNativePlugn* instance = [[YXXFlutterNativePlugn alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    
    NSLog(@"%s, %d", __FUNCTION__, __LINE__);
    
    if ([call.method isEqualToString:@"comeonman"]) {
        result(@"么么哒");
    }else {
        result(FlutterMethodNotImplemented);
    }
}

@end
