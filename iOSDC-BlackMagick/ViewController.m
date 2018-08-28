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

void function(NSMutableArray *array) {
    NSLog(@"%@", array);
}

void objc_enumerationMutation(id obj) {
    NSLog(@"%@", obj);
//    NSException *exception = [NSException exceptionWithName:@"Array Error" reason:@"Exception" userInfo:nil];
//    [exception raise];
}

void (^piyoBlock)(id obj) = ^(id obj)
{
    NSLog(@"piyo");
};


- (void)viewDidLoad {
    [super viewDidLoad];

    Class aClass = objc_allocateClassPair([NSObject class], "A", sizeof([NSObject new]));
    objc_registerClassPair(aClass);
    
    id aaaa = [[NSClassFromString(@"A") alloc] init];
    NSString *string = @"hogehoge";
    
    NSLog(@"A: %@, string: %@", aaaa, string);
    
    NSNumber *target = @2;
    NSMutableArray *array = @[@1, target].mutableCopy;
    
    SEL sel = NSSelectorFromString(@"piyo");
    IMP imp = imp_implementationWithBlock(piyoBlock);
    class_addMethod([ViewController class], sel, imp, "v@");
    
    [self performSelector:@selector(piyo)];
    

    for (NSNumber *number in array) {
        NSLog(@"number: %@", number);
        [array removeObject:target];
    }
    
    NSLog(@"array: %@", array);
}

- (void)getClassName {
    int numClasses;
    Class * classes = NULL;
    
    classes = NULL;
    numClasses = objc_getClassList(NULL, 0);
    
    NSLog(@"count: %d", numClasses);
}

@end
