//
//  ZWBarrageManager.m
//  ZWBarrage
//
//  Created by InitialC on 16/12/5.
//  Copyright © 2016年 William Chang. All rights reserved.
//

#import "ZWBarrageManager.h"
#define Weakself __weak typeof(self) weakSelf = self


@interface ZWBarrageManager ()

@property (assign, nonatomic) ZWBarrageStatusType currentStatus;

@property (strong, nonatomic) NSMutableArray *cachePool;

@property (strong, nonatomic) NSMutableArray *barrageScene;

@property (strong, nonatomic) NSTimer *timer;

@end

@implementation ZWBarrageManager

#pragma mark - create manager

// singleton
static ZWBarrageManager *instance;

+ (instancetype)shareManager {
    if (!instance) {
        instance = [[ZWBarrageManager alloc] init];
    }
    return instance;
}

+ (instancetype)manager {
    return [[ZWBarrageManager alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _scrollSpeed = ZWBarrageDisplaySpeedTypeDefault;
        _displayLocation = ZWBarrageDisplayLocationTypeDefault;
        _cachePool = [NSMutableArray array];
        _barrageScene = [NSMutableArray array];
    }
    return self;
}

- (void)dealloc {
    if ([_timer isValid]){
        [_timer invalidate];
        _timer = nil;
    }
    
    if (_cachePool.count > 0) {
        [_cachePool removeAllObjects];
    }
    
    if (_barrageScene.count > 0) {
        [_barrageScene removeAllObjects];
    }
    
    NSLog(@"BarrageManager dealloc~");
}

- (NSMutableArray *)barrageCache {
    return _cachePool;
}

- (NSMutableArray<ZWBarrageScene *> *)barrageScenes {
    return _barrageScene;
}

- (void)setRefreshInterval:(NSTimeInterval)refreshInterval {
    _refreshInterval = refreshInterval;
    _timer = [NSTimer scheduledTimerWithTimeInterval:_refreshInterval target:self selector:@selector(buildBarrageScene) userInfo:nil repeats:true];
    [_timer setFireDate:[NSDate distantFuture]];
}

#pragma mark - method

- (void)buildBarrageScene {
    /* build barrage model */
    if (![_delegate  respondsToSelector:@selector(barrageManagerDataSource)]) {
        return;
    }
    id data = [_delegate barrageManagerDataSource];
    if (!data) {
        return;
    }
    [self showWithData:data];
}

- (void)showBarrageWithDataSource:(id)data {
    if (!data) {
        return;
    }
    [self showWithData:data];
}

- (void)showWithData:(id)data {
    /*
     1. determine receiver's type
     2. determine build a new scene OR Taken from the buffer pool inside
     */
    _currentStatus = ZWBarrageStatusTypeNormal;
    @autoreleasepool {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([data isKindOfClass:[ZWBarrageModel class]]) {
                //only a ZWBarrageModel
                ZWBarrageModel *model = data;
                model = [self sync_BarrageManagerConfigure:model];
                //Check whether the buffer pool is empty.
                if (_cachePool.count < 1) {
                    // nil
                    ZWBarrageScene *scene = [[ZWBarrageScene alloc] initWithFrame:CGRectZero Model:model];
                    [_barrageScene addObject:scene];
                    [_bindingView addSubview:scene];
                    Weakself;
                    scene.animationDidStopBlock = ^(ZWBarrageScene *scene_){
                        [weakSelf.cachePool addObject:scene_];
                        [weakSelf.barrageScene removeObject:scene_];
                        [scene_ removeFromSuperview];
                    };
                    [scene scroll];
                    
                }else {
                    //From the buffer pool to Scene, it will be removed from the buffer pool
                    //                    NSLog(@"get from cache");
                    ZWBarrageScene *scene =  _cachePool.firstObject;
                    [_barrageScene addObject:scene];
                    [_cachePool removeObjectAtIndex:0];
                    scene.model = model;
                    
                    [_bindingView addSubview:scene];
                    [scene scroll];
                }
            }else {
                // more than one barrage
                NSArray <ZWBarrageModel *> *modelArray = data;
                [modelArray enumerateObjectsUsingBlock:^(ZWBarrageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    ZWBarrageModel *model = [self sync_BarrageManagerConfigure:obj];
                    //Check whether the buffer pool is empty.
                    if (_cachePool.count < 1) {
                        // nil
                        ZWBarrageScene *scene = [[ZWBarrageScene alloc] initWithFrame:CGRectZero Model:model];
                        [_barrageScene addObject:scene];
                        [_bindingView addSubview:scene];
                        Weakself;
                        scene.animationDidStopBlock = ^(ZWBarrageScene *scene_){
                            [weakSelf.cachePool addObject:scene_];
                            [weakSelf.barrageScene removeObject:scene_];
                            [scene_ removeFromSuperview];
                        };
                        [scene scroll];
                        
                    }else {
                        //From the buffer pool to Scene, it will be removed from the buffer pool
                        
                        ZWBarrageScene *scene =  _cachePool.firstObject;
                        [_barrageScene addObject:scene];
                        [_cachePool removeObjectAtIndex:0];
                        scene.model = model;
                        
                        [_bindingView addSubview:scene];
                        [scene scroll];
                    }
                }];
            }
        });
    }
}

