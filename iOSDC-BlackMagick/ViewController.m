//
//  ViewController.m
//  iOSDC-BlackMagick
//
//  Created by Yudai.Hirose on 2018/08/21.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>


@protocol MyProtocol
@required
- (void)foo;
@optional
- (void)bar;
@end

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    [self encodeType];
    
    for (id element in [self getNSObjectSubClass]) {
        NSLog(@"%@", element);
    }
    NSLog(@"%@", [ViewController implementedClasses:@protocol(MyProtocol)]);
}

- (NSArray *)getNSObjectSubClass {
    int numClasses = objc_getClassList(NULL, 0);
    Class parentClass = [NSObject class];
    Class *classes = NULL;
    
    classes =  (__unsafe_unretained Class *)malloc(sizeof(Class) * numClasses);
    numClasses = objc_getClassList(classes, numClasses);

    NSMutableArray *result = [NSMutableArray array];
    for (NSInteger i = 0; i < numClasses; i++)
    {
        // NSObjectを継承していないクラスを `addObject` しようとすると
        // このエラーメッセージが出る
        // does not implement methodSignatureForSelector
        Class cls = classes[i];
        Class superClass = cls;
        
        do {
            superClass = class_getSuperclass(superClass);
        }
        while(superClass && superClass != parentClass);
        
        if (superClass == nil) {
            continue;
        }

        [result addObject:cls];
    }
    
    free(classes);
    return result;
}

+(NSArray *)implementedClasses:(Protocol *)protocol
{
    int bufferCount = objc_getClassList(nil, 0);
    int implementedCount = 0;
    Class bufferClasses[bufferCount];
    Class implementedClasses[bufferCount];
    objc_getClassList(bufferClasses, bufferCount);

    for (int i = 0; i < bufferCount; i++)
    {
        if (!class_conformsToProtocol(bufferClasses[i], protocol)) continue;
        
        implementedClasses[implementedCount++] = bufferClasses[i];
    }
    
    return [NSArray arrayWithObjects:implementedClasses count:implementedCount];
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
