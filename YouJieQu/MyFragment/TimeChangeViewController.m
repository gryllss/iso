//
//  TimeChangeViewController.m
//  YouJieQu
//
//  Created by user on 2018/10/21.
//  Copyright © 2018年 user. All rights reserved.
//

#import "TimeChangeViewController.h"
#import <BmobSDK/BmobUser.h>

@interface TimeChangeViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UILabel *label;


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
            NSString *userName = [bUser objectForKey:@"username"];
            if (userName.length >= 8) {
                NSString *subName = [userName stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
               _label.text = subName;
            }else{
             _label.text = userName;
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


@end
