//
//  MouoShareUser.h
//  mouo
//
//  Created by tqh on 2017/1/11.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MouoEnum.h"

/**
 *  陌友第三方分享'登录类型
 */
typedef NS_ENUM(NSInteger, MouoShareThirdType) {
    /**
     *  微信（只用于检测客户端是否存在和登录）
     */
    MouoShareThirdTypeWeiXin = 1,
    /**
     *  QQ（只用于检测客户端是否存在和登录）
     */
    MouoShareThirdTypeQQ = 2,
    /**
     *  新浪微博
     */
    MouoShareThirdTypeWeiBo = 3,
    /**
     *  微信朋友圈
     */
    MouoShareThirdTypeWechatTimeline = 4,
    /**
     *  微信好友
     */
    MouoShareThirdTypeWechatSession = 5,
    /**
     *  QQ好友
     */
    MouoShareThirdTypeQQFriend = 6,
    /**
     *  QQ空间
     */
    MouoShareThirdTypeQZone = 7,
    /**
     *  复制链接
     */
    MouoShareThirdTypeUrl = 8,
    /**
     *  举报
     */
    MouoJubao = 9,
    /**
     *  二维码
     */
    MouoShareThirdTypeQrcode = 10,
    /**
     *  通讯录
     */
    MouoShareThirdAddressBook = 11,
};


@interface MouoShareUser : NSObject

/**
 *  平台类型
 */
@property (nonatomic) MouoShareThirdType platformType;

/**
 *  用户标识
 */
@property (nonatomic, copy) NSString *uid;

/**
 *  昵称
 */
@property (nonatomic, copy) NSString *nickname;

/**
 *  头像
 */
@property (nonatomic, copy) NSString *icon;

/**
 *  性别
 */
@property (nonatomic) MouoSexType gender;


@end
