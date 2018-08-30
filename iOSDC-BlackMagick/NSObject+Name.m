//
//  NSObject+Name.m
//  iOSDC-BlackMagick
//
//  Created by Yudai.Hirose on 2018/08/29.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

#import "NSObject+Name.h"
#import <objc/runtime.h>



static void *kAssociatedObjectKeyForUserInfo = "kAssociatedObjectKeyForUserInfo";
@implementation NSObject (Name)

- (id)userInfo {
    return objc_getAssociatedObject(self, kAssociatedObjectKeyForUserInfo);
}

- (void)setUserInfo:(id)userInfo {
    objc_setAssociatedObject(self, kAssociatedObjectKeyForUserInfo, userInfo, OBJC_ASSOCIATION_RETAIN);
}

@end



