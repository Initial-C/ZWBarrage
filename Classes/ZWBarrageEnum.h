//
//  ZWBarrageEnum.h
//  ZWBarrage
//
//  Created by InitialC on 16/12/5.
//  Copyright © 2016年 William Chang. All rights reserved.
//

#ifndef ZWBarrageEnum_h
#define ZWBarrageEnum_h

typedef NS_ENUM(NSInteger, ZWBarrageStatusType) {
    ZWBarrageStatusTypeNormal = 0,
    ZWBarrageStatusTypePause,
    ZWBarrageStatusTypeClose,
};

// scroll speed of barrage,in seconds
typedef NS_ENUM(NSInteger, ZWBarrageDisplaySpeedType) {
    ZWBarrageDisplaySpeedTypeDefault = 10,
    ZWBarrageDisplaySpeedTypeFast = 20,
    ZWBarrageDisplaySpeedTypeFaster = 40,
    ZWBarrageDisplaySpeedTypeMostFast = 60,
};

//  The direction of the rolling barrage
typedef NS_ENUM(NSInteger, ZWBarrageScrollDirection) {
    ZWBarrageScrollDirectRightToLeft = 0,     /*  <<<<<   */
    ZWBarrageScrollDirectLeftToRight = 1,     /*  >>>>>   */
    ZWBarrageScrollDirectBottomToTop = 2,     /*  ↑↑↑↑   */
    ZWBarrageScrollDirectTopToBottom = 3,     /*  ↓↓↓↓   */
};


// location of barrage, `default` is global page
typedef NS_ENUM(NSInteger, ZWBarrageDisplayLocationType) {
    ZWBarrageDisplayLocationTypeDefault = 0,
    ZWBarrageDisplayLocationTypeTop = 1,
    ZWBarrageDisplayLocationTypeCenter = 2,
    ZWBarrageDisplayLocationTypeBottom = 3,
    ZWBarrageDisplayLocationTypeHidden,
};

//  type of barrage
typedef NS_ENUM(NSInteger, ZWBarrageDisplayType) {
    ZWBarrageDisplayTypeDefault = 0,  /* only text  */
    ZWBarrageDisplayTypeVote,         /* text and vote */
    ZWBarrageDisplayTypeImage,        /* text and image */
    ZWBarrageDisplayTypeCustomView,   /* Custom View  */
    ZWBarrageDisplayTypeOther,        /* other        */
    ZWBarrageDisplayTypeBackImageView /* Back Image View */
};

// Clear policy for receiving memory warning
typedef NS_ENUM(NSInteger, ZWBarrageMemoryWarningMode) {
    ZWBarrageMemoryWarningModeHalf = 0,  //Clear hal
    ZWBarrageMemoryWarningModeAll,       //Clear ALL
};

#endif /* ZWBarrageEnum_h */
