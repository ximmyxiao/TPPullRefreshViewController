//
//  UIBezierPath+Ex.h
//  QQMovieTicket
//
//  Created by 谌启亮 on 13-4-24.
//  Copyright (c) 2013年 谌启亮. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBezierPath (Ex)

//创建五角星形的绘制路径，radius是五角星外切圆半径，innerRadius是内切圆半径，若没有创建正常规格五角星。
+ (UIBezierPath*)bezierPathWithPentagramOfRadius:(CGFloat)radius;
+ (UIBezierPath*)bezierPathWithPentagramOfRadius:(CGFloat)radius innerRadius:(CGFloat)innerRadius;

@end
