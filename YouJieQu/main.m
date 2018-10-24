//
//  main.m
//  YouJieQu
//
//  Created by user on 2018/10/15.
//  Copyright © 2018年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <BmobSDK/Bmob.h>


int main(int argc, char * argv[]) {
    @autoreleasepool {
        NSString *appKey = @"2a654d2984b42dffb0a329dcc7189b4d";
        [Bmob registerWithAppKey:appKey];
        
     
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
