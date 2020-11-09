//
//  HCDownloadModel.m
//  DownloadPhotoFromDrone
//
//  Created by JSH on 2020/11/2.
//

#import "HCDownloadRealmModel.h"

@implementation HCDownloadRealmModel
- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self)
    {
        [self setValuesForKeysWithDictionary:dict];
        self.photoDownloadType = PhotoDownloadTypeIdel;
    }
    return self;
}

+ (NSString *)primaryKey {
    return @"ctime";
}
@end
