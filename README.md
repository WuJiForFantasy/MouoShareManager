# MouoShareManager
第三方分享，登录，授权，一键分享快速集成

1.使用cocopods拉取shareSDK的第三方库
2.添加MouoShareManager，MouoShareUser类
3.添加白名单
4.添加url schemes

文档链接

（1）快速集成：
http://wiki.mob.com/使用cocoapods集成sharesdk/

（2）适配iOS9+（添加白名单）：
http://wiki.mob.com/ios9-对sharesdk的影响（适配ios-9必读）/

##tips:需要将微信，腾讯，新浪，分享的key换上去

需要cocopods引入

pod 'ShareSDK3'    #shareSDK分享

pod 'MOBFoundation'#Mob 公共库(必须

pod 'ShareSDK3/ShareSDKPlatforms/QQ'        #QQ分享

pod 'ShareSDK3/ShareSDKPlatforms/SinaWeibo' #新浪微博分享

pod 'ShareSDK3/ShareSDKPlatforms/WeChat'    #微信分享

pod 'ShareSDK3/ShareSDKExtension'           #分享扩展


