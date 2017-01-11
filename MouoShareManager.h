//
//  MouoShareManager.h
//  mouo
//
//  Created by tqh on 2016/12/29.
//  Copyright © 2016年 tqh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MouoShareUser.h"

//h5分享类型
typedef NS_ENUM(NSInteger, MouoShareManagerH5Type) {
    MouoShareManagerH5TypeCircleInfo,      //圈子信息
};

typedef void(^ShareSuccessBlock) (NSString *uid); //分享成功回调
typedef void(^AuthorizeSuccessBlock) (MouoShareUser *user); //授权成功回调
typedef void(^ShareErrorBlock) (NSString *string);   //分享错误回调
typedef void(^ShareFinishBlock) (NSString *string,NSError *error);   //分享完成回调

/**分享管理*/

@interface MouoShareManager : NSObject

#pragma mark - 分享 -

/**注册分享key*/
+ (void)registerApp;

/**一键分享微信，QQ空间，新浪微博，授权了才能分享哦*/
+ (void)oneKeyShare:(NSArray *)platforms url:(NSString *)url title:(NSString *)title text:(NSString *)text imageArray:(NSArray *)imageArray dynamicTopicId:(NSString *)dynamicTopicId;

/**邀请陌友好友*/
+ (void)shareInviteFriend:(MouoShareThirdType)type;

#pragma mark - 授权 -

/**判断是否授权*/
+ (BOOL)hasAuthorized:(MouoShareThirdType)platformTypem;

/**取消授权*/
+ (void)cancelAuthorize:(MouoShareThirdType)platformType;

/**取消所有授权*/
+ (void)cancelAllAuthorize;

/**授权*/
+ (void)authorize:(MouoShareThirdType)platformType success:(ShareSuccessBlock)sucess error:(ShareErrorBlock)shareError;

#pragma mark - 登录 -

/**调用第三方登录*/
+ (void)loginByPlatform:(MouoShareThirdType)platformType success:(AuthorizeSuccessBlock)sucess error:(ShareErrorBlock)shareError;

/**判断是否存在客户端*/
+ (BOOL)whetherTheClient:(MouoShareThirdType)type;

@end
