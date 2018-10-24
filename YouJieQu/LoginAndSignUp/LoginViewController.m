//
//  LoginViewController.m
//  YouJieQu
//
//  Created by user on 2018/10/21.
//  Copyright © 2018年 user. All rights reserved.
//

#import "LoginViewController.h"
#import "XMGLoginAnimView.h"
#import <BmobSDK/BmobUser.h>
#import <BmobSDK/BmobQuery.h>
#import "MBProgressHUD+XMG.h"

@interface LoginViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIButton *btnLogin;

@property (strong, nonatomic) IBOutlet UIView *animContentView;
@property (strong,nonatomic) XMGLoginAnimView *animView;
@property (strong, nonatomic) IBOutlet UIButton *btnSignUp;
@property (strong, nonatomic) IBOutlet UITextField *textName;
@property (strong, nonatomic) IBOutlet UITextField *textPassword;

@property (nonatomic, assign) BOOL isLogin;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        self.navigationController.view.backgroundColor = [UIColor whiteColor];//不设置会导致push时右上角黑影闪烁

     self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"登录" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    [[self btnLogin]addTarget:nil action:@selector(clickLogin) forControlEvents:UIControlEventTouchUpInside];
    [[self btnSignUp]addTarget:nil action:@selector(clickSignUp) forControlEvents:UIControlEventTouchUpInside];
    
    XMGLoginAnimView *animView = [XMGLoginAnimView loginAnimView];
    _animView = animView;
    [_animContentView addSubview:_animView];
   [self.view bringSubviewToFront:_animContentView];
    _textName.delegate = self;
    _textPassword.delegate = self;
    
    UIImage *im = [UIImage imageNamed:@"login_phonenumber"];
    UIImageView *iv = [[UIImageView alloc] initWithImage:im];
    UIView *lv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];//宽度根据需求进行设置，高度必须大于 textField 的高度
    //    lv.backgroundColor = [UIColor blueColor];
    iv.center = lv.center;
    [lv addSubview:iv];
    _textName.leftViewMode = UITextFieldViewModeAlways;
    _textName.leftView = lv;
    
    UIImage *im1 = [UIImage imageNamed:@"login_password"];
    UIImageView *iv1 = [[UIImageView alloc] initWithImage:im1];
    UIView *lv1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];//宽度根据需求进行设置，高度必须大于 textField 的高度
    //    lv.backgroundColor = [UIColor blueColor];
    iv1.center = lv1.center;
    [lv1 addSubview:iv1];
    _textPassword.leftViewMode = UITextFieldViewModeAlways;
    _textPassword.leftView = lv1;

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


-(void)clickLogin {
    if ([_textName.text isEqualToString:@""] || [_textPassword.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"手机号或密码不能为空"];
    }else {
        
        [BmobUser loginInbackgroundWithAccount:_textName.text  andPassword:_textPassword.text block:^(BmobUser *user, NSError *error) {
            if (user) {
                [MBProgressHUD showSuccess:@"登录成功，请稍侯"];
                _isLogin = true;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            } else {
                [MBProgressHUD showError:@"手机号或密码错误"];
            }
        }];
        
    }

}
-(void)clickSignUp {
    
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"UserReadOrACL"];
    //查找GameScore表里面id为0c6db13c的数据
    [bquery getObjectInBackgroundWithId:@"1016b2b7e4" block:^(BmobObject *object,NSError *error){
        if (error){
            //进行错误处理
            [MBProgressHUD showMessage:@"服务器未知错误"];
        }else{
            //表里有id为0c6db13c的数据
            if (object) {
                //得到playerName和cheatMode
                NSString *userReadOrACL = [object objectForKey:@"userReadOrACL"];
                if ([userReadOrACL isEqualToString:@"Read"]) {
                    [MBProgressHUD showError:@"抱歉，暂已关闭注册通道"];
                }else {
                    [self performSegueWithIdentifier:@"signup" sender:nil];
                }
                
            }
        }
    }];
    
    
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    
        if (range.location >= 16){ //限制位数.
            
            return NO;
        }else{
            return YES;
        }
    }



-(void)dealloc {
    if (_isLogin) {
        BmobUser *bUser = [BmobUser currentUser];
        long time = [[NSDate date] timeIntervalSince1970] * 1000;
        NSNumber *longNumber = [NSNumber numberWithLong:time];
        NSString *strTime = [longNumber stringValue];
        [bUser setObject:strTime forKey:@"currentTimeMillisVer"];
        [bUser updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        }];
    }
    
}



@end
