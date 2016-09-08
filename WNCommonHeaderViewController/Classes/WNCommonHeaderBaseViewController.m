//
//  WNCommonHeaderBaseViewController.m
//  moviePro
//
//  Created by chenbin on 16/8/29.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "WNCommonHeaderBaseViewController.h"
#import "WNScrollView.h"
#import "UIView+WNLayout.h"

@interface WNCommonHeaderBaseViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) WNScrollView *horizontalScrollView;
@property (nonatomic, strong) UIView *commonContentView;
@property (nonatomic, assign) NSInteger curSelectedIndex;
@property (nonatomic, assign) BOOL isEndDraging;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *originSubSViewInsetTopValueArr;
@property (nonatomic, assign) BOOL suspension;

@property (nonatomic, assign) BOOL firstLoad;

@end

@implementation WNCommonHeaderBaseViewController
@synthesize commonHeaderView = _commonHeaderView;
@synthesize commonSegmentView = _commonSegmentView;

- (void)dealloc {
    [self.viewControllers enumerateObjectsUsingBlock:^(UIViewController<WNCommonHeaderProtocol> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj.contentScrollView removeObserver:self forKeyPath:@"contentOffset"];
    }];
    [self.horizontalScrollView removeObserver:self forKeyPath:@"frame"];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.curSelectedIndex = -1;
    }
    return self;
}

- (UIView *)commonHeaderView {
    if (!_commonHeaderView) {
        _commonHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _commonHeaderView;
}

- (UIView *)commonSegmentView {
    if (!_commonSegmentView) {
        _commonSegmentView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _commonSegmentView;
}

- (NSMutableArray<NSNumber *> *)originSubSViewInsetTopValueArr {
    if (!_originSubSViewInsetTopValueArr) {
        _originSubSViewInsetTopValueArr = [NSMutableArray array];
    }
    return _originSubSViewInsetTopValueArr;
}

- (UIView *)commonContentView {
    if (!_commonContentView) {
        _commonContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 0)];
        _commonContentView.backgroundColor = [UIColor whiteColor];
        [self addViewsForEnableHorizontalScroll:@[_commonContentView]];
    }
    return _commonContentView;
}

- (WNScrollView *)horizontalScrollView {
    if (!_horizontalScrollView) {
        _horizontalScrollView = [[WNScrollView alloc] initWithFrame:self.view.bounds];
        _horizontalScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _horizontalScrollView.delegate = self;
        _horizontalScrollView.pagingEnabled = YES;
        _horizontalScrollView.bounces = NO;
        _horizontalScrollView.scrollsToTop = NO;
        _horizontalScrollView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:_horizontalScrollView];
    }
    return _horizontalScrollView;
}

- (void)setViewControllers:(NSArray<UIViewController<WNCommonHeaderProtocol> *> *)viewControllers {
    if (_viewControllers == viewControllers) return;
    _viewControllers = viewControllers;
    [self.originSubSViewInsetTopValueArr removeAllObjects];
    self.horizontalScrollView.contentSize = CGSizeMake(self.horizontalScrollView.WN_width * viewControllers.count, self.horizontalScrollView.WN_height);
    [self.viewControllers enumerateObjectsUsingBlock:^(UIViewController<WNCommonHeaderProtocol> * _Nonnull vc, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addChildViewController:vc];
        if ([vc respondsToSelector:@selector(contentScrollView)]) {
            [self.horizontalScrollView addSubview:vc.view];
            [vc didMoveToParentViewController:self];
            vc.view.frame = CGRectMake(idx * self.horizontalScrollView.WN_width, 0, self.horizontalScrollView.WN_width, self.horizontalScrollView.WN_height);
            vc.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin;
            UIScrollView *ctScrollView = [vc contentScrollView];
            ctScrollView.scrollsToTop = NO;
            ctScrollView.showsVerticalScrollIndicator = NO;
            [self.originSubSViewInsetTopValueArr addObject:@(ctScrollView.contentInset.top)];
        }
    }];
    [self.viewControllers enumerateObjectsUsingBlock:^(UIViewController<WNCommonHeaderProtocol> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addObserverSubViewController:obj];
    }];
}

- (void)setCommonHeaderView:(UIView *)commonHeaderView {
    if (_commonHeaderView != commonHeaderView) {
        [_commonHeaderView removeFromSuperview];
        _commonHeaderView = commonHeaderView != nil ? commonHeaderView : [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.horizontalScrollView.WN_width, 0)];
        [self.commonContentView addSubview:commonHeaderView];
        [self checkHeaderPosition];
    } else if (_commonHeaderView.WN_height != commonHeaderView.WN_height) {
        [self checkHeaderPosition];
    }
}