-(ZWBarrageModel *) sync_BarrageManagerConfigure:(ZWBarrageModel *)model {
    model.speed = _scrollSpeed;
    model.direction = _scrollDirection;
    model.bindView = _bindingView;
    return model;
}

#pragma mark - Barrage Scroll / Pause / Cloese

- (void)startScroll {
    [_timer setFireDate:[NSDate date]];
}
- (void)resumeScroll {
    if (_currentStatus == ZWBarrageStatusTypePause) {
        //The current barrage on the screen to start rolling, and to obtain a new barrage
        [_timer setFireDate:[NSDate date]];
        [self.barrageScenes enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ZWBarrageScene *scene = obj;
            [scene resume];
        }];
        _currentStatus = ZWBarrageStatusTypeNormal;
    } else {
        [self startScroll];
    }
}
- (void)pauseScroll {
    if (_currentStatus == ZWBarrageStatusTypeClose) {
        [self startScroll];
        return;
    }
    if (_currentStatus == ZWBarrageStatusTypeNormal) {
        //On the screen the barrage is suspended, and stop acquiring new barrage
        [_timer setFireDate:[NSDate distantFuture]];
        
        [self.barrageScenes enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ZWBarrageScene *scene = obj;
            [scene pause];
        }];
        _currentStatus = ZWBarrageStatusTypePause;
    }else if (_currentStatus == ZWBarrageStatusTypePause) {
        //The current barrage on the screen to start rolling, and to obtain a new barrage
        [_timer setFireDate:[NSDate date]];
        [self.barrageScenes enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ZWBarrageScene *scene = obj;
            [scene resume];
        }];
        _currentStatus = ZWBarrageStatusTypeNormal;
    }
}

- (void)closeBarrage {
    if (_currentStatus == ZWBarrageStatusTypeNormal || _currentStatus == ZWBarrageStatusTypePause)  {
        _currentStatus = ZWBarrageStatusTypeClose;
        // On the screen the current barrage delete, and stop acquiring new barrage
        [_timer setFireDate:[NSDate distantFuture]];
        
        [self.barrageScenes enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ZWBarrageScene *scene = obj;
            [scene close];
        }];
    }
    //    }else if (_currentStatus == ZWBarrageStatusTypeClose || _currentStatus == ZWBarrageStatusTypePause) {
    //        _currentStatus = ZWBarrageStatusTypeNormal;
    //        [_timer setFireDate:[NSDate date]];
    //    }
}

- (void)toDealloc {
    
    if ([_timer isValid]){
        [_timer invalidate];
        _timer = nil;
    }
    
    if (_cachePool.count > 0) {
        [_cachePool removeAllObjects];
    }
    
    if (_barrageScene.count > 0) {
        [_barrageScene removeAllObjects];
    }
    
}

- (void)didReceiveMemoryWarning {
    switch (_memoryMode) {
        case ZWBarrageMemoryWarningModeHalf:
            [self cleanHalfCache];
            break;
        case ZWBarrageMemoryWarningModeAll:
            [self cleanAllCache];
            break;
        default:
            break;
    }
}

- (void)cleanHalfCache {
    NSRange range = NSMakeRange(0, _cachePool.count / 2);
    [_cachePool removeObjectsInRange:range];
}

- (void)cleanAllCache {
    [_cachePool removeAllObjects];
}



@end
