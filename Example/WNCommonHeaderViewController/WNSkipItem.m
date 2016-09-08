//
//  WNSkipItem.m
//  WNStudyDemo
//
//  Created by ChenBin on 16/8/12.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import "WNSkipItem.h"

@implementation WNSkipItem

- (instancetype)initWithTitle:(NSString *)title destinationClass:(Class)dClass {
    if (self = [super init]) {
        self.title = title;
        self.destinationClass = dClass;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title callBack:(WNNormalCallBack)callBack {
    if (self = [super init]) {
        self.title = title;
        self.callBack = callBack;
    }
    return self;
}
@end

@interface WNSectionItem ()

@property (nonatomic, strong) NSMutableArray<WNSkipItem *> *cellItems;

@end

@implementation WNSectionItem

- (instancetype)initWithTitle:(NSString *)title {
    if (self = [self init]) {
        self.title = title;
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.cellItems = [NSMutableArray array];
    }
    return self;
}

@end