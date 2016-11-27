//
//  BarrageView.m
//  ZWBarrage
//
//  Created by William Chang on 16/11/28.
//  Copyright © 2016年 William Chang. All rights reserved.
//

#import "BarrageView.h"

#import "AnimationLayer.h"

#define KMoveKey @"key"


#define LAYERHEIGHT  30
#define FONTSIZE 15
#define MOVESPEED 100


#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

@interface BarrageView()

@property(nonatomic,strong) NSMutableArray *layerArray;
@property(nonatomic,strong) NSMutableArray *layerWidthArray;

@property(nonatomic,copy) void(^tapBlock)(NSInteger index);


@property(nonatomic,assign) NSInteger pauseTag;


@property(nonatomic,assign) BOOL isPause;

@end

@implementation BarrageView

- (instancetype)initWithFrame:(CGRect)frame dataArray:(NSArray *)array tapBlock:(void(^)(NSInteger))tapBlock
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.dataArray = array;
        self.tapBlock = tapBlock;
        
        [self setUpLayer];
        
        [self addGesture];
        
        self.backgroundColor = [[UIColor grayColor]colorWithAlphaComponent:0.6];
    }
    return self;
}


- (void)addGesture
{
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    
    [self addGestureRecognizer:gesture];
}


- (void)tap:(UITapGestureRecognizer *)gesture
{
    CGPoint touchPoint = [gesture locationInView:self];
    for (CALayer *layer in self.layerArray) {
        if ([layer.presentationLayer hitTest:touchPoint]) {
            
            if (self.tapBlock) {
                self.tapBlock(layer.name.integerValue);
            }
            //可能会有多个监听，屏蔽
            return;
            
            
        }
        
    }
}




//用name来记录每一个layer层，相当于view的tag:CATextLayer

-(void)setUpLayer
{
    
    for (int i = 0; i<self.dataArray.count; i++) {
        CATextLayer* moveLayer = [[CATextLayer alloc]init];
        
        moveLayer.fontSize = FONTSIZE;
        
        CGFloat width =  [self.dataArray[i] boundingRectWithSize:CGSizeMake(MAXFLOAT, LAYERHEIGHT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.width;
        moveLayer.frame = CGRectMake(SCREEN_WIDTH, 0,width ,LAYERHEIGHT);
        //  moveLayer.backgroundColor = [UIColor colorWithRed:0.1*arc4random_uniform(10) green:0.1*arc4random_uniform(10) blue:0.1*arc4random_uniform(10) alpha:1].CGColor;
        moveLayer.foregroundColor = [UIColor colorWithRed:0.1*arc4random_uniform(10) green:0.1*arc4random_uniform(10) blue:0.1*arc4random_uniform(10) alpha:1].CGColor;
        moveLayer.contentsScale = 2;
        //moveLayer.cornerRadius = LAYERHEIGHT/2;
        moveLayer.name = [NSString stringWithFormat:@"%d",i];
        moveLayer.string = self.dataArray[i];
        [self.layer addSublayer:moveLayer];
        moveLayer.alignmentMode = @"center";
        
        [self.layerArray addObject:moveLayer];
        
        [self.layerWidthArray addObject:@(width)];
    }
    
    [self startMove];
}






static NSInteger tag = 0;

- (void)startMove
{
    
    if (self.isPause) {
        return;
    }
    
    if (tag == -1) {
        tag = 0;
    }else if (tag == self.dataArray.count){
        tag = 0;
    }
    CALayer *moveLayer = self.layerArray[tag];
    CGFloat randY = [self getRandomY:self.frame];
    
    
    CGFloat layWidth = [self.layerWidthArray[tag] floatValue];
    CGFloat distance = SCREEN_WIDTH+layWidth;
    CABasicAnimation *aniLayer = [AnimationLayer positionWithDuration:distance/MOVESPEED from:CGPointMake(SCREEN_WIDTH+layWidth/2, randY) to:CGPointMake(-layWidth ,randY) delegate:self];
    [moveLayer removeAllAnimations];
    [moveLayer addAnimation:(CABasicAnimation *)aniLayer forKey:KMoveKey];
    
    
    if (tag == self.dataArray.count-1) {
        tag = -1;
    }
    
    if (!self.isPause) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            tag++;
            
            if (!self.isPause) {
                [self startMove];
            }
            
        });
    }
    
}


- (CGFloat)getRandomY:(CGRect)frame
{
    CGFloat y =  arc4random_uniform(CGRectGetHeight(self.frame))+LAYERHEIGHT/2;
    
    if (y >= self.frame.size.height-(LAYERHEIGHT/2)) {
        y -= LAYERHEIGHT;
    }
    
    return y;
}



#pragma mark --动画暂停，继续
- (void)pause
{
    for (CALayer *layer in self.layerArray) {
        if (layer.speed == 1.0)
        {
            [self pauseAnimation:self];
            
        }
    }
}




- (void)resume
{
    
    for (CALayer *layer in self.layerArray) {
        if (layer.speed == 0.0)
        {
            [self resumeAnimation:self];
            
        }
    }
}



- (void)pauseAnimation:(UIView *)aniView
{
    
    self.isPause = YES;
    
    for (CALayer *layer in aniView.layer.sublayers) {
        
        CFTimeInterval pauseTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
        layer.timeOffset = pauseTime;
        
        layer.speed = 0.0f;
    }
    
}

- (void)resumeAnimation:(UIView *)aniView
{
    self.isPause = NO;
    [self startMove];
    
    
    for (CALayer *layer in aniView.layer.sublayers) {
        CFTimeInterval pauseTime = layer.timeOffset;
        CFTimeInterval beginTime = CACurrentMediaTime() - pauseTime;
        
        layer.timeOffset = 0.0;
        layer.beginTime = beginTime;
        
        layer.speed = 1.0;
        
    }
    
}




#pragma mark -- lazyLoading
- (NSMutableArray *)layerArray
{
    if (_layerArray == nil) {
        _layerArray = [[NSMutableArray alloc]init];
    }
    return _layerArray;
}


- (NSMutableArray *)layerWidthArray
{
    if (_layerWidthArray == nil) {
        _layerWidthArray = [[NSMutableArray alloc]init];
    }
    return _layerWidthArray;
}


@end
