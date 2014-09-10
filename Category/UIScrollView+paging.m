//
//  UIScrollView+paging.m
//  QQMovieTicket
//
//  Created by Jolin He on 14-1-16.
//  Copyright (c) 2014年 brightshen. All rights reserved.
//

#import "UIScrollView+paging.h"

@implementation UIScrollView(Pagging)
-(NSUInteger)currentPage{
    NSUInteger currentIndex = (NSUInteger)((self.contentOffset.x+self.bounds.size.width/2)/self.bounds.size.width);
    return currentIndex;
}
@end
