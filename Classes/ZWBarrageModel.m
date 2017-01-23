//
//  ZWBarrageModel.m
//  ZWBarrage
//
//  Created by InitialC on 16/12/5.
//  Copyright © 2016年 William Chang. All rights reserved.
//

#import "ZWBarrageModel.h"

@implementation ZWBarrageModel

#pragma mark - initialize

- (instancetype)init {
    if (self = [super init]) {
        self.numberID = 0;
        self.message = [[NSMutableAttributedString alloc] initWithString:@""];
        self.author = nil;
        self.object = nil;
        self.backImage = nil;
    }
    return self;
}

- (instancetype)initWithNumberID:(NSInteger)numID BarrageContent:(NSMutableAttributedString *)message Author:(nullable id)author Object:(nullable id)object BackImage:(nullable id)image {
    ZWBarrageModel *model = [[ZWBarrageModel alloc] init];
    if (numID == nil) {
        numID = 0;
    }
    model.numberID = numID;
    model.message = message;
    model.author = author;
    model.object = object;
    model.backImage = image;
    return model;
}

- (instancetype)initWithNumberID:(NSInteger)numID BarrageContent:(NSMutableAttributedString *)message {
    return [self initWithNumberID:numID BarrageContent:message Author:nil Object:nil BackImage:nil];
}

- (instancetype)initWithBarrageContent:(NSMutableAttributedString *)message {
    return [self initWithNumberID:0 BarrageContent:message];
}

@end
