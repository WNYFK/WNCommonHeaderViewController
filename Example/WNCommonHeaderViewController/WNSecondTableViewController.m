//
//  WNSecondTableViewController.m
//  WNCommonHeaderViewController
//
//  Created by ChenBin on 16/9/8.
//  Copyright © 2016年 陈斌. All rights reserved.
//

#import "WNSecondTableViewController.h"
#import "WNCommonHeaderBaseViewController.h"

@interface WNSecondTableViewController ()<WNCommonHeaderProtocol>

@end

@implementation WNSecondTableViewController

- (UIScrollView *)contentScrollView {
    return self.tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"SecondTableViewController----Cell:%ld",indexPath.row];
    return cell;
}

@end
