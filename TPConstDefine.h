//
//  TPConstDefine.h
//  TPCampus
//
//  Created by Piao Piao on 14-8-27.
//  Copyright (c) 2014年 Piao Piao. All rights reserved.
//

#ifndef TPCampus_TPConstDefine_h
#define TPCampus_TPConstDefine_h

#define IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height>560)
#define IS_IOS7_AND_LATER ([[UIDevice currentDevice].systemVersion floatValue]>6.9999)
#define UICOLOR_WITH_RGB(r,g,b) [UIColor colorWithRed:(CGFloat)r/255.f green:(CGFloat)g/255.f blue:(CGFloat)b/255.f alpha:1]
#define UICOLOR_WITH_VALUE(rgb) [UIColor colorWithRed:((rgb&0xFF0000)>>16)/255.0 green:((rgb&0xFF00)>>8)/255.0 blue:(rgb&0xFF)/255.0 alpha:1]


#define SYNTHESIZE_CATALOG_OBJ_PROPERTY(propertyGetter, propertySetter)                                                             \
- (id) propertyGetter {                                                                                                             \
return objc_getAssociatedObject(self, @selector( propertyGetter ));                                                             \
}                                                                                                                                   \
- (void) propertySetter (id)obj{                                                                                                    \
objc_setAssociatedObject(self, @selector( propertyGetter ), obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);                            \
}


#define SYNTHESIZE_CATALOG_VALUE_PROPERTY(valueType, propertyGetter, propertySetter)                                                \
- (valueType) propertyGetter {                                                                                                      \
valueType ret = {0};                                                                                                                  \
[objc_getAssociatedObject(self, @selector( propertyGetter )) getValue:&ret];                                                    \
return ret;                                                                                                                     \
}                                                                                                                                   \
- (void) propertySetter (valueType)value{                                                                                           \
NSValue *valueObj = [NSValue valueWithBytes:&value objCType:@encode(valueType)];                                                \
objc_setAssociatedObject(self, @selector( propertyGetter ), valueObj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);                       \
}


#pragma mark Debug Log Support

#ifdef DEBUG
#define QLOG(...)  NSLog(@"%s_%d: %@", __func__, __LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else
#define QLOG(...)
#endif
#define QERR(...)  NSLog(@"[ERROR] %s_%d: %@", __func__, __LINE__,[NSString stringWithFormat:__VA_ARGS__])

#endif
