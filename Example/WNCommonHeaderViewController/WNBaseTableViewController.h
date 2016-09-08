//
//  WNBaseTableViewController.h
//  WNStudyDemo
//
//  Created by ChenBin on 16/8/12.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WNSkipItem.h"

@interface WNBaseTableViewController : UIViewController

@property (nonatomic, strong) NSMutableArray<WNSectionItem *> *dataArr;
@property (nonatomic, readonly) UITableView *tableView;

@end
