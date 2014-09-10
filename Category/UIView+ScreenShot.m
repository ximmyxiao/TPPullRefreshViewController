//
//  UIView+ScreenShot.m
//  QQMovieTicket
//
//  Created by 谌启亮 on 13-5-13.
//  Copyright (c) 2013年 谌启亮. All rights reserved.
//

#import "UIView+ScreenShot.h"

@implementation UIView (ScreenShot)

- (UIImage*)screenShotImage{
    return [self screenShotImageWithZoomScale:1];
}

- (UIImage*)screenShotImageWithZoomScale:(CGFloat)zoomScale{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.bounds.size.width*zoomScale, self.bounds.size.height*zoomScale), NO, self.contentScaleFactor);
    CGContextScaleCTM(UIGraphicsGetCurrentContext(), zoomScale, zoomScale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenShotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenShotImage;
}

@end
