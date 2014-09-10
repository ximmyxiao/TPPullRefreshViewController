//
//  UIView+ScreenShot.h
//  QQMovieTicket
//
//  Created by 谌启亮 on 13-5-13.
//  Copyright (c) 2013年 谌启亮. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ScreenShot)
- (UIImage*)screenShotImage;
- (UIImage*)screenShotImageWithZoomScale:(CGFloat)zoomScale;
@end
