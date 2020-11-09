//
//  ViewController.m
//  DownloadPhotoFromDrone
//
//  Created by JSH on 2020/11/2.
//

#import "PhotoDownloadViewController.h"
#import "PhotoDownloadTask.h"
#import <SDWebImage/SDWebImage.h>
#import <Realm/Realm.h>
NSString *const host = @"http://192.168.1.1";
NSString *const mediaInfoApi = @"/info/media/";
NSString *const downloadMediaApi = @"/download/";
NSString *const mediaName = @"100CRTHD_IMGC0030_e2e2435_jpg";

@interface PhotoDownloadViewController ()
@property (nonatomic, strong)HCDownloadRealmModel * photoInfo;
@property (nonatomic, strong) NSString *downloadUrl;
@property (nonatomic, strong) PhotoDownloadTask *downloadPhotoManager ;
@property (nonatomic, assign) Boolean downloadThumb;
@property (nonatomic, strong) RLMRealm *realm;
@property (nonatomic, weak) UIButton *downloadPhotoBtn;

@end

@implementation PhotoDownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"===>%@",NSHomeDirectory());
    
    PhotoDownloadTask *downloadPhotoManager = [PhotoDownloadTask new];
    
    self.downloadPhotoManager = downloadPhotoManager;
    
    [downloadPhotoManager getPhotoInfoFromHost:host
                                           api:mediaInfoApi
                                     mediaName:mediaName
                                    completion:
     ^(HCDownloadRealmModel * model) {
        
        self.photoInfo = model;
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"===>dispatch_async线程%@",[NSThread currentThread]);
            
            RLMRealm *realm = [RLMRealm defaultRealm];
            self.realm = realm;
            [realm beginWriteTransaction];
            [realm addOrUpdateObject:model];
            [realm commitWriteTransaction];
        });
        
    }];
    
    UIImageView *downloadThumbnail = [[UIImageView alloc]initWithFrame:CGRectMake(80, 100, 250, 117)];
    downloadThumbnail.backgroundColor = [UIColor redColor];
    downloadThumbnail.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:downloadThumbnail];
    
    NSString *downloadUrl = [downloadPhotoManager connectDownloadURLByHost:host Api:downloadMediaApi MediaName:mediaName andIsThumb:self.downloadThumb];
    self.downloadUrl = downloadUrl;
    [downloadThumbnail sd_setImageWithURL:[NSURL URLWithString:downloadUrl]
                         placeholderImage:[UIImage imageNamed:@"loading.png"]];
    
    UIButton *downloadPhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.downloadPhotoBtn = downloadPhotoBtn;
    downloadPhotoBtn.frame = CGRectMake(60, 350, 300, 30);
    downloadPhotoBtn.backgroundColor = [UIColor blackColor];
    [downloadPhotoBtn setTitle:@"下载缩略图" forState:UIControlStateNormal];
    [downloadPhotoBtn addTarget:self action:@selector(downloadPhotoButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:downloadPhotoBtn];
}

-(void)downloadPhotoButton:(UIButton *)btn
{
    if (self.photoInfo.photoDownloadType == PhotoDownloadTypeIdel)
    {
        
        dispatch_queue_t que = dispatch_queue_create("com.vc.downloadPhotoQueue", DISPATCH_QUEUE_SERIAL);
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        dispatch_async(que, ^{
            self.downloadThumb = YES;
            [[PhotoDownloadTask new] downloadFileFromHost:host Api:downloadMediaApi MediaName:mediaName andIsThumb:self.downloadThumb completion:^(NSString * downloadFilePath){
                // 更新数据库状态
                [self.realm transactionWithBlock:^{
                    self.photoInfo.photoDownloadType = PhotoDownloadTypeThumbnailDownload;
                }];
                
                [self.downloadPhotoBtn setTitle:@"已下载缩略图，正在下载原图" forState:UIControlStateNormal];
                dispatch_semaphore_signal(semaphore); // semaphore + 1
            }];
            
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            
            self.downloadThumb = NO;
            [[PhotoDownloadTask new] downloadFileFromHost:host Api:downloadMediaApi MediaName:mediaName andIsThumb:self.downloadThumb completion:^(NSString * downloadFilePath){
                // 更新数据库状态
                [self.realm transactionWithBlock:^{
                    
                    self.photoInfo.photoDownloadType = PhotoDownloadTypeOriginImageDownload;
                }];
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
