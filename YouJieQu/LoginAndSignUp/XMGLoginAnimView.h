//
//  XMGLoginAnimView.h
//  03-小码哥通讯录
//
//  Created by xiaomage on 15/9/9.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XMGLoginAnimView : UIView

+ (instancetype)loginAnimView;


// 开始动画
- (void)startAnim:(BOOL)isClose;

@end
