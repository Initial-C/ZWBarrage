//
//  ZWBarrageScene.m
//  ZWBarrage
//
//  Created by InitialC on 16/12/5.
//  Copyright © 2016年 William Chang. All rights reserved.
//

#import "ZWBarrageScene.h"
#import <QuartzCore/QuartzCore.h>
#import "ZWBarrageManager.h"

@interface ZWBarrageScene()

@property (nonatomic, strong) UIImageView *vipImageView;
@end

@implementation ZWBarrageScene

- (instancetype)initWithModel:(ZWBarrageModel *)model {
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame Model:(ZWBarrageModel *)model{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        self.model = model;
    }
    return self;
}

- (void)dealloc {
    //    NSLog(@"scene dealloc");
}

- (void)setupUI {
    // backImageView
    _backImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _backImageView.hidden = true;
    [self addSubview:_backImageView];
    // label
    _titleLabel = [[ZWEdgeInsetsLabel alloc] initWithFrame: self.bounds];
    _titleLabel.font = [UIFont systemFontOfSize:16.0];
    _titleLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
    _titleLabel.layer.borderColor = [UIColor blackColor].CGColor;
    _titleLabel.layer.borderWidth = 1.0;
    _titleLabel.layer.masksToBounds = YES;
    [self addSubview:_titleLabel];
    // button
    _voteButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 12)];
    _voteButton.hidden = true;
    _voteButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [_voteButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_voteButton setTitle:@"Vote" forState:UIControlStateNormal];
    
    [self addSubview:_voteButton];
    
    //imageView
    _imageView  = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.origin.x,self.bounds.origin.y, 28, 28)];
    _imageView.hidden = true;
    [self addSubview:_imageView];
}
// Add to SuperView and start scrolling
- (void)scroll {
    
    //calculate time of scroll barrage
    CGFloat distance = 0.0;
    CGPoint goalPoint = CGPointZero;
    switch (_model.direction) {
        case ZWBarrageScrollDirectRightToLeft:
            distance = CGRectGetWidth(_model.bindView.bounds);
            goalPoint = CGPointMake(-CGRectGetWidth(self.frame), CGRectGetMinY(self.frame));
            break;
        case ZWBarrageScrollDirectLeftToRight:
            distance = CGRectGetWidth(_model.bindView.bounds);
            goalPoint = CGPointMake(CGRectGetWidth(_model.bindView.bounds) + CGRectGetWidth(self.frame), CGRectGetMinY(self.frame));
            break;
        case ZWBarrageScrollDirectBottomToTop:
            distance = CGRectGetHeight(_model.bindView.bounds);
            goalPoint = CGPointMake(CGRectGetMinX(self.frame), -CGRectGetHeight(self.frame));
            break;
        case ZWBarrageScrollDirectTopToBottom:
            distance = CGRectGetHeight(_model.bindView.bounds);
            goalPoint = CGPointMake(CGRectGetMinX(self.frame), CGRectGetHeight(self.frame) + CGRectGetMaxY(_model.bindView.bounds));
            break;
        default:
            break;
    }
    NSTimeInterval time = distance / _model.speed;
    
    CGRect goalFrame = self.frame;
    goalFrame.origin = goalPoint;
    
    // Layer execution animation
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.delegate = self;
    animation.removedOnCompletion = NO;
    animation.autoreverses = false;
    animation.fillMode = kCAFillModeForwards;
    
    [animation setToValue:[NSValue valueWithCGPoint:CenterPoint(goalFrame)]];
    [animation setDuration:time];
    [self.layer addAnimation:animation forKey:@"kAnimation_BarrageScene"];
}

- (void)setModel:(ZWBarrageModel *)model {
    _model = model;
    [self calculateFrame];
}

- (void)pause {
    CFTimeInterval pausedTime = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    self.layer.speed = 0.0;
    self.layer.timeOffset = pausedTime;
}

- (void)resume {
    CFTimeInterval pausedTime = [self.layer timeOffset];
    self.layer.timeOffset = 0.0;
    self.layer.beginTime = 0.0;
    self.layer.speed = 1.0;
    CFTimeInterval timeSincePause = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    self.layer.beginTime = timeSincePause;
}

- (void)close {
    [self.layer removeAllAnimations];
    [self removeFromSuperview];
}

