//
//  UIView+Resize.m
//  QQTicket
//
//  Created by 启亮 谌 on 12-2-2.
//  Copyright (c) 2012年 tencent. All rights reserved.
//

#import "UIView+Resize.h"

@implementation UIView(Resize)

- (CGFloat)width{
	return self.frame.size.width;
}

- (void)setWidth:(CGFloat)w{
	CGRect rect = self.frame;
	rect.size.width = w;
	self.frame = rect;
}

- (CGFloat)height{
	return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height{
	CGRect rect = self.frame;
	rect.size.height = height;
	self.frame = rect;    
}

- (CGFloat)x_origin{
	return self.frame.origin.x;
}

- (CGFloat)y_origin{
	return self.frame.origin.y;
}
- (void)setY_origin:(CGFloat)y_origin{
	CGRect rect = self.frame;
	rect.origin.y = y_origin;
	self.frame = rect;    
}

- (void)setX_origin:(CGFloat)x_origin{
	CGRect rect = self.frame;
	rect.origin.x = x_origin;
	self.frame = rect;    
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect rect = self.frame;
	rect.origin = origin;
	self.frame = rect;
}

- (void)setSize:(CGSize)size
{
    CGRect rect = self.frame;
	rect.size = size;
	self.frame = rect;
}
@end
