//
//  XMGLoginAnimView.m
//  03-小码哥通讯录
//
//  Created by xiaomage on 15/9/9.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "XMGLoginAnimView.h"

@interface XMGLoginAnimView ()

@property (strong, nonatomic) IBOutlet UIImageView *rightArm;
@property (strong, nonatomic) IBOutlet UIImageView *leftArm;
@property (strong, nonatomic) IBOutlet UIImageView *leftHand;

@property (strong, nonatomic) IBOutlet UIImageView *rightHand;



//@property (weak, nonatomic) IBOutlet UIImageView *leftArm;
//@property (weak, nonatomic) IBOutlet UIImageView *rightArm;
//@property (weak, nonatomic) IBOutlet UIImageView *leftHand;
//@property (weak, nonatomic) IBOutlet UIImageView *rightHand;
//
@property (nonatomic, assign) CGFloat armOffsetY;
@property (nonatomic, assign) CGFloat leftArmOffsetX;
@property (nonatomic, assign) CGFloat rigthArmOffsetX;
//@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIView *contentView;

@end

@implementation XMGLoginAnimView

- (void)awakeFromNib
{

    [super awakeFromNib];
    // 初始化手臂位置
    // y轴偏移量
    _armOffsetY = self.bounds.size.height - _leftArm.frame.origin.y;
    // 左边手臂x轴偏移量
    _leftArmOffsetX = -_leftArm.frame.origin.x;

    // 右边手臂x轴偏移量
    _rigthArmOffsetX = _contentView.bounds.size.width - _rightHand.bounds.size.width - _rightArm.frame.origin.x;


    // 平移左边手臂
    _leftArm.transform = CGAffineTransformMakeTranslation(_leftArmOffsetX, _armOffsetY);

    // 平移右边手臂
    _rightArm.transform = CGAffineTransformMakeTranslation(_rigthArmOffsetX, _armOffsetY);


}

+ (instancetype)loginAnimView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"XMGLoginAnimView" owner:nil options:nil]firstObject];
}

- (void)startAnim:(BOOL)isClose
{
    if (isClose) { // 遮住眼睛
        // 清空形变
        
        
       
        [UIView animateWithDuration:0.3 animations:^{
            // 手臂
            _leftArm.transform = CGAffineTransformIdentity;
            _rightArm.transform = CGAffineTransformIdentity;

            // 手
            _leftHand.transform = CGAffineTransformMakeTranslation(-_leftArmOffsetX, -_armOffsetY + 5);
            _leftHand.transform = CGAffineTransformScale(_leftHand.transform, 0.01, 0.01);

//            NSLog(@"%f", _rigthArmOffsetX);

            _rightHand.transform = CGAffineTransformMakeTranslation(-_rigthArmOffsetX, -_armOffsetY + 5);
            _rightHand.transform = CGAffineTransformScale(_rightHand.transform, 0.01, 0.01);


        }];

    }else{

        [UIView animateWithDuration:0.3 animations:^{

            // 平移左边手臂
            _leftArm.transform = CGAffineTransformMakeTranslation(_leftArmOffsetX, _armOffsetY);

            // 平移右边手臂
            _rightArm.transform = CGAffineTransformMakeTranslation(_rigthArmOffsetX, _armOffsetY);

            // 手
            _leftHand.transform = CGAffineTransformIdentity;
            _rightHand.transform = CGAffineTransformIdentity;

        }];



    }
}
@end
