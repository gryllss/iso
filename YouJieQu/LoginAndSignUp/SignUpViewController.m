//
//  SignUpViewController.m
//  YouJieQu
//
//  Created by user on 2018/10/21.
//  Copyright © 2018年 user. All rights reserved.
//

#import "SignUpViewController.h"
#import "XMGLoginAnimView.h"
#import <BmobSDK/BmobUser.h>
#import "MBProgressHUD+XMG.h"

@interface SignUpViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIView *animContentView;
@property (strong, nonatomic) IBOutlet UITextField *accountFiled;
@property (strong, nonatomic) IBOutlet UITextField *pswFiled;
@property (strong, nonatomic) IBOutlet UITextField *pswAgainFiled;
@property (strong,nonatomic) XMGLoginAnimView *animView;
@property (strong, nonatomic) IBOutlet UIButton *btnSignUp;

@end

@implementation SignUpViewController

- (void)viewDidLoad {

 
    self.navigationController.view.backgroundColor = [UIColor whiteColor];//不设置会导致push时右上角黑影闪烁

    [[self btnSignUp]addTarget:nil action:@selector(clickSignUp) forControlEvents:UIControlEventTouchUpInside];
    
    XMGLoginAnimView *animView = [XMGLoginAnimView loginAnimView];
    _animView = animView;
    [_animContentView addSubview:_animView];
    [self.view bringSubviewToFront:_animContentView];
    _accountFiled.delegate = self;
    _pswFiled.delegate = self;
    _pswAgainFiled.delegate = self;
    
    UIImage *im = [UIImage imageNamed:@"login_phonenumber"];
    UIImageView *iv = [[UIImageView alloc] initWithImage:im];
    UIView *lv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];//宽度根据需求进行设置，高度必须大于 textField 的高度
    //    lv.backgroundColor = [UIColor blueColor];
    iv.center = lv.center;
    [lv addSubview:iv];
    _accountFiled.leftViewMode = UITextFieldViewModeAlways;
    _accountFiled.leftView = lv;
    
    UIImage *im1 = [UIImage imageNamed:@"login_password"];
    UIImageView *iv1 = [[UIImageView alloc] initWithImage:im1];
    UIView *lv1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];//宽度根据需求进行设置，高度必须大于 textField 的高度
    //    lv.backgroundColor = [UIColor blueColor];
    iv1.center = lv1.center;
    [lv1 addSubview:iv1];
    _pswFiled.leftViewMode = UITextFieldViewModeAlways;
    _pswFiled.leftView = lv1;
//    _pswAgainFiled.leftViewMode = UITextFieldViewModeAlways;
//    _pswAgainFiled.leftView = lv1;
    UIImage *im2 = [UIImage imageNamed:@"login_password"];
    UIImageView *iv2 = [[UIImageView alloc] initWithImage:im2];
    UIView *lv2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];//宽度根据需求进行设置，高度必须大于 textField 的高度
    //    lv.backgroundColor = [UIColor blueColor];
    iv2.center = lv2.center;
    [lv2 addSubview:iv2];
        _pswAgainFiled.leftViewMode = UITextFieldViewModeAlways;
        _pswAgainFiled.leftView = lv2;
    
}


-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField.tag) {
        [_animView startAnim:YES];
    }else{
        [_animView startAnim:NO];
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [_animView startAnim:NO];
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [_animView startAnim:NO];
}



-(void)clickSignUp {
    
    if([_accountFiled.text isEqualToString:@""] || [_pswFiled.text isEqualToString:@""]){
        [MBProgressHUD showError:@"手机号或密码不能为空"];
    }else{
        if (![self checkPhoneNumInput:_accountFiled.text]) {
            [MBProgressHUD showError:@"请输入正确的手机号"];
        }else {
            if (_pswFiled.text.length < 6) {
                [MBProgressHUD showError:@"请输入至少6位密码"];
            }else if (![_pswFiled.text isEqualToString:_pswAgainFiled.text]){
                 [MBProgressHUD showError:@"两次密码不一致"];
            }else {
//                NSDate *date = [NSDate date];
                NSTimeInterval interval = 60 * 60 * 48;
                NSDate *date2 = [NSDate dateWithTimeIntervalSinceNow:interval];
                    BmobUser *bUser = [[BmobUser alloc] init];
                    [bUser setUsername:_accountFiled.text];
                    [bUser setPassword:_pswFiled.text];
                    [bUser setObject:[self dateToString:date2 withDateFormat:@"yyyy-MM-dd HH:mm:ss"] forKey:@"outTime"];
                    [bUser signUpInBackgroundWithBlock:^ (BOOL isSuccessful, NSError *error){
                        if (isSuccessful){
                            [MBProgressHUD showSuccess:@"注册成功"];
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [self.navigationController popViewControllerAnimated:YES];
                            });
                        } else {
                            [MBProgressHUD showError:@"手机号已被注册，请直接登陆"];
                        }
                    }];
            }
            
        }
    
        
        
        
    }
    
    
    

}



//检查是否为手机号的方法
-(BOOL)checkPhoneNumInput:(NSString *)phoneStr
{
    NSString *photoRange = @"^1(3[0-9]|4[0-9]|5[0-9]|7[0-9]|8[0-9]|9[0-9])\\d{8}$";//正则表达式
    NSPredicate *regexMobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",photoRange];
    BOOL result = [regexMobile evaluateWithObject:phoneStr];
    if (result) {
        return YES;
    } else {
        return NO;
    }
    
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField.tag) {
        if (range.location >= 16){ //限制位数.
            
            return NO;
        }else{
            return YES;
        }
    }else{
        if (range.location >= 11){ //限制位数.
            
            return NO;
        }else{
            return YES;
        }
    
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
