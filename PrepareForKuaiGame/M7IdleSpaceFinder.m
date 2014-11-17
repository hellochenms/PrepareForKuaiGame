//
//  M7IdleSpaceFinder.m
//  PrepareForKuaiGame
//
//  Created by Chen Meisong on 14-11-5.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import "M7IdleSpaceFinder.h"

typedef enum {
    M7ISF_DirectionEnumUnknown = 4000,
    M7ISF_DirectionEnumUp,
    M7ISF_DirectionEnumDown,
    M7ISF_DirectionEnumLeft,
    M7ISF_DirectionEnumRight,
} M7ISF_DirectionEnum;

static const NSInteger kM7ISF_Step = 5;

@interface M7IdleSpaceFinder ()
// from args
@property (nonatomic) CGRect    containerFrame;
@property (nonatomic) CGSize    targetSize;
@property (nonatomic) CGPoint   originCenter;
@property (nonatomic) NSArray   *beUsedFrames;
// private fields
@property (nonatomic) BOOL      isFindIdelSpace;
@property (nonatomic) NSMutableDictionary *outOfContainerBoundsDict;
@property (nonatomic) CGRect    lightedFrame;
@property (nonatomic) CGPoint   curCenter;
@property (nonatomic) CGPoint   idleSpaceCenter;
@end

@implementation M7IdleSpaceFinder

- (void)reloadDataWithContainerFrame:(CGRect)containerFrame
                        targetSize:(CGSize)targetSize
                      originCenter:(CGPoint)originCenter
                      beUsedFrames:(NSArray *)beUsedFrames {
    self.containerFrame = containerFrame;
    self.targetSize = targetSize;
    self.originCenter = originCenter;
    self.beUsedFrames = beUsedFrames;
}


- (void)reset {
    self.isFindIdelSpace = NO;
    self.lightedFrame = CGRectMake(self.originCenter.x, self.originCenter.y, 0, 0);
    self.outOfContainerBoundsDict = [NSMutableDictionary dictionary];
    self.curCenter = self.originCenter;
    self.idleSpaceCenter = CGPointZero;
}

#pragma mark - public
// 若未找到，返回CGPointZero
- (CGRect)findIdleSpaceFrame{
    [self reset];
    
    M7ISF_DirectionEnum curDirection = M7ISF_DirectionEnumUnknown;
    M7ISF_DirectionEnum nextDirection = M7ISF_DirectionEnumDown;
    
    while ((!self.isFindIdelSpace && [self.outOfContainerBoundsDict count] < 4)
           || nextDirection == M7ISF_DirectionEnumUnknown) {
        BOOL isOutOfContainerBounds = NO;
        [self walkToDirection:nextDirection isOutOfContainerBounds:&isOutOfContainerBounds];
        curDirection = nextDirection;
        nextDirection = [self nextDirectionForCurDirection:curDirection];
        if (isOutOfContainerBounds) {
            [self.outOfContainerBoundsDict setObject:@(YES) forKey:[NSString stringWithFormat:@"%d", curDirection]];
            [self adjustCurCerterWhenOutOfContainerBoundsForNextDirection:nextDirection];
        }
    }
    
    CGRect frame = CGRectZero;
    if (!CGPointEqualToPoint(CGPointZero, self.idleSpaceCenter)) {
        frame.size = self.targetSize;
        frame.origin.x = self.idleSpaceCenter.x - frame.size.width / 2;
        frame.origin.y = self.idleSpaceCenter.y - frame.size.height / 2;
    }
    
    return frame;
}

// 撞到一侧墙时，将点移到下个移动方向的已探索区域边界
- (void)adjustCurCerterWhenOutOfContainerBoundsForNextDirection:(M7ISF_DirectionEnum)nextDirection {
    switch (nextDirection) {
        case M7ISF_DirectionEnumDown:{
            self.curCenter = CGPointMake(CGRectGetMinX(self.lightedFrame), CGRectGetMaxY(self.lightedFrame));
            break;
        }
        case M7ISF_DirectionEnumRight:{
            self.curCenter = CGPointMake(CGRectGetMaxX(self.lightedFrame), CGRectGetMaxY(self.lightedFrame));
            break;
        }
        case M7ISF_DirectionEnumUp:{
            self.curCenter = CGPointMake(CGRectGetMaxX(self.lightedFrame), CGRectGetMinY(self.lightedFrame));
            break;
        }
        case M7ISF_DirectionEnumLeft:{
            self.curCenter = CGPointMake(CGRectGetMinX(self.lightedFrame), CGRectGetMinY(self.lightedFrame));
            break;
        }
        default:
            break;
    }
}

