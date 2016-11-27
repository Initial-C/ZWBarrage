//
//  BarrageView.h
//  ZWBarrage
//
//  Created by William Chang on 16/11/28.
//  Copyright © 2016年 William Chang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BarrageView : UIView

@property(nonatomic,strong)NSArray *dataArray;

- (void)pause;
- (void)resume;

- (instancetype)initWithFrame:(CGRect)frame dataArray:(NSArray *)array tapBlock:(void(^)(NSInteger))tapBlock;

@end
