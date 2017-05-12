//
//  ZWBarrageManager.h
//  ZWBarrage
//
//  Created by InitialC on 16/12/5.
//  Copyright © 2016年 William Chang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "ZWBarrageModel.h"
#import "ZWBarrageScene.h"
#import "ZWAVPlayer.h"

NS_ASSUME_NONNULL_BEGIN


@protocol ZWBarrageManagerDelegate <NSObject>

// Data Sources of barrage, type can be ` NSArray <ZWBarrageModel *> ` or a ZWBarrageModel
- (id)barrageManagerDataSource;

@end

@interface ZWBarrageManager : NSObject

//  barrage's singleton
+ (instancetype)shareManager;

+ (instancetype)manager;

// Barrage pool, can be taken out from the next     barrage's cache
- (NSMutableArray <ZWBarrageScene *> *)barrageCache;

// Is displayed on the screen of the barrage
- (NSMutableArray <ZWBarrageScene *> *)barrageScenes;

// barrage's ViewController
@property (weak, nonatomic) id <ZWBarrageManagerDelegate> delegate;

// the view of show barrage
@property (weak, nonatomic) UIView *bindingView;

/**
 It must be assigned at the back of the bindingView
 */
@property (nonatomic, copy) NSURL *playerURL;

@property (assign, nonatomic) NSInteger scrollSpeed;

// get barrages on time,
@property (assign, nonatomic) NSTimeInterval refreshInterval;

@property (assign, nonatomic) NSInteger displayLocation;

@property (assign, nonatomic) NSInteger scrollDirection;

// Text limited length
@property (assign, nonatomic) NSInteger textLengthLimit;

// Clear policy for receiving memory warning
@property (assign, nonatomic) NSInteger memoryMode;

//Take the initiative to obtain barrage
- (void)startScroll;

//Passive receiving a barrage of data
/* data's type is ` ZWBarrageModel ` or ` NSArray <ZWBarrageModel *> `*/
- (void)showBarrageWithDataSource:(id)data;

// pause or resume barrage
- (void)pauseScroll;

// close barrage
- (void)closeBarrage;
// resume barrage
- (void)resumeScroll;
// Receive memory warning, can remove a barrage of buffer pool, the buffer pool can also remove half
- (void)didReceiveMemoryWarning;

// Prevent memory leaks
- (void)toDealloc;

- (void)toDeinitPlayer;

@end

NS_ASSUME_NONNULL_END
