//
//  AppDelegate.m
//  MyWXDemo
//
//  Created by mkrq-yh on 2018/10/11.
//  Copyright © 2018年 mkrq-yh. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [WXApi registerApp:@"wx2eb7d1548687b9ea"];
    
    return YES;
}

#pragma mark -WXApiDelegate协议方法
- (void) onReq:(BaseReq *)req {
    
}
- (void) onResp:(BaseResp *)resp {
    NSLog(@"errCode==%d",resp.errCode);
    if ([resp isKindOfClass:[SendAuthResp class]]) {//微信授权登录类
        SendAuthResp *rep = (SendAuthResp *)resp;
        if (rep.errCode == 0) {//授权成功
            NSLog(@"授权成功 code=%@",rep.code);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"WXAuthorizationSuccess" object:@{@"code":rep.code} userInfo:nil];
        }
    } else if ([resp isKindOfClass:[SendMessageToWXResp class]]) {//微信分享类
        SendMessageToWXResp *rep = (SendMessageToWXResp *)resp;
        if (rep.errCode == 0) {
            NSLog(@"微信分享成功%@",rep.lang);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"WXShareSuccess" object:@{@"result":@"success"} userInfo:nil];
        }
    }
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
    return [WXApi handleOpenURL:url delegate:self];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