#pragma mark - Frame
- (void)calculateFrame {
    /* 1. setup UI  */
    _titleLabel.attributedText = _model.message;
    
    /* 2. determine barrage's type  */
    switch (_model.barrageType) {
        case ZWBarrageDisplayTypeVote:
            // - voting type -
            _imageView.hidden = YES;
            [_titleLabel sizeToFit];
            _voteButton.hidden = false;
            [_voteButton sizeToFit];
            CGRect frame = _voteButton.frame;
            frame.origin.x = CGRectGetMaxX(_titleLabel.frame) + 5;
            frame.origin.y = CGRectGetMinY(_titleLabel.frame);
            frame.size.height = CGRectGetHeight(_titleLabel.frame);
            _voteButton.frame = frame;
            self.bounds = CGRectMake(0, 0, CGRectGetWidth(_titleLabel.frame) + CGRectGetWidth(_voteButton.frame), CGRectGetHeight(_titleLabel.frame));
            
            break;
        case ZWBarrageDisplayTypeImage:
            
            _voteButton.hidden = YES;
            /* text and image */
            if (_model.object !=nil) {
                UIImage *img = (UIImage *)_model.object;
                _imageView.image = img;
            }
            
            
            [_imageView.layer setMasksToBounds:YES];
            _imageView.layer.cornerRadius = 15;
            
            _imageView.hidden = false;
            [_imageView sizeToFit];
            
            CGRect imageframe = _imageView.frame;
            imageframe.size.width  = _model.ZW_hight > 0?_model.ZW_hight:30.0;
            imageframe.size.height = _model.ZW_hight > 0?_model.ZW_hight:30.0;
            
            _imageView.frame = imageframe;
            
            [_titleLabel sizeToFit];
            CGRect titleLabelframe = _titleLabel.frame;
            titleLabelframe.origin.x = CGRectGetMaxX(_imageView.frame) + 5;
            titleLabelframe.origin.y = CGRectGetMinY(_imageView.frame) + (_imageView.frame.size.height - titleLabelframe.size.height)/2;
            _titleLabel.frame = titleLabelframe;
            
            self.bounds = CGRectMake(0, 0, CGRectGetWidth(_imageView.frame) + CGRectGetWidth(_titleLabel.frame), CGRectGetHeight(_imageView.frame));
            
            break;
            
        case ZWBarrageDisplayTypeCustomView:
        {
            _voteButton.hidden = YES;
            /* text and image */
            if (_model.object !=nil) {
                UIImage *img = (UIImage *)_model.object;
                _imageView.image = img;
            }
            
            
            _imageView.hidden = false;
            [_imageView sizeToFit];
            
            CGRect imageframe = _imageView.frame;
            imageframe.size.width  = _model.ZW_hight > 0?_model.ZW_hight:30.0;
            imageframe.size.height = _model.ZW_hight > 0?_model.ZW_hight:30.0;
            
            _imageView.frame = imageframe;
            
            [_titleLabel sizeToFit];
            CGRect titleLabelframe = _titleLabel.frame;
            titleLabelframe.origin.x = CGRectGetMaxX(_imageView.frame) + 5;
            titleLabelframe.origin.y = CGRectGetMinY(_imageView.frame) + (_imageView.frame.size.height - titleLabelframe.size.height)/2;
            _titleLabel.frame = titleLabelframe;
            
            _imageView.clipsToBounds = YES;
            _imageView.layer.cornerRadius = 15;
            
            if (_model.barrageUser.userId > 0) {
                
                _vipImageView = [[UIImageView alloc] init];
                _vipImageView.frame = CGRectMake(20, 20, 12, 12);
                NSString *vImgStr = [NSString new];
                vImgStr = @"ic_small";
                if (_model.barrageUser.vip > 0) {
                    _vipImageView.hidden = NO;
                    
                    if (_model.barrageUser.vipFrom == 0) {
                        
                        vImgStr = [vImgStr stringByAppendingString:@"_red"];
                    }else if (_model.barrageUser.vipFrom == 1){
                        
                        vImgStr = [vImgStr stringByAppendingString:@"_blue"];
                    }
                    _vipImageView.image = [UIImage imageNamed:vImgStr];
                }else{
                    _vipImageView.hidden = YES;
                }
                
                [self addSubview:_vipImageView];
                
            }
            
            self.bounds = CGRectMake(0, 0, CGRectGetWidth(_imageView.frame) + CGRectGetWidth(_titleLabel.frame), CGRectGetHeight(_imageView.frame));
            
        }
            break;
            
        case ZWBarrageDisplayTypeOther:
            // - other types -
            _voteButton.hidden = true;
            _imageView.hidden = true;
            [_titleLabel sizeToFit];
            self.bounds = _titleLabel.bounds;
            
            break;
        case ZWBarrageDisplayTypeBackImageView:
            _voteButton.hidden = true;
            _imageView.hidden = true;
            _backImageView.hidden = false;
            if (_model.backImage !=nil) {
                UIImage *img = (UIImage *)_model.backImage;
                _backImageView.image = [img stretchableImageWithLeftCapWidth:45 topCapHeight:0.01];
            }
            _titleLabel.edgeInsets = UIEdgeInsetsMake(5, 54, 5, 54);
            [_titleLabel sizeToFit];
            _titleLabel.layer.cornerRadius = 13;
            _titleLabel.backgroundColor = [UIColor clearColor];
            _titleLabel.layer.borderColor = [UIColor clearColor].CGColor;
            _titleLabel.layer.borderWidth = 0.0;
            _titleLabel.layer.masksToBounds = YES;
            self.bounds = _titleLabel.bounds;
            break;
        default:
            // --BarrageDisplayTypeDefault--        // TODO:  可设置圆角之类的
            _voteButton.hidden = true;
            _imageView.hidden = true;
            _titleLabel.edgeInsets = UIEdgeInsetsMake(6, 18, 6, 18);
            [_titleLabel sizeToFit];
            _titleLabel.layer.cornerRadius = _titleLabel.frame.size.height * 0.5;
            self.bounds = _titleLabel.bounds;
            
            break;
    }
    
    //Calculate a barrage of random position
    self.frame = [self calculateBarrageSceneFrameWithModel:_model];
    _backImageView.frame = self.bounds;
}

