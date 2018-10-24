//
//  PlayVideoViewController.h
//  YouJieQu
//
//  Created by user on 2018/10/18.
//  Copyright © 2018年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PlayVideoViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *videoTitle;
@property (strong, nonatomic) NSString *videoUrl;
@property (strong, nonatomic) NSString *webTitle;
@end

NS_ASSUME_NONNULL_END
