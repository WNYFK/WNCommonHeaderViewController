//
//  WNHomeListViewController.m
//  WNCommonHeaderViewController
//
//  Created by ChenBin on 16/9/8.
//  Copyright © 2016年 陈斌. All rights reserved.
//

#import "WNHomeListViewController.h"
#import "WNMultiTableViewCommonViewController.h"

@implementation WNHomeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WNSectionItem *sectionItem = [[WNSectionItem alloc] init];
    [self.dataArr addObject:sectionItem];
    
    WNSkipItem *multiTableViewItem = [[WNSkipItem alloc] initWithTitle:@"多个tableview含有公共头部" destinationClass:[WNMultiTableViewCommonViewController class]];
    [sectionItem.cellItems addObject:multiTableViewItem];
    
}

@end
