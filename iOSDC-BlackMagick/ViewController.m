//
//  ViewController.m
//  iOSDC-BlackMagick
//
//  Created by Yudai.Hirose on 2018/08/21.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    Class aClass = objc_allocateClassPair([NSObject class], "A", sizeof([NSObject new]));
    objc_registerClassPair(aClass);
    
    
    id aaaa = [[NSClassFromString(@"A") alloc] init];
    NSString *string = @"hogehoge";
    
    NSLog(@"A: %@, string: %@", aaaa, string);
}

@end
