//
//  VideoFragmentViewController.m
//  YouJieQu
//
//  Created by user on 2018/10/17.
//  Copyright © 2018年 user. All rights reserved.
//

#import "VideoFragmentViewController.h"
#import "SDCycleScrollView.h"
#import "VideoUrlViewController.h"
#import <BmobSDK/BmobUser.h>
#import <BmobSDK/BmobQuery.h>
#import "MBProgressHUD+XMG.h"

@interface VideoFragmentViewController ()<SDCycleScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *equalSafeView;
@property (strong, nonatomic) IBOutlet UIButton *btnaiqiyi;
@property (strong, nonatomic) IBOutlet UIButton *btntengxun;
@property (strong, nonatomic) IBOutlet UIButton *btnsouhu;
@property (strong, nonatomic) IBOutlet UIButton *btnyouku;
@property (strong, nonatomic) IBOutlet UIButton *btnmangguo;
@property (strong, nonatomic) IBOutlet UIButton *btntudou;
@property (strong, nonatomic) IBOutlet UIButton *btnM1905;
@property (strong, nonatomic) IBOutlet UIButton *btnleshi;
@property (strong, nonatomic) IBOutlet UIButton *btnppshipin;
@property (strong, nonatomic) IBOutlet UIButton *btnlishipin;
@property (strong, nonatomic) IBOutlet UIButton *btndongman;
@property (strong, nonatomic) IBOutlet UIButton *btntv;
@property (strong, nonatomic) NSString *webUrl;
@property (strong ,nullable) NSArray *jiexiUrlList;



@end

@implementation VideoFragmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];//用来更改push的下个控制器返回按钮title
    
    NSArray *imagesURLStrings = @[
                                  @"https://wx2.sinaimg.cn/mw690/b0653590gy1fv0zcugl7ij20hs0bv0t5.jpg",
                                  @"https://wx2.sinaimg.cn/mw690/b0653590gy1fv0zcuob7jj20k008cae7.jpg",
                                  @"https://wx2.sinaimg.cn/mw690/b0653590gy1fv0zcuvuzsj20k008cn1q.jpg",
                                  @"https://wx1.sinaimg.cn/mw690/b0653590gy1fv0zcv2qpmj20u00itwkt.jpg",
                                  @"https://wx2.sinaimg.cn/mw690/b0653590gy1fv0zcvgxw4j20jt078q5c.jpg"
                                  ];
    SDCycleScrollView *cycleScrollView = [[SDCycleScrollView alloc] init];
    [self.view addSubview:cycleScrollView];
    cycleScrollView.delegate = self;
    cycleScrollView.translatesAutoresizingMaskIntoConstraints = NO;
