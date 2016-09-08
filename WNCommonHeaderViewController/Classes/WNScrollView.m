//
//  WNScrollView.m
//  WNCommonHeaderDemo
//
//  Created by chenbin on 16/9/7.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "WNScrollView.h"

@interface WNScrollView ()

@property (nonatomic, strong) NSMutableSet<UIView *> *enableScrollForViews;

@end

@implementation WNScrollView

- (NSMutableSet<UIView *> *)enableScrollForViews {
    if (!_enableScrollForViews) {
        _enableScrollForViews = [[NSMutableSet alloc] init];
    }
    return _enableScrollForViews;
}

- (void)addViewsForEnableScrollView:(NSArray<UIView *> *)views {
    [self.enableScrollForViews addObjectsFromArray:views];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view && [self.enableScrollForViews containsObject:view]) {
        self.scrollEnabled = NO;
    } else {
        self.scrollEnabled = YES;
    }
    return view;
}

@end
