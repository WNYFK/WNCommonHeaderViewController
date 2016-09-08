//
//  UIView+WNLayout.m
//  WNCommonHeaderDemo
//
//  Created by chenbin on 16/9/7.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "UIView+WNLayout.h"

@implementation UIView (WNLayout)
- (CGFloat)WN_x {
    return self.frame.origin.x;
}

- (CGFloat)WN_y {
    return self.frame.origin.y;
}

- (CGFloat)WN_right {
    return self.WN_x + self.WN_width;
}

- (CGFloat)WN_height {
    return self.frame.size.height;
}

- (CGFloat)WN_width {
    return self.frame.size.width;
}

- (CGFloat)WN_bottom {
    return self.frame.origin.y + self.WN_height;
}

- (void)setWN_x:(CGFloat)WN_x {
    self.frame = CGRectMake(WN_x, self.WN_y, self.WN_width, self.WN_height);
}

- (void)setWN_y:(CGFloat)WN_y {
    self.frame = CGRectMake(self.WN_x, WN_y, self.WN_width, self.WN_height);
}

- (void)setWN_right:(CGFloat)WN_right {
    self.frame = CGRectMake(WN_right - self.WN_width, self.WN_y, self.WN_width, self.WN_height);
}

- (void)setWN_width:(CGFloat)WN_width {
    self.frame = CGRectMake(self.WN_x, self.WN_y, WN_width, self.WN_height);
}

- (void)setWN_height:(CGFloat)WN_height {
    self.frame = CGRectMake(self.WN_x, self.WN_y, self.WN_width, WN_height);
}


- (void)setWN_bottom:(CGFloat)WN_bottom {
    self.frame = CGRectMake(self.WN_x, WN_bottom - self.WN_height, self.WN_width, self.WN_height);
}

@end