//
    NSLayoutConstraint *cycleScrollViewLeft = [NSLayoutConstraint constraintWithItem:cycleScrollView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.equalSafeView attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    [self.view addConstraint:cycleScrollViewLeft];

    NSLayoutConstraint *cycleScrollViewRight = [NSLayoutConstraint constraintWithItem:cycleScrollView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.equalSafeView attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    [self.view addConstraint:cycleScrollViewRight];

    NSLayoutConstraint *cycleScrollViewHeight = [NSLayoutConstraint constraintWithItem:cycleScrollView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.equalSafeView attribute:NSLayoutAttributeHeight multiplier:0.37 constant:0];
    [self.view addConstraint:cycleScrollViewHeight];

    NSLayoutConstraint *cycleScrollViewTop = [NSLayoutConstraint constraintWithItem:cycleScrollView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.equalSafeView attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    [self.view addConstraint:cycleScrollViewTop];
    
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    cycleScrollView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    cycleScrollView.imageURLStringsGroup = imagesURLStrings;
    cycleScrollView.autoScrollTimeInterval = 4;
    
    UIView *devView = [[UIView alloc] init];
    devView.backgroundColor = [UIColor lightGrayColor];
    devView.alpha = 0.7;
    [self.view addSubview:devView];
    devView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *devViewLeft = [NSLayoutConstraint constraintWithItem:devView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.equalSafeView attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    [self.view addConstraint:devViewLeft];
    
    NSLayoutConstraint *devViewRight = [NSLayoutConstraint constraintWithItem:devView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.equalSafeView attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    [self.view addConstraint:devViewRight];
    
    NSLayoutConstraint *devViewHeight = [NSLayoutConstraint constraintWithItem:devView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:0.5];
    [self.view addConstraint:devViewHeight];
    
    NSLayoutConstraint *devViewTop = [NSLayoutConstraint constraintWithItem:devView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:cycleScrollView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    [self.view addConstraint:devViewTop];
    
    //         --- 模拟加载延迟
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
//    });
//    [self.btnaiqiyi addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    _btnaiqiyi.tag = 1;
    [self btnAddTag:self.btnaiqiyi tag:(NSInteger)1];
    [self btnAddTag:self.btntengxun tag:(NSInteger)2];
    [self btnAddTag:self.btnsouhu tag:(NSInteger)3];
    [self btnAddTag:self.btnyouku tag:(NSInteger)4];
    [self btnAddTag:self.btnmangguo tag:(NSInteger)5];
    [self btnAddTag:self.btntudou  tag:(NSInteger)6];
    [self btnAddTag:self.btnM1905 tag:(NSInteger)7];
    [self btnAddTag:self.btnleshi tag:(NSInteger)8];
    [self btnAddTag:self.btnppshipin tag:(NSInteger)9];
    [self btnAddTag:self.btnlishipin tag:(NSInteger)10];
    [self btnAddTag:self.btndongman tag:(NSInteger)11];
    [self btnAddTag:self.btntv tag:(NSInteger)12];

}


-(void)btnAddTag:(UIButton *)btn tag:(NSInteger)tag{
    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = tag;
 
}

- (void)btnClicked:(UIButton *)btn {
    
    BmobUser *bUser = [BmobUser currentUser];
    if (bUser) {
        NSString *localTimeMil = [bUser objectForKey:@"currentTimeMillisVer"];
        NSString *localoutTime = [bUser objectForKey:@"outTime"];
        BmobQuery   *bquery = [BmobQuery queryWithClassName:@"_User"];
        [bquery getObjectInBackgroundWithId:[bUser objectId] block:^(BmobObject *object,NSError *error){
            if (error){
                [MBProgressHUD showError:@"unknown error"];
            }else{
                NSString *bmobTimeMil = [object objectForKey:@"currentTimeMillisVer"];
                
                Boolean isVer = [localTimeMil isEqualToString:bmobTimeMil] &&  [self compareOneDay:[self stringToDate:localoutTime withDateFormat:@"yyyy-MM-dd HH:mm:ss"]  withAnotherDay:[NSDate date]] ? true : false;
                if (isVer) {
                    
                    if (btn.tag == 1) {
                        _webUrl = @"http://m.iqiyi.com/";
                    }else if (btn.tag == 2){
                        _webUrl = @"http://m.v.qq.com";
                    }else if (btn.tag == 3){
                        _webUrl = @"https://m.tv.sohu.com/";
                    }else if (btn.tag == 4){
                        _webUrl = @"https://www.youku.com/";
                    }else if (btn.tag == 5){
                        _webUrl = @"https://m.mgtv.com/";
                    }else if (btn.tag == 6){
                        _webUrl = @"http://compaign.tudou.com/";
                    }else if (btn.tag == 7){
                        _webUrl = @"http://m.1905.com/";
                    }else if (btn.tag == 8){
                        _webUrl = @"http://m.le.com/";
                    }else if (btn.tag == 9){
                        _webUrl = @"http://m.pptv.com/?f=pptv";
                    }else if (btn.tag == 10){
                        _webUrl = @"http://www.pearvideo.com/?from=intro";
                    }else if (btn.tag == 11){
                        _webUrl = @"http://m.iqiyi.com/dongman/";
                    }else if (btn.tag == 12){
                        _webUrl = @"http://wx.iptv789.com/?act=home";
                    }
                    
                    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"UserReadOrACL"];
                    //查找GameScore表里面id为0c6db13c的数据
                    [bquery getObjectInBackgroundWithId:@"0c5cb1e7a1" block:^(BmobObject *object,NSError *error){
                        if (error){
                             [self performSegueWithIdentifier:@"openVideoUrl" sender:nil];
                        }else{
                            if (object) {
                                //得到playerName和cheatMode
                                NSString *userReadOrACL = [object objectForKey:@"userReadOrACL"];
                                _jiexiUrlList = [userReadOrACL componentsSeparatedByString:@"****\n"];
//                                NSLog(@"%@",_jiexiUrlList);
                                [self performSegueWithIdentifier:@"openVideoUrl" sender:nil];
                            }else{
                                 [self performSegueWithIdentifier:@"openVideoUrl" sender:nil];
                            }
                        }
                    }];

                }else {
                 [MBProgressHUD showError:@"账号已在别处登录或身份过期，请重新登录"];
                }
                
            }
        }];
        
        
    }else {
        [MBProgressHUD showError:@"账号未登录"];
    }
    
    
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    VideoUrlViewController *vc = segue.destinationViewController;
    vc.webviewUrl = _webUrl;
    vc.jiexiUrl = _jiexiUrlList;
}




- (void)clearFile
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString * cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"%@",cachePath);
    NSDirectoryEnumerator *fileEnumerator = [fileManager enumeratorAtPath:cachePath];
    for (NSString *fileName in fileEnumerator) {
        NSString *filePath = [cachePath stringByAppendingPathComponent:fileName];
        [fileManager removeItemAtPath:filePath error:nil];
    }
}

- (NSUInteger)getSize {
    NSUInteger size = 0;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString * cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSDirectoryEnumerator *fileEnumerator = [fileManager enumeratorAtPath:cachePath];
    for (NSString *fileName in fileEnumerator) {
        NSString *filePath = [cachePath stringByAppendingPathComponent:fileName];
        NSDictionary *attrs = [fileManager attributesOfItemAtPath:filePath error:nil];
        size += [attrs fileSize];
    }
    return size;
}



//字符串转日期格式
- (NSDate *)stringToDate:(NSString *)dateString withDateFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    
    NSDate *date = [dateFormatter dateFromString:dateString];
    return [self worldTimeToChinaTime:date];
}


//将世界时间转化为中国区时间
- (NSDate *)worldTimeToChinaTime:(NSDate *)date
{
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    NSInteger interval = [timeZone secondsFromGMTForDate:date];
    NSDate *localeDate = [date  dateByAddingTimeInterval:interval];
    return localeDate;
}


-(Boolean)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
//    NSLog(@"date1 : %@, date2 : %@", oneDay, anotherDay);
    if (result == NSOrderedDescending) {
        //NSLog(@"Date1  is in the future");
        return true;
    }
    else if (result == NSOrderedAscending){
        //NSLog(@"Date1 is in the past");
        return false;
    }
    //NSLog(@"Both dates are the same");
    return false;
    
 
}



@end
