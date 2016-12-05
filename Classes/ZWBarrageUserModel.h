//
//  ZWBarrageUserModel.h
//  ZWBarrage
//
//  Created by InitialC on 16/12/5.
//  Copyright © 2016年 William Chang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZWBarrageUserModel : NSObject

@property (nonatomic,assign)   long userId;
@property (nonatomic,copy)     NSString *name;
@property (nonatomic,strong)   NSString *txt;
@property (nonatomic,copy)     NSString *url;
@property (nonatomic,assign)   int vip;
@property (nonatomic,assign)   int vipFrom;


@end