- (void)walkToDirection:(M7ISF_DirectionEnum)direction
                    isOutOfContainerBounds:(BOOL*)isOutOfContainerBounds {

    M7ISF_DirectionEnum nextDirection = [self nextDirectionForCurDirection:direction];
    CGPoint nextCenter = self.curCenter;
    BOOL isOutOfLightedBounds = NO;
    while (!*isOutOfContainerBounds && !isOutOfLightedBounds && !self.isFindIdelSpace) {
        nextCenter = [self stepForCurDirection:direction forCenter:self.curCenter isOutOfContainerBounds:isOutOfContainerBounds];
        CGRect frame = [self frameForCenter:nextCenter];
        if ([self isOutOfContainerBoundsForNextDirection:nextDirection forFrame:frame]) {
            *isOutOfContainerBounds = YES;
            break;
        }
       
        self.curCenter = nextCenter;
        
        __weak typeof(self) weakSelf = self;
        self.isFindIdelSpace = YES;
        if (frame.origin.x < 0
            || frame.origin.x > CGRectGetWidth(self.containerFrame)
            || frame.origin.y < 0
            || frame.origin.y > CGRectGetHeight(self.containerFrame)) {
            weakSelf.isFindIdelSpace = NO;
        }
        if (self.isFindIdelSpace) {
            [self.beUsedFrames enumerateObjectsUsingBlock:^(NSValue *value, NSUInteger idx, BOOL *stop) {
//                NSLog(@"frame(%@) value(%@)  %s", NSStringFromCGRect(frame), NSStringFromCGRect([value CGRectValue]), __func__);
                if (CGRectIntersectsRect(frame, [value CGRectValue])) {
                    weakSelf.isFindIdelSpace = NO;
                    *stop = YES;
                }
            }];
        }
        
        if (self.isFindIdelSpace) {
            self.idleSpaceCenter = weakSelf.curCenter;
        }
        
        isOutOfLightedBounds = [self isOutOfLightedBoundsForCenter:self.curCenter forDirection:direction];
    }
    
    return;
}

- (BOOL)isOutOfContainerBoundsForNextDirection:(M7ISF_DirectionEnum)direction forFrame:(CGRect)frame {
    BOOL isOutOfContainerBounds = NO;
    switch (direction) {
        case M7ISF_DirectionEnumDown:{
            isOutOfContainerBounds = (CGRectGetMaxY(frame) > CGRectGetHeight(self.containerFrame));
            break;
        }
        case M7ISF_DirectionEnumRight:{
            isOutOfContainerBounds = (CGRectGetMaxX(frame) > CGRectGetWidth(self.containerFrame));
            break;
        }
        case M7ISF_DirectionEnumUp:{
            isOutOfContainerBounds = (CGRectGetMinY(frame) < 0);
            break;
        }
        case M7ISF_DirectionEnumLeft:{
            isOutOfContainerBounds = (CGRectGetMinX(frame) < 0);
            break;
        }
        default:
            break;
    }
    
    return isOutOfContainerBounds;
}

- (BOOL)isOutOfLightedBoundsForCenter:(CGPoint)center
                         forDirection:(M7ISF_DirectionEnum)direction {
    BOOL isOutOfLightedBounds = NO;
    CGRect frame = self.lightedFrame;
    switch (direction) {
        case M7ISF_DirectionEnumDown:{
            if (center.y > CGRectGetMaxY(self.lightedFrame)) {
                isOutOfLightedBounds = YES;
                frame.size.height += kM7ISF_Step;
            }
            break;
        }
        case M7ISF_DirectionEnumRight:{
            if (center.x > CGRectGetMaxX(self.lightedFrame)) {
                isOutOfLightedBounds = YES;
                frame.size.width += kM7ISF_Step;
            }
            break;
        }
        case M7ISF_DirectionEnumUp:{
            if (center.y < CGRectGetMinY(self.lightedFrame)) {
                isOutOfLightedBounds = YES;
                frame.size.height += kM7ISF_Step;
                frame.origin.y -= kM7ISF_Step;
            }
            break;
        }
        case M7ISF_DirectionEnumLeft:{
            if (center.x < CGRectGetMinX(self.lightedFrame)) {
                isOutOfLightedBounds = YES;
                frame.size.width += kM7ISF_Step;
                frame.origin.x -= kM7ISF_Step;
            }
            break;
        }
        default:
            break;
    }
    self.lightedFrame = frame;
    
    return isOutOfLightedBounds;
}

- (CGPoint)stepForCurDirection:(M7ISF_DirectionEnum)direction
                     forCenter:(CGPoint)center
        isOutOfContainerBounds:(BOOL *)isOutOfContainerBounds {
    switch (direction) {
        case M7ISF_DirectionEnumDown:{
            center.y += kM7ISF_Step;
            break;
        }
        case M7ISF_DirectionEnumRight:{
            center.x += kM7ISF_Step;
            break;
        }
        case M7ISF_DirectionEnumUp:{
            center.y -= kM7ISF_Step;
            break;
        }
        case M7ISF_DirectionEnumLeft:{
            center.x -= kM7ISF_Step;
            break;
        }
        default:
            break;
    }
    
    return center;
}

- (CGRect)frameForCenter:(CGPoint)center {
    CGRect frame = CGRectZero;
    frame.size = self.targetSize;
    frame.origin.x = center.x - frame.size.width / 2;
    frame.origin.y = center.y - frame.size.height / 2;
    
    return frame;
}

- (M7ISF_DirectionEnum)nextDirectionForCurDirection:(M7ISF_DirectionEnum)curDirection {
    M7ISF_DirectionEnum nextDirection = M7ISF_DirectionEnumUnknown;
    switch (curDirection) {
        case M7ISF_DirectionEnumDown:{
            nextDirection = M7ISF_DirectionEnumRight;
            break;
        }
        case M7ISF_DirectionEnumRight:{
            nextDirection = M7ISF_DirectionEnumUp;
            break;
        }
        case M7ISF_DirectionEnumUp:{
            nextDirection = M7ISF_DirectionEnumLeft;
            break;
        }
        case M7ISF_DirectionEnumLeft:{
            nextDirection = M7ISF_DirectionEnumDown;
            break;
        }
        default:
            break;
    }
    
    return nextDirection;
}

@end
