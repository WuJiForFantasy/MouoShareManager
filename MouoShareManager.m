//
//  MouoShareManager.m
//  mouo
//
//  Created by tqh on 2016/12/29.
//  Copyright © 2016年 tqh. All rights reserved.
//

#import "MouoShareManager.h"

#import <ShareSDK/ShareSDK.h>                       //shareSDK分享
#import <ShareSDKConnector/ShareSDKConnector.h>     //分享
#import <ShareSDKExtension/ShareSDK+Extension.h>    //分享的扩展
#import <ShareSDKExtension/SSEShareHelper.h>        //分享的帮助扩展
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>  //登录的扩展
#import <TencentOpenAPI/TencentOAuth.h>     //腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/QQApiInterface.h>   //腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import "WXApi.h"                           //微信SDK头文件
#import "WeiboSDK.h"                        //新浪微博SDK头文件


//微信
#define Moyou_WechatAppId @""
#define Moyou_WechatAppSecret @""

//腾讯QQ

#define Moyou_TencentAppId @""
#define Moyou_TencentAppKey @""

//新浪
#define Moyou_SinaAppKey @""
#define Moyou_SinaAppSecret @""
#define Moyou_SinaRedirectURI @""

//第三方分享的账号
#define Moyou_ShareSDKAppKey @""
#define Moyou_ShareAppSecret @""

@implementation MouoShareManager

+ (void)registerApp {
    [ShareSDK registerApp:Moyou_ShareSDKAppKey
     
          activePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ)]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:Moyou_SinaAppKey
                                           appSecret:Moyou_SinaAppSecret
                                         redirectUri:Moyou_SinaRedirectURI
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:Moyou_WechatAppId
                                       appSecret:Moyou_WechatAppSecret];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:Moyou_TencentAppId
                                      appKey:Moyou_TencentAppKey
                                    authType:SSDKAuthTypeBoth];
                 break;
             default:
                 break;
         }
     }];
}

#pragma mark - public

+ (void)oneKeyShare:(NSArray *)platforms url:(NSString *)url title:(NSString *)title text:(NSString *)text imageArray:(NSArray *)imageArray dynamicTopicId:(NSString *)dynamicTopicId {

    url = @"www.baidu.com";
    title = @"陌友";
    text = @"我在陌友发现了一个不错故事，分享给大家。";
    imageArray = @[[UIImage imageNamed:@"120"]];
    
    if ([platforms containsObject:@(SSDKPlatformTypeSinaWeibo)]) {
        [self shareWithType:SSDKPlatformTypeSinaWeibo url:url title:title text:text imageArray:imageArray finish:^(NSString *string, NSError *error) {
            
            if ([platforms containsObject:@(SSDKPlatformSubTypeQZone)]) {
                [self shareWithType:SSDKPlatformSubTypeQZone url:url title:title text:text imageArray:imageArray finish:^(NSString *string, NSError *error) {
                    
                    if ([platforms containsObject:@(SSDKPlatformSubTypeWechatTimeline)]) {
                        [self shareWithType:SSDKPlatformSubTypeWechatTimeline url:url title:title text:text imageArray:imageArray finish:^(NSString *string, NSError *error) {
                            
                        }];
                    }
                }];
            }
        }];
        return;
    }
    if ([platforms containsObject:@(SSDKPlatformSubTypeQZone)]) {
        [self shareWithType:SSDKPlatformSubTypeQZone url:url title:title text:text imageArray:imageArray finish:^(NSString *string, NSError *error) {
            
            if ([platforms containsObject:@(SSDKPlatformSubTypeWechatTimeline)]) {
                [self shareWithType:SSDKPlatformSubTypeWechatTimeline url:url title:title text:text imageArray:imageArray finish:^(NSString *string, NSError *error) {
                    
                }];
            }
        }];
        return;
    }
    
    if ([platforms containsObject:@(SSDKPlatformSubTypeWechatTimeline)]) {
        [self shareWithType:SSDKPlatformSubTypeWechatTimeline url:url title:title text:text imageArray:imageArray finish:^(NSString *string, NSError *error) {
            
        }];
        return;
    }
}

