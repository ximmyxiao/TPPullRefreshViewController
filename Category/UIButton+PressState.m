//
//  UIButton+PressState.m
//  QQMovieTicket
//
//  Created by Piao Piao on 14-4-18.
//  Copyright (c) 2014年 Tencent. All rights reserved.
//

#import "UIButton+PressState.h"

@implementation UIButton (PressState)

- (void)setGreenBtnPressState
{
    [self setBackgroundImage:[UIImage imageWithColor:UICOLOR_WITH_RGB(79, 185, 87)] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageWithColor:UICOLOR_WITH_RGB(50, 150, 50)] forState:UIControlStateSelected];
    [self setBackgroundImage:[UIImage imageWithColor:UICOLOR_WITH_RGB(50, 150, 50)] forState:UIControlStateHighlighted];
    
}


- (void)setYellowBtnPressState
{
    [self setBackgroundImage:[UIImage imageWithColor:UICOLOR_WITH_RGB(229, 188, 69)] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageWithColor:UICOLOR_WITH_RGB(200, 161, 53)] forState:UIControlStateSelected];
    [self setBackgroundImage:[UIImage imageWithColor:UICOLOR_WITH_RGB(200, 161, 53)] forState:UIControlStateHighlighted];

}


- (void)setRedBtnPressState
{
    [self setBackgroundImage:[UIImage imageWithColor:UICOLOR_WITH_RGB(231, 98, 87)] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageWithColor:UICOLOR_WITH_RGB(197 , 73 , 63)] forState:UIControlStateSelected];
    [self setBackgroundImage:[UIImage imageWithColor:UICOLOR_WITH_RGB(197 , 73 , 63)] forState:UIControlStateHighlighted];

}

- (void)setGrayBtnPressState
{
    [self setBackgroundImage:[UIImage imageWithColor:UICOLOR_WITH_RGB(226, 226, 226)] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageWithColor:UICOLOR_WITH_RGB(170 , 170 , 170)] forState:UIControlStateSelected];
    [self setBackgroundImage:[UIImage imageWithColor:UICOLOR_WITH_RGB(170 , 170 , 170)] forState:UIControlStateHighlighted];
    
}

@end
