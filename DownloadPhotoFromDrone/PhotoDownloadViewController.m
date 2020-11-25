//
//  ViewController.m
//  DownloadPhotoFromDrone
//
//  Created by JSH on 2020/11/2.
//

#import "PhotoDownloadViewController.h"
#import "HCMediaServer.h"
#import <Realm/Realm.h>
NSString *const host = @"http://192.168.1.1";
NSString *const mediaInfoApi = @"/info/media/";
NSString *const downloadMediaApi = @"/download/";
NSString *const mediaName = @"100HOVER_IMG_0006_33883af_jpg";

@interface PhotoDownloadViewController ()
@property (nonatomic, strong) HCDownloadRealmModel * photoInfo;
@property (nonatomic, strong) NSString *downloadUrl;
@property (nonatomic, strong) HCMediaServer *downloadPhotoServer ;
@property (nonatomic, assign) Boolean downloadThumb;
@property (nonatomic, strong) RLMRealm *realm;
@property (nonatomic, strong) UIImageView *downloadThumbnail;
@property (nonatomic, strong) UIButton *downloadPhotoBtn;

@end

@implementation PhotoDownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImageView *downloadThumbnail = self.downloadThumbnail;
    UIButton *downloadPhotoBtn = self.downloadPhotoBtn;
    [self refreshUIData];

    NSLog(@"===>%@",NSHomeDirectory());
}

#pragma mark 懒加载控件
- (UIImageView *)downloadThumbnail
{
    if(!_downloadThumbnail)
    {
        UIImageView *downloadThumbnail = [[UIImageView alloc]initWithFrame:CGRectMake(80, 100, 250, 117)];
        _downloadThumbnail = downloadThumbnail;
        _downloadThumbnail.backgroundColor = [UIColor redColor];
        _downloadThumbnail.contentMode = UIViewContentModeScaleAspectFill;
        [self.view addSubview:_downloadThumbnail];

    }
    return _downloadThumbnail;
}

- (UIButton *)downloadPhotoBtn
{
    if(!_downloadPhotoBtn)
    {
        _downloadPhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _downloadPhotoBtn.frame = CGRectMake(60, 350, 300, 30);
        _downloadPhotoBtn.backgroundColor = [UIColor blackColor];
        [_downloadPhotoBtn setTitle:@"下载缩略图" forState:UIControlStateNormal];
        [_downloadPhotoBtn addTarget:self action:@selector(downloadPhotoButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_downloadPhotoBtn];
    }
    return _downloadPhotoBtn;
}

- (void)refreshUIData
{
    HCMediaServer *downloadPhotoServer = [HCMediaServer new];
    
    self.downloadPhotoServer = downloadPhotoServer;
    
    [downloadPhotoServer getPhotoInfoFromHost:host
                                           api:mediaInfoApi
                                     mediaName:mediaName
                                    completion:
     ^(HCDownloadRealmModel * model) {
        
        self.photoInfo = model;
        dispatch_async(dispatch_get_main_queue(), ^{
            RLMRealm *realm = [RLMRealm defaultRealm];
            self.realm = realm;
            [realm beginWriteTransaction];
            [realm addOrUpdateObject:model];
            [realm commitWriteTransaction];
        });
    }];
    
    NSString *downloadUrlString = [downloadPhotoServer connectDownloadURLByHost:host Api:downloadMediaApi MediaName:mediaName andIsThumb:self.downloadThumb];
    [downloadUrlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *downloadUrl=[NSURL URLWithString:downloadUrlString];
    NSData *downloadUrlData=[NSData dataWithContentsOfURL:downloadUrl];
    self.downloadThumbnail.image=[UIImage imageWithData:downloadUrlData];
    self.downloadUrl = downloadUrlString;
}

- (void)downloadPhotoButton:(UIButton *)btn
{
    if (self.photoInfo.photoDownloadType == PhotoDownloadTypeIdel)
    {
        
        dispatch_queue_t que = dispatch_queue_create("com.vc.downloadPhotoQueue", DISPATCH_QUEUE_SERIAL);
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        dispatch_async(que, ^{
            self.downloadThumb = YES;
            [[HCMediaServer new] downloadFileFromHost:host Api:downloadMediaApi MediaName:mediaName andIsThumb:self.downloadThumb completion:^(NSString * downloadFilePath){
                // 更新数据库状态
                [self.photoInfo changeRealmPhotoDownloadType:PhotoDownloadTypeThumbnailDownload];
                [self.downloadPhotoBtn setTitle:@"已下载缩略图，正在下载原图" forState:UIControlStateNormal];
                dispatch_semaphore_signal(semaphore); // semaphore + 1
            }];
            
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            
            self.downloadThumb = NO;
            [[HCMediaServer new] downloadFileFromHost:host Api:downloadMediaApi MediaName:mediaName andIsThumb:self.downloadThumb completion:^(NSString * downloadFilePath){
                // 更新数据库状态
                [self.photoInfo changeRealmPhotoDownloadType:PhotoDownloadTypeOriginImageDownload];
                [self.downloadPhotoBtn setTitle:@"已下载原图" forState:UIControlStateNormal];
                
                // 照片存入相册
                NSData *imageData = [NSData dataWithContentsOfFile:downloadFilePath];
                UIImage* image = [[UIImage alloc] initWithData:imageData];
                UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
            }];
        });
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
}

@end
