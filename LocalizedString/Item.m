//
//  Item.m
//  LocalizedString
//
//  Created by qiandong on 6/18/15.
//  Copyright (c) 2015 qiandong. All rights reserved.
//

#import "Item.h"

@implementation Item

-(id)initWithKey:(NSString *)key Value:(NSString *)value
{
    self = [super init];
    if (self) {
        self.key = key;
        self.value = value;
    }
    return self;
}

@end
