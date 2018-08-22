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
}

void objc_setEnumerationMutationHandler(void (* _Nullable handler)(id  _Nonnull __strong args)) {
    NSLog(@"a");
}

- (void)viewDidLoad {
    [super viewDidLoad];

    Class aClass = objc_allocateClassPair([NSObject class], "A", sizeof([NSObject new]));
    objc_registerClassPair(aClass);
    
    id aaaa = [[NSClassFromString(@"A") alloc] init];
    NSString *string = @"hogehoge";
    
    NSLog(@"A: %@, string: %@", aaaa, string);
    
    NSNumber *target = @2;
    NSMutableArray *array = @[@1, target, @3].mutableCopy;
    
    objc_setEnumerationMutationHandler(function);
    protocol_conformsToProtocol(<#Protocol * _Nullable proto#>, <#Protocol * _Nullable other#>)

    for (NSNumber *number in array) {
        [array insertObject:@5 atIndex:0];
    }
}

@end
