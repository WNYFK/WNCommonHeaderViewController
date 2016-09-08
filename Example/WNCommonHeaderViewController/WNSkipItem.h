//
//  WNSkipItem.h
//  WNStudyDemo
//
//  Created by ChenBin on 16/8/12.
//  Copyright © 2016年 ChenBin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^WNNormalCallBack)();

@interface WNSkipItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) Class destinationClass;
@property (nonatomic, copy) WNNormalCallBack callBack;

- (instancetype)initWithTitle:(NSString *)title destinationClass:(Class)dClass;
- (instancetype)initWithTitle:(NSString *)title callBack:(WNNormalCallBack)callBack;

@end

@interface WNSectionItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong, readonly) NSMutableArray<WNSkipItem *> *cellItems;

- (instancetype)initWithTitle:(NSString *)title;

@end