//
//  MouoShareUser.m
//  mouo
//
//  Created by tqh on 2017/1/11.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import "MouoShareUser.h"

@implementation MouoShareUser

- (NSString *)description {
    return [NSString stringWithFormat:@"\n%@:\nuid = %@,\nnickname = %@,\nicon = %@,\ngender = %ld\n",[self class],self.uid,self.nickname,self.icon,self.gender];
}

@end
