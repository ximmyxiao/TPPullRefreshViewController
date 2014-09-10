//
//  UILabel+Ex.m
//  QQMovieTicketiPad
//
//  Created by johntang on 13-3-25.
//  Copyright (c) 2013年 谌启亮. All rights reserved.
//

#import "UILabel+Ex.h"

@implementation UILabel (Ex)

+ (UILabel*)labelWithFrame:(CGRect)frame fontSize:(CGFloat)fontSize textColor:(UIColor *)textColor
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textColor = textColor;
    label.backgroundColor = [UIColor clearColor];
    return label;
}
@end
