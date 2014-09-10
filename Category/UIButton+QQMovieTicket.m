//
//  UIButton+QQMovieTicket.m
//  QQMovieTicket
//
//  Created by 谌启亮 on 13-6-19.
//  Copyright (c) 2013年 谌启亮. All rights reserved.
//

#import "UIButton+QQMovieTicket.h"

@implementation UIButton (QQMovieTicket)

- (void)makeBottomBarOrangeButtonStyle{
    [self setBackgroundImage:[UIImage strechableImageWithName:@"btn_orange"] forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    self.titleLabel.shadowOffset = CGSizeMake(0, 1);
    [self setTitleShadowColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self setTitleShadowColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [self setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [self setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];

}

@end
