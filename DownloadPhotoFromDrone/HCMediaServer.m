//
//  HCMediaServer.m
//  DownloadPhotoFromDrone
//
//  Created by JSH on 2020/11/2.
//

#import "HCMediaServer.h"

@implementation HCMediaServer
- (void)getPhotoInfoFromHost:(NSString*)url
                         api:(NSString *)api
                   mediaName:(NSString *)mediaName
                  completion:(void (^)(HCDownloadRealmModel *))completionAtion
{
    NSString *getUrl = [NSString stringWithFormat:@"%@%@?name=%@", url, api, mediaName];
    NSLog(@"====getUrl>%@",getUrl);
    NSURL* downloadUrl = [NSURL URLWithString:getUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:downloadUrl];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:120.0];
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionTask* task = [session dataTaskWithRequest:request
                                        completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                              {
        if (error == nil)
        {
            NSArray* jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSMutableDictionary * dicInfo = [jsonArray objectAtIndex:0];
            HCDownloadModel *jsonInfo  = [[HCDownloadModel alloc]initWithDictionary:dicInfo];
            HCDownloadRealmModel * realmModel = [jsonInfo storedInformationToRealm];
            if (completionAtion != nil)
            {
                completionAtion(realmModel); // callback
            }
        }
        else
        {
            NSLog(@"请求失败:%@",error);
        }
    }];
    [task resume];
}

- (NSString *)connectDownloadURLByHost:(NSString*)host Api:(NSString *)api MediaName:(NSString *)mediaName andIsThumb:(Boolean)isThumb
{
    NSString *isThumbString = {isThumb?@"true":@"false"};
    NSString *downloadUrl = [NSString stringWithFormat:@"%@%@%@?is_thumb=%@", host, api, mediaName,isThumbString];
    return downloadUrl;
}

- (void)downloadFileFromHost:(NSString*)host Api:(NSString *)api MediaName:(NSString *)mediaName andIsThumb:(Boolean)isThumb completion:(nullable void(^)(NSString *))completionAction
{
    NSString *downloadUrl = [self connectDownloadURLByHost:host Api:api MediaName:mediaName andIsThumb:isThumb];
    [self downloadFileFromURL:downloadUrl completion:^(NSString *downloadFilePath) {
        completionAction(downloadFilePath);
    }];
}

- (void)downloadFileFromURL:(NSString*)urlString completion:(nullable void(^)(NSString *))completionAction
{
    NSURL *url = [NSURL URLWithString:urlString];
    NSLog(@"downloadPhotoURL:%@",url);
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    /* 下载路径创建，指定下载到沙盒Documents/Announcement文件夹中 */
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Thumbnail"];
    [self createNewFolder:path];
    NSString *downloadFilePath = [path stringByAppendingPathComponent:url.lastPathComponent];
    NSLog(@"%@",NSHomeDirectory());

    NSURLSession *session=[NSURLSession sharedSession];
    NSURLSessionDownloadTask *downloadTask=[session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSError *saveError;
            NSURL *downloadFilePathUrl=[NSURL fileURLWithPath:downloadFilePath];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if ([fileManager fileExistsAtPath:downloadFilePath]) {
                  //若存在则删除目标文件再 move
                  [fileManager removeItemAtPath:downloadFilePath error:&saveError];
              }
            [[NSFileManager defaultManager] moveItemAtURL:location toURL:downloadFilePathUrl error:&saveError];
            if (!saveError) {
                NSLog(@"save sucess.");
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionAction(downloadFilePath);
                });
            }else{
                NSLog(@"error is :%@",saveError.localizedDescription);
            }
        }else{
            NSLog(@"error is :%@",error.localizedDescription);
        }
    }];

    [downloadTask resume];

}

#pragma mark 创建新文件夹
- (void)createNewFolder:(NSString *)dirPath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL existed = [fileManager fileExistsAtPath:dirPath isDirectory:&isDir];
    if (!(isDir && existed)) {
        [fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

@end
