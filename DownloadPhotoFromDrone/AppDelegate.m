//
//  AppDelegate.m
//  DownloadPhotoFromDrone
//
//  Created by JSH on 2020/11/2.
//

#import "AppDelegate.h"

@interface AppDelegate ()
{
    GCDWebUploader* _webUploader;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    NSString* documentsPath =  NSHomeDirectory();
    _webUploader = [[GCDWebUploader alloc] initWithUploadDirectory:documentsPath];
    [_webUploader start];
    NSLog(@"Visit %@ in your web browser", _webUploader.serverURL);
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application{
    
}
- (void)applicationDidEnterBackground:(UIApplication *)application{
    
}
- (void)applicationWillEnterForeground:(UIApplication *)application{
    
}
- (void)applicationDidBecomeActive:(UIApplication *)application{
    
}
- (void)applicationWillTerminate:(UIApplication *)application{
    
}

@end
