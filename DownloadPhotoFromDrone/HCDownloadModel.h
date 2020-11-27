//
//  HCDownloadModel.h
//  DownloadPhotoFromDrone
//
//  Created by JSH on 2020/11/9.
//

#import <Foundation/Foundation.h>
#import "HCDownloadRealmModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HCDownloadModel : NSObject
@property (nonatomic, assign) int ctime;
@property (nonatomic, assign) NSNumber *composition_type;
@property (nonatomic, strong) NSNumber *duration;
@property (nonatomic, strong) NSNumber *file_format;
@property (nonatomic, strong) NSNumber *filetype;
@property (nonatomic, strong) NSNumber *fps;
@property (nonatomic, strong) NSNumber *group_id;
@property (nonatomic, strong) NSNumber *height;
@property (nonatomic, strong) NSNumber *is_hdr;
@property (nonatomic, strong) NSNumber *media_id;
@property (nonatomic, strong) NSString *meta;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *session_id;
@property (nonatomic, strong) NSNumber *shoot_mode;
@property (nonatomic, strong) NSNumber *size;
@property (nonatomic, strong) NSNumber *thumb_height;
@property (nonatomic, strong) NSNumber *thumb_size;
@property (nonatomic, strong) NSNumber *thumb_width;
@property (nonatomic, strong) NSNumber *track_mode;
@property (nonatomic, strong) NSNumber *trajectory_mode;
@property (nonatomic, strong) NSNumber *width;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (HCDownloadRealmModel *)storedInformationToRealm;
@end

NS_ASSUME_NONNULL_END
