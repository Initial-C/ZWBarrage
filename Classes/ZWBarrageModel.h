//
//  ZWBarrageModel.h
//  ZWBarrage
//
//  Created by InitialC on 16/12/5.
//  Copyright © 2016年 William Chang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ZWBarrageEnum.h"
#import "ZWBarrageUserModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface ZWBarrageModel : NSObject

//MARK: Model

// barrage's id
@property (assign, nonatomic) NSInteger numberID;

//  barrage's time
@property (strong, nonatomic) NSString *time;

// barrage's type
@property (assign, nonatomic) ZWBarrageDisplayType barrageType;

// barrage's speed
@property (assign, nonatomic) ZWBarrageDisplaySpeedType speed;

// barrage's direction
@property (assign, nonatomic) ZWBarrageScrollDirection direction;

// barage's location
@property (assign, nonatomic) ZWBarrageDisplayLocationType displayLocation;

//  barrage's superView
@property (weak, nonatomic) UIView *bindView;

// barrage's content
@property (strong, nonatomic, nonnull) NSMutableAttributedString *message;

// barrage's author
@property (strong, nonatomic, nullable) id author;

// barrage's user
@property (strong, nonatomic) ZWBarrageUserModel *barrageUser;

// goal object
@property (strong, nonatomic, nullable) id object;

//ZWBarrageDisplayTypeImage and ZWBarrageDisplayTypeVote need to set height
@property (assign, nonatomic) float ZW_hight;


// barrage's textfont
@property (copy, nonatomic) UIFont *font;

// barrage's textColor
@property (copy, nonatomic) UIColor *textColor;

//MARK: Barrage initialization method

/**
 init  ZWBarrageModel
 
 @param numID barrage's id
 @param message barrage's content
 @param author barrage's author
 @param object goal object
 @return init  ZWBarrageModel
 */
- (instancetype)initWithNumberID:(NSInteger)numID BarrageContent:(NSMutableAttributedString *)message Author:(nullable id)author Object:(nullable id)object;
/**
 init  ZWBarrageModel
 
 @param numID barrage's id
 @param message barrage's content
 @return init  ZWBarrageModel
 */
- (instancetype)initWithNumberID:(NSInteger)numID BarrageContent:(NSMutableAttributedString *)message;

/**
 init  ZWBarrageModel
 
 @param message barrage's content
 @return init  ZWBarrageModel
 */
- (instancetype)initWithBarrageContent:(NSMutableAttributedString *)message;


@end

NS_ASSUME_NONNULL_END
