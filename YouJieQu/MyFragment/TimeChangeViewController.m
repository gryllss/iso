//
//  TimeChangeViewController.m
//  YouJieQu
//
//  Created by user on 2018/10/21.
//  Copyright © 2018年 user. All rights reserved.
//

#import "TimeChangeViewController.h"
#import <BmobSDK/BmobUser.h>
#import "MBProgressHUD+XMG.h"
#import <BmobSDK/BmobQuery.h>
#import <BmobSDK/BmobObject.h>

@interface TimeChangeViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UILabel *label;
- (IBAction)jihuoClick:(id)sender;


@property(strong,nonatomic)NSString *localTimeMil;
@property(strong,nonatomic)NSString *bmobTimeMil;
@property(strong,nonatomic)NSString *objectId;
@property(strong,nonatomic)NSString *code;
@property(assign,nonatomic)BOOL isUsedCode;
@property(strong,nonatomic)NSString *userName;

@end

@implementation TimeChangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationController.view.backgroundColor = [UIColor whiteColor];//不设置会导致push时右上角黑影闪烁
   
    UIImage *im = [UIImage imageNamed:@"duihuanma"];
    UIImageView *iv = [[UIImageView alloc] initWithImage:im];
    UIView *lv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];//宽度根据需求进行设置，高度必须大于 textField 的高度
//    lv.backgroundColor = [UIColor blueColor];
    iv.center = lv.center;
    [lv addSubview:iv];
    _textField.leftViewMode = UITextFieldViewModeAlways;
    _textField.leftView = lv;
    _textField.delegate = self;
    
    if (_isLogin) {
        BmobUser *bUser = [BmobUser currentUser];
        if (bUser) {
            _userName = [bUser objectForKey:@"username"];
            if (_userName.length >= 8) {
                NSString *subName = [_userName stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
               _label.text = subName;
            }else{
             _label.text = _userName;
            }
            
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
         [_textField resignFirstResponder];
         return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(void)setIsLogin:(BOOL)isLogin{
    _isLogin = isLogin;
}


- (IBAction)jihuoClick:(id)sender {
    
    if (![_textField.text isEqualToString:@""]) {
        if (_isLogin) {
            [MBProgressHUD showMessage:@"请稍候"];
            BmobUser *bUser = [BmobUser currentUser];
            _localTimeMil = [bUser objectForKey:@"currentTimeMillisVer"];
            BmobQuery   *bquery = [BmobQuery queryWithClassName:@"_User"];
            [bquery getObjectInBackgroundWithId:[bUser objectId] block:^(BmobObject *object,NSError *error){
                if (error){
                    //进行错误处理
                }else{
                    if (object) {
                        _bmobTimeMil = [object objectForKey:@"currentTimeMillisVer"];
                        if ([_bmobTimeMil isEqualToString:_localTimeMil]) {
                            _isUsedCode = false;
                            _code = _textField.text;
                            BmobQuery   *bqueryCode = [BmobQuery queryWithClassName:@"ActivationCode"];
                            [bqueryCode whereKey:@"activationCode" equalTo:_code];
                            [bqueryCode findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                                
                                NSString *strId = @"";
                                for (BmobObject *obj in array) {
                                    strId = [obj objectId];
                                    _isUsedCode = [[obj objectForKey:@"isUsed"] boolValue];
                                    
                                }
                                _objectId = strId;
                                
                                if (![_objectId isEqualToString:@""] && !_isUsedCode) {
                                    BmobObject  *activationCodeChange = [BmobObject objectWithoutDataWithClassName:@"ActivationCode" objectId:_objectId];
                                    [activationCodeChange setObject:[NSNumber numberWithBool:true]  forKey:@"isUsed"];
                                    [activationCodeChange setObject:_userName forKey:@"usederPhone"];
                                    NSDate *date = [NSDate date];
                                    [activationCodeChange setObject:[self dateToString:date withDateFormat:@"yyyy-MM-dd HH:mm:ss"] forKey:@"jiHuoTime"];
                                    [activationCodeChange updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                                        if (isSuccessful) {
                                            BmobUser *bUser = [BmobUser currentUser];
                                            NSTimeInterval interval = 60 * 60 * 24 * 366;
                                            NSString *strDate = [bUser objectForKey:@"outTime"];
                                            NSDate *newdate = [self stringToDate:strDate withDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                                            NSDate *date2 = [NSDate dateWithTimeInterval:interval sinceDate:newdate];
                                            [bUser setObject:[self dateToString:date2 withDateFormat:@"yyyy-MM-dd HH:mm:ss"] forKey:@"outTime"];
                                            [bUser updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                                                if (isSuccessful) {
                                                    [MBProgressHUD hideHUD];
                                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                        [MBProgressHUD showSuccess:@"激活成功"];
                                                    });
                                                    
                                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                        [self.navigationController popViewControllerAnimated:YES];
                                                    });
                                                    
                                                }else{
                                                    [MBProgressHUD hideHUD];
                                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                        [MBProgressHUD showError:@"unknown error"];
                                                    });
                                                    
                                                }
                                            }];
                                            
                                        } else {
                                            [MBProgressHUD hideHUD];
                                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                [MBProgressHUD showError:@"unknown error1"];
                                            });
                                            
                                        }
                                    }];
                                    
                                }else {
                                    if (_isUsedCode) {
                                        [MBProgressHUD hideHUD];
                                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                            [MBProgressHUD showError:@"激活码已被使用"];
                                        });
                                        
                                    }else{
                                        [MBProgressHUD hideHUD];
                                        
                                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                            [MBProgressHUD showError:@"激活码不存在，请输入正确的激活码"];
                                        });
                                    }
                                }
                                
                            }];
                            
                        }else {
                            [MBProgressHUD hideHUD];
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [MBProgressHUD showError:@"账户身份已过期，请重新登录后激活"];
                            });
                            
                        }
                        
                        
                    }
                }
            }];
            
        }else {
            
            [MBProgressHUD showError:@"账号未登录"];
        }
    }else{
        [MBProgressHUD showError:@"激活码不能为空"];
    }
   
    
    
}


//日期格式转字符串
- (NSString *)dateToString:(NSDate *)date withDateFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
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




@end
