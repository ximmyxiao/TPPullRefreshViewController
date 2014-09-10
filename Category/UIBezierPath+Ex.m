//
//  UIBezierPath+Ex.m
//  QQMovieTicket
//
//  Created by 谌启亮 on 13-4-24.
//  Copyright (c) 2013年 谌启亮. All rights reserved.
//

#import "UIBezierPath+Ex.h"

#define DEG2ARC(x) (x/180.0f*M_PI)

@implementation UIBezierPath (Ex)

+ (UIBezierPath*)bezierPathWithPentagramOfRadius:(CGFloat)radius{
    float innerRadius = radius*sinf(DEG2ARC(18))/sinf(DEG2ARC(126));
    return [self bezierPathWithPentagramOfRadius:radius innerRadius:innerRadius];
}

+ (UIBezierPath*)bezierPathWithPentagramOfRadius:(CGFloat)radius innerRadius:(CGFloat)innerRadius{
    UIBezierPath *pentagramPath = [UIBezierPath bezierPath];
    [pentagramPath moveToPoint:CGPointMake(radius*(1-cosf(DEG2ARC(18))), radius*(1-sinf(DEG2ARC(18))))];
    float degree = 18;
    for (int i = 0; i < 6; i++) {
        [pentagramPath addLineToPoint:CGPointMake(radius*(1-cosf(DEG2ARC(degree))), radius*(1-sinf(DEG2ARC(degree))))];
        degree+=36;
        [pentagramPath addLineToPoint:CGPointMake(radius-innerRadius*cosf(DEG2ARC(degree)), radius-innerRadius*sinf(DEG2ARC(degree)))];
        degree+=36;
    }
    [pentagramPath closePath];
    return pentagramPath;
}

@end
