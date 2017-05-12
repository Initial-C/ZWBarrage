//
//  ZWAVPlayer.h
//  Pods
//
//  Created by InitialC on 2017/5/12.
//
//

#import <UIKit/UIKit.h>

@interface ZWAVPlayer : UIView

@property (nonatomic, strong) NSURL *pathOrUrl;
- (instancetype)initWithFrame:(CGRect)frame withPlayerURL: (NSURL *)url;
- (void)setDeinit;

@end
