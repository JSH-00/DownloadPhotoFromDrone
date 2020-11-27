//
//  HCDownloadModel.m
//  DownloadPhotoFromDrone
//
//  Created by JSH on 2020/11/2.
//

#import "HCDownloadRealmModel.h"

@implementation HCDownloadRealmModel
- (void)changeRealmPhotoDownloadType:(PhotoDownloadType)photoDownloadType
{
    [self.realm transactionWithBlock:^{
        self.photoDownloadType = photoDownloadType;
    }];
}
+ (NSString *)primaryKey {
    return @"ctime";
}
@end
