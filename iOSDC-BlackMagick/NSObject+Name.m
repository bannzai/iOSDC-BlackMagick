//
//  NSObject+Name.m
//  iOSDC-BlackMagick
//
//  Created by Yudai.Hirose on 2018/08/29.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

#import "NSObject+Name.h"
#import <objc/runtime.h>

static void *kAssociatedObjectKeyForName = "kAssociatedObjectKeyForName";

@implementation NSObject (Name)

- (NSString *)name {
    return (NSString *)objc_getAssociatedObject(self, kAssociatedObjectKeyForName);
}

- (void)setName:(NSString *)name {
    objc_setAssociatedObject(self, kAssociatedObjectKeyForName, name, OBJC_ASSOCIATION_RETAIN);
}

@end
