//
//  ZWBarrageScene.h
//  ZWBarrage
//
//  Created by InitialC on 16/12/5.
//  Copyright © 2016年 William Chang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWBarrageModel.h"
#import "ZWBarrageUserModel.h"
#import "ZWEdgeInsetsLabel.h"

@class ZWBarrageManager;

@class ZWBarrageScene;


typedef void(^AnimationDidStopBlock)(ZWBarrageScene *scene);

@interface ZWBarrageScene : UIView <CAAnimationDelegate>

@property (copy, nonatomic) ZWBarrageModel *model;

@property (strong, nonatomic) ZWEdgeInsetsLabel *titleLabel;

@property (nonatomic, strong) UIView *textView;

@property (strong, nonatomic) UIButton *voteButton;

@property (strong, nonatomic) UIImageView *imageView;

@property (nonatomic, strong) UIImageView *backImageView;

@property (copy, nonatomic) AnimationDidStopBlock animationDidStopBlock;

- (void)scroll;

- (void)pause;

- (void)resume;

- (void)close;

- (instancetype)initWithFrame:(CGRect)frame Model:(ZWBarrageModel *)model;


@end
