//
//  Question.m
//  YouJieQu
//
//  Created by user on 2018/10/21.
//  Copyright © 2018年 user. All rights reserved.
//

#import "Question.h"

@implementation Question

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}


@end