- (void)setCommonSegmentView:(UIView *)commonSegmentView {
    if (_commonSegmentView != commonSegmentView) {
        [_commonSegmentView removeFromSuperview];
        _commonSegmentView = commonSegmentView != nil ? commonSegmentView : [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.horizontalScrollView.WN_width, 0)];
        [self.commonContentView addSubview:commonSegmentView];
        [self checkHeaderPosition];
    } else if (_commonSegmentView.WN_height != commonSegmentView.WN_height) {
        [self checkHeaderPosition];
    }
}

- (void)setHeaderAndSegmentSpace:(CGFloat)headerAndSegmentSpace {
    if (_headerAndSegmentSpace != headerAndSegmentSpace) {
        _headerAndSegmentSpace = headerAndSegmentSpace;
        [self checkHeaderPosition];
    }
}

- (void)checkHeaderPosition {
    self.commonHeaderView.WN_y = 0;
    self.commonSegmentView.WN_y = self.commonHeaderView.WN_bottom + ((self.commonHeaderView.WN_height != 0) ? self.headerAndSegmentSpace : 0);
    if (self.commonContentView.WN_height != self.commonSegmentView.WN_bottom) {
        self.commonContentView.WN_height = self.commonSegmentView.WN_bottom;
        [self updateSubScrollViewContentInset];
    }
}

