//
//  WNCommonHeaderBaseViewController.h
//  moviePro
//
//  Created by chenbin on 16/8/29.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WNCommonHeaderProtocol <NSObject>

- (UIScrollView *)contentScrollView;

@optional

- (void)scrollViewContentInsetChanged:(UIEdgeInsets)contentInset;

- (NSArray<UIView *> *)enableHorizontalScrollSubViews;

@end

@protocol WNCommonHeaderHandleDelegate <NSObject>

- (void)selectedViewControllerWithIndex:(NSUInteger)index viewController:(UIViewController<WNCommonHeaderProtocol> *)viewController;

@end

@interface WNCommonHeaderBaseViewController : UIViewController

@property (nonatomic, weak) id<WNCommonHeaderHandleDelegate> delegate;
@property (nonatomic, copy) NSArray<UIViewController<WNCommonHeaderProtocol> *> *viewControllers;
@property (nonatomic, copy) UIView *commonHeaderView;
@property (nonatomic, assign) CGFloat headerAndSegmentSpace;
@property (nonatomic, copy) UIView *commonSegmentView;
@property (nonatomic, assign, readonly) NSInteger curSelectedIndex;

- (void)selectViewControllerWithIndex:(NSUInteger)index;

- (void)addViewsForEnableHorizontalScroll:(NSArray<UIView *> *)views;

@end
