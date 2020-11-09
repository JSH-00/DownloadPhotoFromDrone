//
//  PhotoDownloadManager.m
//  DownloadPhotoFromDrone
//
//  Created by JSH on 2020/11/2.
//

#import "PhotoDownloadTask.h"

@implementation PhotoDownloadTask
- (void)getPhotoInfoFromHost:(NSString*)url
                         api:(NSString *)api
                   mediaName:(NSString *)mediaName
                  completion:(void (^)(HCDownloadRealmModel *))completionAtion
{
    NSString *getUrl = [NSString stringWithFormat:@"%@%@?name=%@", url, api, mediaName];
    NSLog(@"====getUrl>%@",getUrl);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    [manager GET:getUrl
      parameters:nil headers:nil
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  responseObject) {
        
        HCDownloadRealmModel *callBackModel  = [[HCDownloadRealmModel alloc]initWithDictionary:[(NSArray *)responseObject objectAtIndex:0]];

        if (completionAtion != nil) {
            NSLog(@"%@",NSHomeDirectory());
            completionAtion(callBackModel); //执行
        }
    }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败--%@",error);
        //        failureAtcion(task, error);
    }];
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
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    self.downloadSessionTask = [manager downloadTaskWithRequest:request
                                                            progress:
                                ^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"下载进度：%.0f％，线程：%@", downloadProgress.fractionCompleted * 100, [NSThread currentThread]);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:downloadFilePath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        NSLog(@"下载完成");
        completionAction(downloadFilePath);
    }];
    [self.downloadSessionTask resume];
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