- (void)updateSubScrollViewContentInset {
    [self.viewControllers enumerateObjectsUsingBlock:^(UIViewController<WNCommonHeaderProtocol> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIScrollView *ctScrollView = [obj contentScrollView];
        if ([ctScrollView isKindOfClass:[UIScrollView class]]) {
            CGFloat top = 0;
            if (self.originSubSViewInsetTopValueArr.count > idx) {
                top = [self.originSubSViewInsetTopValueArr[idx] floatValue];
            } else {
                top = ctScrollView.contentInset.top;
                [self.originSubSViewInsetTopValueArr addObject:@(top)];
            }
            UIEdgeInsets contentInset = UIEdgeInsetsMake(top + self.commonContentView.WN_height, ctScrollView.contentInset.left, ctScrollView.contentInset.bottom, ctScrollView.contentInset.right);
            ctScrollView.contentInset = contentInset;
            ctScrollView.contentOffset = CGPointMake(0, -ctScrollView.contentInset.top);
            if ([obj respondsToSelector:@selector(scrollViewContentInsetChanged:)]) {
                [obj scrollViewContentInsetChanged:contentInset];
            }
            if ([obj respondsToSelector:@selector(enableHorizontalScrollSubViews)]) {
                [self addViewsForEnableHorizontalScroll:[obj enableHorizontalScrollSubViews]];
            }
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.firstLoad) {
        [self checkHeaderPosition];
        [self updateHeaderToCurScrollView:self.curSelectedIndex > 0 ? self.curSelectedIndex : 0];
        [self updateSubScrollViewContentInset];
        self.firstLoad = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.firstLoad = YES;
    if (self.navigationController) {
        [self.horizontalScrollView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
    }
    [self.horizontalScrollView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)addViewsForEnableHorizontalScroll:(NSArray<UIView *> *)views {
    [self.horizontalScrollView addViewsForEnableScrollView:views];
}

- (void)addObserverSubViewController:(UIViewController<WNCommonHeaderProtocol> *)viewController {
    id<WNCommonHeaderProtocol> vcDelegate = (id<WNCommonHeaderProtocol>)viewController;
    if ([vcDelegate respondsToSelector:@selector(contentScrollView)]) {
        UIScrollView *scrollView = [vcDelegate contentScrollView];
        [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (object == self.horizontalScrollView) {
        self.horizontalScrollView.contentSize = CGSizeMake(self.horizontalScrollView.contentSize.width, self.horizontalScrollView.WN_height);
        return;
    }
    __block UIViewController<WNCommonHeaderProtocol> *viewController;
    [self.viewControllers enumerateObjectsUsingBlock:^(UIViewController<WNCommonHeaderProtocol> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj contentScrollView] == object) {
            viewController = obj;
            *stop = YES;
        }
    }];
    if ([self.viewControllers indexOfObject:viewController] != self.curSelectedIndex) return;
    UIScrollView *scrollView = [viewController contentScrollView];
    if (self.commonContentView.superview != scrollView) {
        [scrollView addSubview:self.commonContentView];
        self.commonContentView.WN_x = 0;
    }
    CGPoint point = scrollView.contentOffset;
    CGFloat top = scrollView.contentInset.top;
    if (top > self.commonContentView.WN_height) {
        self.suspension = NO;
        self.commonContentView.WN_y = - self.commonContentView.WN_height;
    } else {
        self.commonContentView.WN_y = point.y + top > (self.commonHeaderView.WN_height + self.headerAndSegmentSpace) ? point.y - (self.commonHeaderView.WN_height + self.headerAndSegmentSpace) : -top;
        if (!self.suspension) { //segment悬浮时不需要去更新其它scrollview的contentoffset
            [self.viewControllers enumerateObjectsUsingBlock:^(UIViewController<WNCommonHeaderProtocol> * _Nonnull vc, NSUInteger idx, BOOL * _Nonnull stop) {
                if (self.curSelectedIndex != idx && [vc respondsToSelector:@selector(contentScrollView)]) {
                    UIScrollView *ctScrollView = [vc contentScrollView];
                    ctScrollView.contentOffset = point;
                }
            }];
        }
    }
    self.suspension = self.commonContentView.WN_bottom > 0;
    [scrollView bringSubviewToFront:self.commonContentView];
}

- (void)updateHeaderToCurScrollView:(NSInteger)index {
    if (self.curSelectedIndex >= 0) {
        UIViewController<WNCommonHeaderProtocol> *lastViewController = self.viewControllers[self.curSelectedIndex];
        lastViewController.contentScrollView.scrollsToTop = NO;
    }
    BOOL hadSelected = NO;
    UIViewController<WNCommonHeaderProtocol> *curViewController = self.viewControllers[index];
    if ([curViewController respondsToSelector:@selector(contentScrollView)]) {
        UIScrollView *curScrollView = [curViewController contentScrollView];
        curScrollView.scrollsToTop = YES;
        self.commonContentView.WN_x = 0;
        if (curScrollView != self.commonContentView.superview) {
            [curScrollView addSubview:self.commonContentView];
            CGPoint point = curScrollView.contentOffset;
            CGFloat top = curScrollView.contentInset.top;
            self.commonContentView.WN_y = point.y + top > (self.commonHeaderView.WN_height + self.headerAndSegmentSpace) ? point.y - (self.commonHeaderView.WN_height + self.headerAndSegmentSpace) : -top;
            [curScrollView bringSubviewToFront:self.commonContentView];
            self.horizontalScrollView.contentOffset = CGPointMake(index * self.horizontalScrollView.WN_width, self.horizontalScrollView.contentOffset.y);
            hadSelected = YES;
        }
    }
    self.curSelectedIndex = index;
    if (self.curSelectedIndex >= 0 && hadSelected && [self.delegate respondsToSelector:@selector(selectedViewControllerWithIndex:viewController:)]) {
        [self.delegate selectedViewControllerWithIndex:self.curSelectedIndex viewController:curViewController];
    }
}

- (void)selectViewControllerWithIndex:(NSUInteger)index {
    if (index < self.viewControllers.count && self.curSelectedIndex != index) {
        [self updateHeaderToCurScrollView:index];
    }
}

#pragma mark scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.horizontalScrollView) {
        if (self.commonContentView.superview == self.horizontalScrollView) {
            CGFloat x = scrollView.contentOffset.x;
            self.commonContentView.WN_x = x > 0 ? x : 0;
        }
        if (self.isEndDraging && (int)scrollView.contentOffset.x % (int)scrollView.WN_width <= 1) {
            NSUInteger newPageIndex = floor((scrollView.contentOffset.x - scrollView.frame.size.width / 2)) / scrollView.frame.size.width + 1;
            [self updateHeaderToCurScrollView:newPageIndex];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.isEndDraging = YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView == self.horizontalScrollView && self.commonContentView.superview != self.horizontalScrollView && scrollView.contentOffset.x >= 0 && scrollView.contentOffset.x <= self.horizontalScrollView.WN_width * (self.viewControllers.count - 1)) {
        UIScrollView *superScrollView = (UIScrollView *)self.commonContentView.superview;
        CGFloat y = -(superScrollView.contentOffset.y + superScrollView.contentInset.top);
        y = y < - (self.commonHeaderView.WN_height + self.headerAndSegmentSpace) ? -(self.commonHeaderView.WN_height + self.headerAndSegmentSpace) : y;
        [self.horizontalScrollView addSubview:self.commonContentView];
        self.commonContentView.WN_y = y;
        self.commonContentView.WN_x = scrollView.contentOffset.x;
        [self.horizontalScrollView bringSubviewToFront:self.commonContentView];
        self.isEndDraging = NO;
    }
}

#pragma mark SwpePop

- (BOOL)swipePopSupporttedForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint point = [(UIPanGestureRecognizer *)gestureRecognizer velocityInView:gestureRecognizer.view];
    if (self.horizontalScrollView.contentOffset.x <=0 && point.x >=0) {
        return YES;
    }
    return NO;
}

@end
