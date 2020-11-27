//
//  HCDownloadModel.m
//  DownloadPhotoFromDrone
//
//  Created by JSH on 2020/11/9.
//

#import "HCDownloadModel.h"
@implementation HCDownloadModel
- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self)
    {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (HCDownloadRealmModel *)storedInformationToRealm
{
    HCDownloadRealmModel * photoInfoRealm = [[HCDownloadRealmModel alloc]init];
    photoInfoRealm.composition_type = self.composition_type;
    photoInfoRealm.duration = self.duration;
    photoInfoRealm.file_format = self.file_format;
    photoInfoRealm.filetype = self.filetype;
    photoInfoRealm.fps = self.fps;
    photoInfoRealm.group_id = self.group_id;
    photoInfoRealm.height = self.height;
    photoInfoRealm.is_hdr = self.is_hdr;
    photoInfoRealm.media_id = self.media_id;
    photoInfoRealm.meta = self.meta;
    photoInfoRealm.name = self.name;
    photoInfoRealm.session_id = self.session_id;
    photoInfoRealm.shoot_mode = self.shoot_mode;
    photoInfoRealm.size = self.size;
    photoInfoRealm.thumb_height = self.thumb_height;
    photoInfoRealm.thumb_size = self.thumb_size;
    photoInfoRealm.thumb_width = self.thumb_width;
    photoInfoRealm.track_mode = self.track_mode;
    photoInfoRealm.trajectory_mode = self.trajectory_mode;
    photoInfoRealm.width = self.width;
    photoInfoRealm.photoDownloadType = PhotoDownloadTypeIdel;
    return photoInfoRealm;
}
@end