//邀请好友
+ (void)shareInviteFriend:(MouoShareThirdType)type {
    
    [self shareWithType:[self changeTypeWithMoyouType:type] url:@"www.baidu.com" title:@"邀请好友分享~~~" text:@"邀请好友的分享内容。。。" imageArray:@[[UIImage imageNamed:@"娃娃"]] finish:^(NSString *string, NSError *error) {
        NSLog(@"%@",string);
    }];
}

#pragma mark -- （授权）

+ (BOOL)hasAuthorized:(MouoShareThirdType)platformTypem {
    return [ShareSDK hasAuthorized:[self changeTypeWithMoyouType:platformTypem]];
}

+ (void)cancelAuthorize:(MouoShareThirdType)platformType {
    return [ShareSDK cancelAuthorize:[self changeTypeWithMoyouType:platformType]];
}

+ (void)cancelAllAuthorize {
    if ([self hasAuthorized:MouoShareThirdTypeWeiXin]) {
        [self cancelAuthorize:MouoShareThirdTypeWeiXin];
    }
    if ([self hasAuthorized:MouoShareThirdTypeQQ]) {
        [self cancelAuthorize:MouoShareThirdTypeQQ];
    }
    if ([self hasAuthorized:MouoShareThirdTypeWeiBo]) {
        [self cancelAuthorize:MouoShareThirdTypeWeiBo];
    }
}

+ (void)authorize:(MouoShareThirdType)platformType success:(ShareSuccessBlock)sucess error:(ShareErrorBlock)shareError {
    if ([self hasAuthorized:platformType]) {
        //        sucess(@"授权成功");
        //授权成功的
    }else {
        [ShareSDK authorize:[self changeTypeWithMoyouType:platformType] settings:nil onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
            
            if (state == SSDKResponseStateSuccess) {
                sucess(user.uid);
            }else if (state == SSDKResponseStateFail) {
                shareError(error.localizedDescription);
            }else if (state == SSDKResponseStateCancel) {
                shareError(@"取消授权");
            }
        }];
        
    }
}

#pragma mark -- （登录）

+ (void)loginByPlatform:(MouoShareThirdType)platformType success:(AuthorizeSuccessBlock)sucess error:(ShareErrorBlock)shareError {
    
    if ([self hasAuthorized:platformType]) {
        
        //授权成功的,获取授权用户信息
        [ShareSDK getUserInfo:[self changeTypeWithMoyouType:platformType] onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
            
            if (state == SSDKResponseStateSuccess) {
                NSLog(@"%@:授权成功，获得授权信息",[self class]);
                sucess([self changeUserWithShareUser:user]);
                
            }else if (state == SSDKResponseStateFail) {
                
                shareError(error.localizedDescription);
                
            }else if (state == SSDKResponseStateCancel) {
                shareError(@"取消授权");
            }
            
        }];
    }else {
        //SSDKPlatformTypeWechat
        [ShareSDK authorize:[self changeTypeWithMoyouType:platformType] settings:nil onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
            
            if (state == SSDKResponseStateSuccess) {
                NSLog(@"%@:授权成功，获得授权信息",[self class]);
                
                sucess([self changeUserWithShareUser:user]);
                
            }else if (state == SSDKResponseStateFail) {
                
                shareError(error.localizedDescription);
                
            }else if (state == SSDKResponseStateCancel) {
                shareError(@"取消授权");
            }
        }];
    }
}

#pragma mark - private

