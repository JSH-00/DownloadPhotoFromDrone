//
//  PhotoDownloadManager.h
//  DownloadPhotoFromDrone
//
//  Created by JSH on 2020/11/2.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import <Realm/Realm.h>
#import "HCDownloadModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface PhotoDownloadTask : NSObject
@property (nonatomic, strong) NSURLSessionDownloadTask* downloadSessionTask;
@property (nonatomic, strong) NSString *downloadUrl;

- (void)getPhotoInfoFromHost:(NSString*)url api:(NSString *)api mediaName:(NSString *)mediaName  completion:(nullable void (^)(HCDownloadRealmModel *))completion;

- (NSString *)connectDownloadURLByHost:(NSString*)host Api:(NSString *)api MediaName:(NSString *)mediaName andIsThumb:(Boolean)isThumb;

- (void)downloadFileFromHost:(NSString*)host Api:(NSString *)api MediaName:(NSString *)mediaName andIsThumb:(Boolean)isThumb completion:(nullable void(^)(NSString *))completionAction;

- (void)downloadFileFromURL:(NSString*)urlString completion:(nullable void(^)(NSString *))completion;
@end

NS_ASSUME_NONNULL_END
