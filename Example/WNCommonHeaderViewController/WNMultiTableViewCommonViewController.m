//
//  WNMultiTableViewCommonViewController.m
//  WNCommonHeaderViewController
//
//  Created by ChenBin on 16/9/8.
//  Copyright © 2016年 陈斌. All rights reserved.
//

#import "WNMultiTableViewCommonViewController.h"
#import "WNFirstTableViewController.h"
#import "WNSecondTableViewController.h"
#import "UIView+WNLayout.h"

@interface WNMultiTableViewCommonViewController ()<WNCommonHeaderHandleDelegate>

@property (nonatomic, strong) WNFirstTableViewController *firstTableViewController;
@property (nonatomic, strong) WNSecondTableViewController *secondTableViewController;

@end

@implementation WNMultiTableViewCommonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.firstTableViewController = [[WNFirstTableViewController alloc] init];
    self.secondTableViewController = [[WNSecondTableViewController alloc] init];
    self.commonHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.WN_width, 200)];
    self.commonHeaderView.backgroundColor = [UIColor yellowColor];
    self.commonSegmentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.WN_width, 60)];
    self.commonSegmentView.backgroundColor = [UIColor greenColor];
    self.viewControllers = @[self.firstTableViewController, self.secondTableViewController];
    self.headerAndSegmentSpace = 15;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"改高" style:UIBarButtonItemStylePlain target:self action:@selector(changeHeight)];
}

- (void)changeHeight {
    [self changeCommonHeaderToHeight:self.commonHeaderView.WN_height + 20];
}

#pragma mark WNCommonHeaderHandleDelegate

- (void)selectedViewControllerWithIndex:(NSUInteger)index viewController:(UIViewController<WNCommonHeaderProtocol> *)viewController {
    
}
@end