+ (void)shareWithType:(SSDKPlatformType)type url:(NSString *)url title:(NSString *)title text:(NSString *)text imageArray:(NSArray *)imageArray finish:(ShareFinishBlock)finish {
    
    if (imageArray) {
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        
        //        if ([ShareSDK isClientInstalled:SSDKPlatformTypeSinaWeibo]) {
        //            [shareParams SSDKEnableUseClientShare];
        //        }else {
        //            NSLog(@"没有安装微博客户端使用隐藏分享");
        //        }
        [shareParams SSDKSetupShareParamsByText:text
                                         images:imageArray
                                            url:[NSURL URLWithString:url]
                                          title:title
                                           type:SSDKContentTypeAuto];
        
        
        [ShareSDK share:type parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
            switch (state) {
                case SSDKResponseStateSuccess:
                {
                    NSLog(@"share - 分享成功");
                    finish(@"分享成功",error);
                    break;
                }
                case SSDKResponseStateFail:
                {
                    //提示框提示分享失败！失败原因一般都是客户端原因
                    NSLog(@"share - 分享失败");
                    finish(@"分享失败",error);
                    break;
                }
                case SSDKResponseStateCancel:
                {
                    NSLog(@"share - 分享取消");
                    break;
                }
                default:
                    break;
            }
        }];
    }
}



#pragma mark - tool

//将shareSDK用户类型转换为自己用户类型
+ (MouoShareUser *)changeUserWithShareUser:(SSDKUser *)user {
    
    MouoShareUser *newUser = [[MouoShareUser alloc]init];
    newUser.uid = user.uid;
    newUser.nickname = user.nickname;
    newUser.icon = user.icon;
    newUser.gender = user.gender + 1;
    newUser.platformType = [self changeTypeWithShareSDKType:user.platformType];
    return newUser;
}

//将自己类型转换为shareSDK类型
+ (SSDKPlatformType)changeTypeWithMoyouType:(MouoShareThirdType)type {
    NSInteger typeIndex = 0;
    switch (type) {
        case MouoShareThirdTypeWechatTimeline:
            typeIndex = SSDKPlatformSubTypeWechatTimeline;
            break;
        case MouoShareThirdTypeWechatSession:
            typeIndex = SSDKPlatformSubTypeWechatSession;
            break;
        case MouoShareThirdTypeQQFriend:
            typeIndex = SSDKPlatformSubTypeQQFriend;
            break;
        case MouoShareThirdTypeQZone:
            typeIndex = SSDKPlatformSubTypeQZone;
            break;
        case MouoShareThirdTypeWeiBo:
            typeIndex = SSDKPlatformTypeSinaWeibo;
            break;
        case MouoShareThirdTypeWeiXin:
            typeIndex = SSDKPlatformTypeWechat;
            break;
        case MouoShareThirdTypeQQ:
            typeIndex = SSDKPlatformTypeQQ;
            break;
        default:
            break;
    }
    return typeIndex;
}

//将shareSDK类型转换为自己类型
+ (MouoShareThirdType)changeTypeWithShareSDKType:(SSDKPlatformType)type {
    NSInteger typeIndex = 0;
    switch (type) {
        case SSDKPlatformSubTypeWechatTimeline:
            typeIndex = MouoShareThirdTypeWechatTimeline;
            break;
        case SSDKPlatformSubTypeWechatSession:
            typeIndex = MouoShareThirdTypeWechatSession;
            break;
        case SSDKPlatformSubTypeQQFriend:
            typeIndex = MouoShareThirdTypeQQFriend;
            break;
        case SSDKPlatformSubTypeQZone:
            typeIndex = MouoShareThirdTypeQZone;
            break;
        case SSDKPlatformTypeSinaWeibo:
            typeIndex = MouoShareThirdTypeWeiBo;
            break;
        case SSDKPlatformTypeWechat:
            typeIndex = MouoShareThirdTypeWeiXin;
            break;
        case SSDKPlatformTypeQQ:
            typeIndex = MouoShareThirdTypeQQ;
            break;
        default:
            break;
    }
    return typeIndex;
}

#warning -这里自定义的后面要改哦～～～～
+ (BOOL)whetherTheClient:(MouoShareThirdType)type{

    if (type == 4) {
        type = 1;
    }else if (type == 7){
        type = 2;
    }
    BOOL res = YES;
    if (![ShareSDK isClientInstalled:[MouoShareManager changeTypeWithMoyouType:type]]) {
        res = NO;
    }
    return res;
}

@end
