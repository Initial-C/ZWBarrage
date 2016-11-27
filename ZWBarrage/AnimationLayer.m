//
//  AnimationLayer.m
//  ZWBarrage
//
//  Created by William Chang on 16/11/28.
//  Copyright © 2016年 William Chang. All rights reserved.
//

#import "AnimationLayer.h"

@interface AnimationLayer ()

/**
 *  捕获外界需要添加动画的superView，以保证在代理方法中可监听到
 */
@property(nonatomic,strong) UIView *superAnimationView;

@end


@implementation AnimationLayer

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}




#pragma mark - 基本动画
+ (CABasicAnimation *)positionWithDuration:(CFTimeInterval)duration from:(CGPoint)from to:(CGPoint)to delegate:(id)delegate
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    
    // fromValue & toValue
    animation.fromValue = [NSValue valueWithCGPoint:from];
    animation.toValue = [NSValue valueWithCGPoint:to];
    //    animation.autoreverses = YES;
    
    animation.duration = duration;
    animation.delegate = delegate;
    
    [animation setValue:@"positionAnimation" forKey:@"animationType"];
    [animation setValue:[NSValue valueWithCGPoint:to] forKey:@"targetPoint"];
    
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    
    return animation;
}







//摇晃动画
+ (CAKeyframeAnimation *)shakeAnimationWithDuration:(CFTimeInterval)duration angle:(CGFloat)angle
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    animation.values = @[@(angle), @(-angle), @(angle)];
    animation.repeatCount = MAXFLOAT;
    return animation;
}

@end
