//
//  ViewController.m
//  iOSDC-BlackMagick
//
//  Created by Yudai.Hirose on 2018/08/21.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import "TableViewCell.h"
#import "NSObject+Name.h"


@protocol MyProtocol
@required
- (void)foo;
@optional
- (void)bar;
@end

@interface Fuga: NSObject

@end

@implementation Fuga

@end

@interface Hoge: NSObject
@property (nonatomic, copy) NSString *name;
@end

@implementation Hoge

@end

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation ViewController


static const char * getPropertyType(objc_property_t property) {
    const char *attributes = property_getAttributes(property);
//    printf("attributes=%s\n", attributes);
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL) {
        if (attribute[0] == 'T' && attribute[1] != '@') {
            // it's a C primitive type:
            /*
             if you want a list of what will be returned for these primitives, search online for
             "objective-c" "Property Attribute Description Examples"
             apple docs list plenty of examples of what you get for int "i", long "l", unsigned "I", struct, etc.
             */
            return (const char *)[[NSData dataWithBytes:(attribute + 1) length:strlen(attribute) - 1] bytes];
        }
        else if (attribute[0] == 'T' && attribute[1] == '@' && strlen(attribute) == 2) {
            // it's an ObjC id type:
            return "id";
        }
        else if (attribute[0] == 'T' && attribute[1] == '@') {
            // it's another ObjC object type:
            return (const char *)[[NSData dataWithBytes:(attribute + 3) length:strlen(attribute) - 4] bytes];
        }
    }
    return "";
}

+ (NSDictionary *)properties:(Class)cls
{
    NSMutableDictionary *results = [[NSMutableDictionary alloc] init];
    
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(cls, &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        if(propName) {
            const char *propType = getPropertyType(property);
            NSString *propertyName = [NSString stringWithUTF8String:propName];
            NSString *propertyType = [NSString stringWithUTF8String:propType];
            if (!propertyType) {
                NSLog(@" --- nil type --- ");
                NSLog(@"propertyName: %@", propertyName);
                NSLog(@"raw type: %s", propType);
                NSLog(@"type: %@", propertyType);
                continue;
            }
               
            [results setObject:propertyType forKey:propertyName];
        }
    }
    free(properties);
    
    // returning a copy here to make sure the dictionary is immutable
    return [NSDictionary dictionaryWithDictionary:results];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:@"TableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"Cell"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView reloadData];
//
//    Class kls = objc_getClass("NSString");
//    [self addMethodImplementationWithBlocks];
//
//    NSLog(@"properties: %@", [ViewController properties:[Hoge class]]);
    
    [self enumerationMutation];
    
    NSObject *object = [NSObject new];
    NSLog(@"object: %@", object.userInfo); // object: (null)
    object.userInfo = @"myName";
    NSLog(@"object: %@", object.userInfo); // object: myName
    
    UILabel *label = [[UILabel alloc] init];
    label.userInfo = @(100);

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.userInfo = label;
    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buttonPressed:(UIButton*) button {
    UILabel *label = button.userInfo;
    NSInteger value = [label.userInfo integerValue];
    button.tag = value;
}


- (NSArray *)getAllClassName {
    int numClasses = objc_getClassList(NULL, 0);
    Class *classes = NULL;
    
    classes =  (__unsafe_unretained Class *)malloc(sizeof(Class) * numClasses);
    numClasses = objc_getClassList(classes, numClasses);
    
    NSMutableArray *result = [NSMutableArray array];
    for (NSInteger i = 0; i < numClasses; i++)
    {
        Class cls = classes[i];
        NSString *name = NSStringFromClass(cls);
        [result addObject:name];
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
    NSLog(@"type of NSString * : %s", @encode( typeof( NSString *) ) );
    NSLog(@"NSString : %s", @encode(NSString));
    NSLog(@"NSObject * : %s", @encode( typeof( NSObject *) ) );
    NSLog(@"NSObject : %s", @encode(NSObject));
    NSLog(@"void : %s", @encode(void) );
    NSLog(@"type of void : %s", @encode( typeof( void) ) );
    NSLog(@"type of id : %s", @encode(id) );
    NSLog(@"NSArray : %s", @encode(typeof(NSArray)) );
}
    
- (void)enumerationMutation {
    NSNumber *target = @2;
    NSMutableArray *array = @[@1, target].mutableCopy;
    
    objc_setEnumerationMutationHandler(function);
    for (NSNumber *number in array) {
        NSLog(@"number: %@", number);
        [array removeObject:target];
    }
    

    NSLog(@"array: %@", array);
}

void function(NSMutableArray *array) {
    NSLog(@"%@", array);
}

//void objc_enumerationMutation(id obj) {
//    NSLog(@"%@", obj);
//    //    NSException *exception = [NSException exceptionWithName:@"Array Error" reason:@"Exception" userInfo:nil];
//    //    [exception raise];
//}

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
    SEL sel = sel_registerName("piyo");
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = (TableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.titleLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row];
    [cell performSelector:@selector(_removeFloatingSeparator)];
    
//    NSLog(@"tableView: %d", [cell performSelector:@selector(_showSeparatorAtTopOfSection)]);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SecondViewController" bundle:nil];
    UIViewController *secondViewController = [storyboard instantiateInitialViewController];
    [self.navigationController pushViewController:secondViewController animated:true];
}

@end
