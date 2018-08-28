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

    [self encodeType];
    
}

- (void) encodeType {
    
    NSLog(@"char       : %s", @encode( typeof( char  ) ) );
    NSLog(@"char *     : %s", @encode( typeof( char *) ) );
    NSLog(@"int        : %s", @encode( typeof( int   ) ) );
    NSLog(@"float      : %s", @encode( typeof( float ) ) );
    NSLog(@"float *    : %s", @encode( typeof( float*) ) );
    NSLog(@"void       : %s", @encode( typeof( void  ) ) );
    NSLog(@"void *     : %s", @encode( typeof( void *) ) );
    NSLog(@"NSString * : %s", @encode( typeof( NSString *) ) );
    NSLog(@"NSObject * : %s", @encode( typeof( NSObject *) ) );
    NSLog(@"NSObject : %s", @encode(NSObject));
    NSLog(@"void : %s", @encode(void) );
    NSLog(@"type of void : %s", @encode( typeof( void) ) );
    NSLog(@"type of void : %s", @encode(id) );
}
    
- (void)enumerationMutation {
    NSNumber *target = @2;
    NSMutableArray *array = @[@1, target].mutableCopy;
    
    for (NSNumber *number in array) {
        NSLog(@"number: %@", number);
        [array removeObject:target];
    }
    
    NSLog(@"array: %@", array);
}

void function(NSMutableArray *array) {
    NSLog(@"%@", array);
}

void objc_enumerationMutation(id obj) {
    NSLog(@"%@", obj);
    //    NSException *exception = [NSException exceptionWithName:@"Array Error" reason:@"Exception" userInfo:nil];
    //    [exception raise];
}

- (void)addClass {
    Class aClass = objc_allocateClassPair([NSObject class], "A", sizeof([NSObject new]));
    objc_registerClassPair(aClass);
    
    id aaaa = [[objc_getClass("A") alloc] init];
    NSString *string = @"hogehoge";
    
    NSLog(@"A: %@, string: %@", aaaa, string);
}

void (^piyoBlock)(id obj) = ^(id obj)
{
    NSLog(@"piyo");
};

- (void)addMethodImplementationWithBlocks {
    SEL sel = NSSelectorFromString(@"piyo");
    IMP imp = imp_implementationWithBlock(piyoBlock);
    class_addMethod([ViewController class], sel, imp, "v@");
    
    [self performSelector:@selector(piyo)];
}

- (void)getClassName {
    int numClasses;
    Class * classes = NULL;
    
    classes = NULL;
    numClasses = objc_getClassList(NULL, 0);
    
    NSLog(@"count: %d", numClasses);
}

@end
