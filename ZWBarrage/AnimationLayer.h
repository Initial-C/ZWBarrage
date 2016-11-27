//
//  AnimationLayer.h
//  ZWBarrage
//
//  Created by William Chang on 16/11/28.
//  Copyright © 2016年 William Chang. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  动画视图的封装，封装的动画，可由外界任意图层添加:动画和图层解耦
 */
@interface AnimationLayer : UIView

@property(nonatomic,weak) id delegate;


#pragma mark 基本动画
+ (CABasicAnimation *)positionWithDuration:(CFTimeInterval)duration
                                      from:(CGPoint)from
                                        to:(CGPoint)to
                                  delegate:(id)delegate;


@end
