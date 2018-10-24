//
//  My.h
//  YouJieQu
//
//  Created by user on 2018/10/20.
//  Copyright © 2018年 user. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface My : NSObject

@property (strong, nonatomic) NSString *icon;
@property (strong, nonatomic) NSString *name;


- (instancetype)initWithDict:(NSDictionary *)dict;


@end

NS_ASSUME_NONNULL_END
