//
//  Item.h
//  LocalizedString
//
//  Created by qiandong on 6/18/15.
//  Copyright (c) 2015 qiandong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Item : NSObject

@property (nonatomic,strong) NSString *key;
@property (nonatomic,strong) NSString *value;

-(id)initWithKey:(NSString *)key Value:(NSString *)value;

@end
