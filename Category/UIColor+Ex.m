//
//  UIColor+Ex.m
//  QQMovieTicket
//
//  Created by 谌启亮 on 13-4-18.
//  Copyright (c) 2013年 谌启亮. All rights reserved.
//

#import "UIColor+Ex.h"

@implementation UIColor (Ex)

+ (UIColor*)colorWithRGB:(int)rgb{
    return [UIColor colorWithRed:((rgb&0xFF0000)>>16)/255.0 green:((rgb&0xFF00)>>8)/255.0 blue:(rgb&0xFF)/255.0 alpha:1];
}

@end
