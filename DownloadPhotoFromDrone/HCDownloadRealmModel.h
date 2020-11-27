//
//  HCDownloadModel.h
//  DownloadPhotoFromDrone
//
//  Created by JSH on 2020/11/2.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

@interface HCDownloadRealmModel : RLMObject
typedef NS_ENUM(NSInteger, PhotoDownloadType)
{
    PhotoDownloadTypeIdel = 0,
    PhotoDownloadTypeOriginImageDownload,
    PhotoDownloadTypeThumbnailDownload
};
@property (nonatomic, assign) PhotoDownloadType photoDownloadType;
@property (nonatomic, assign) int ctime;
@property (nonatomic, assign) NSNumber<RLMInt> *composition_type;
@property (nonatomic, strong) NSNumber<RLMInt> *duration;
@property (nonatomic, strong) NSNumber<RLMInt> *file_format;
@property (nonatomic, strong) NSNumber<RLMInt> *filetype;
@property (nonatomic, strong) NSNumber<RLMInt> *fps;
@property (nonatomic, strong) NSNumber<RLMInt> *group_id;
@property (nonatomic, strong) NSNumber<RLMInt> *height;
@property (nonatomic, strong) NSNumber<RLMInt> *is_hdr;
@property (nonatomic, strong) NSNumber<RLMInt> *media_id;
@property (nonatomic, strong) NSString *meta;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber<RLMInt> *session_id;
@property (nonatomic, strong) NSNumber<RLMInt> *shoot_mode;
@property (nonatomic, strong) NSNumber<RLMInt> *size;
@property (nonatomic, strong) NSNumber<RLMInt> *thumb_height;
@property (nonatomic, strong) NSNumber<RLMInt> *thumb_size;
@property (nonatomic, strong) NSNumber<RLMInt> *thumb_width;
@property (nonatomic, strong) NSNumber<RLMInt> *track_mode;
@property (nonatomic, strong) NSNumber<RLMInt> *trajectory_mode;
@property (nonatomic, strong) NSNumber<RLMInt> *width;
- (void)changeRealmPhotoDownloadType:(PhotoDownloadType)photoDownloadType;
@end