//MARK: The calculation of random barrage Frame
-(CGRect) calculateBarrageSceneFrameWithModel:(ZWBarrageModel *)model {
    CGPoint originPoint;
    CGRect sourceFrame = CGRectZero;
    switch (model.displayLocation) {
        case ZWBarrageDisplayLocationTypeDefault:
            sourceFrame = model.bindView.bounds;
            break;
        case ZWBarrageDisplayLocationTypeTop:
            sourceFrame = CGRectMake(0, 0, CGRectGetWidth(model.bindView.bounds), CGRectGetHeight(model.bindView.bounds)/3.0);
            break;
        case ZWBarrageDisplayLocationTypeCenter:
            sourceFrame = CGRectMake(0, CGRectGetHeight(model.bindView.bounds)/3.0, CGRectGetWidth(model.bindView.bounds), CGRectGetHeight(model.bindView.bounds)/3.0);
            break;
        case ZWBarrageDisplayLocationTypeBottom:
            sourceFrame = CGRectMake(0, CGRectGetHeight(model.bindView.bounds)/3.0* 2.0, CGRectGetWidth(model.bindView.bounds), CGRectGetHeight(model.bindView.bounds)/3.0);
            break;
        default:
            break;
    }
    // 随机 Y值
    float random = RandomBetween(CGRectGetMinY(sourceFrame), CGRectGetMaxY(sourceFrame) - CGRectGetHeight(self.bounds));
    if (random <= CGRectGetMinY(sourceFrame)) {
        random += 10;
    }
    // 获取上一个y值, 弹幕碰撞奥义: 取决于Y, 决定于X间距, 可利用弹幕刷新时间解决
    //    printf("4️⃣最后随机值: %f\n", random);
    
    // 各方向弹道
    switch (model.direction) {
        case ZWBarrageScrollDirectRightToLeft:
            originPoint = CGPointMake(CGRectGetMaxX(sourceFrame), random);
            break;
        case ZWBarrageScrollDirectLeftToRight:
            originPoint = CGPointMake(-CGRectGetWidth(self.bounds),random);
            break;
        case ZWBarrageScrollDirectBottomToTop:
            originPoint = CGPointMake(RandomBetween(0, CGRectGetWidth(sourceFrame)), CGRectGetMaxY(sourceFrame) + CGRectGetHeight(self.bounds));
            break;
        case ZWBarrageScrollDirectTopToBottom:
            originPoint = CGPointMake(RandomBetween(0, CGRectGetWidth(sourceFrame)), -CGRectGetHeight(self.bounds));
            break;
        default:
            break;
    }
    
    CGRect frame = self.frame;
    frame.origin = originPoint;
    
    return frame;
}

#pragma mark - AnimatonDelegate
// stop
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        __weak typeof(self) SELF = self;
        
        if (_animationDidStopBlock) {
            _animationDidStopBlock(SELF);
        }
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    if ([_voteButton pointInside:point withEvent:event]) {
        NSLog(@"_voteButton click~~~");
    }
    if ([_imageView pointInside:point withEvent:event]) {
        NSLog(@"_imageView click~~~");
    }
    return [super hitTest:point withEvent:event];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesBegan");
}

#pragma mark - 随机算法
// return a ` float ` Between `smallerNumber ` and ` largerNumber `
static float lastY = 0.0f;
static float deffer = 0.0f;
float RandomBetween(float smallerNumber, float largerNumber) {
    //Set the exact number of bits
    int precision = 100;
    //First get the difference between them.
    float subtraction = largerNumber - smallerNumber;
    
    //Absolute value
    subtraction = ABS(subtraction);
    //Multiplied by the number of bits
    subtraction *= precision;
    //Random between the difference
    float randomNumber = arc4random() % ((int)subtraction+1);
    //Random results divided by the number of bits of precision
    randomNumber /= precision;
    //Add a random value to a smaller value.
    float result = MIN(smallerNumber, largerNumber) + randomNumber;
    
    if (result < smallerNumber) {
        result = smallerNumber;
    }
    deffer = result - lastY;
    if (deffer != result) {
        //        printf("1️⃣绝对差值 %f \n", fabsf(result - lastY));
        if (fabsf(result - lastY) < 55.5) {
            //            printf("2️⃣上一次Y:%f \n, 这一次Y: %f \n", lastY, result);
            result = (lastY + 55.5) > largerNumber ? (lastY - 55.5) : (lastY + 55.5);
            //            printf("3️⃣处理结果随机值 == %f \n", result);
            lastY = result;
            return result;
        } else {
            lastY = result;
            // Return result
            return result;
        }
        
    } else {    // 第一次获取的随机数直接返回
        lastY = result;
        return result;
    }
}

//Return to the center of a Frame
CGPoint CenterPoint(CGRect rect) {
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

@end
