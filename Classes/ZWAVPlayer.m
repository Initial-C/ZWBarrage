//
//  ZWAVPlayer.m
//  Pods
//
//  Created by InitialC on 2017/5/12.
//
//

#import "ZWAVPlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface ZWAVPlayer()

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) AVPlayerItem *getPlayItem;

@end

@implementation ZWAVPlayer

- (instancetype)initWithFrame:(CGRect)frame withPlayerURL:(NSURL *)url {
    if (self == [super initWithFrame:frame]) {
        if (url != nil) {
            self.pathOrUrl = url;
        }
        [self setupPlayer];
        [self addNotification];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.playerLayer.frame = self.bounds;
}
- (void)setupPlayer {
    self.backgroundColor = [UIColor clearColor];
    self.player = [[AVPlayer alloc] initWithPlayerItem:self.getPlayItem];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.layer addSublayer:self.playerLayer];
    [self.player play];
}
- (AVPlayerItem *)getPlayItem {
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:self.pathOrUrl];
    return playerItem;
}

-(NSString *)timeToStringWithTimeInterval:(NSTimeInterval)interval;
{
    NSInteger Min = interval / 60;
    NSInteger Sec = (NSInteger)interval % 60;
    NSString *intervalString = [NSString stringWithFormat:@"%02ld:%02ld",Min,Sec];
    return intervalString;
}

- (void)addNotification {
    // 循环播放
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlaybackComplete) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];//视频播放结束
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlaybackStart) name:AVPlayerItemTimeJumpedNotification object:nil];//播放开始
}
- (void)moviePlaybackComplete {
    [self.player seekToTime:CMTimeMake(0, 1)];
    [self.player play];
}
- (void)moviePlaybackStart {
    NSLog(@"播放开始");
}
- (void)setDeinit {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.player = nil;
}

@end
