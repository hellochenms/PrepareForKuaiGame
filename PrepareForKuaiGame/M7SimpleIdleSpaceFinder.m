//
//  M7SimpleIdleSpaceFinder.m
//  chenms.m2.m7
//
//  Created by Chen Meisong on 14-11-6.
//  Copyright (c) 2014年 chenms.m2 All rights reserved.
//

#import "M7SimpleIdleSpaceFinder.h"

static const double kM7SISF_StepHight = 5;

@interface M7SimpleIdleSpaceFinder ()
@end

@implementation M7SimpleIdleSpaceFinder

// 调整frame以避免越界
- (CGRect)modifyOutOfBoundsFrame:(CGRect)targetFrame
                  containerBounds:(CGRect)containerFrame{
    // 调整frame，使其不越界
    CGRect modifyOriginFrame = targetFrame;
    // 调整frame的水平位置
    if (CGRectGetMinX(modifyOriginFrame) < 0) {
        modifyOriginFrame.origin.x = 0;
    } else if (CGRectGetMaxX(modifyOriginFrame) > CGRectGetWidth(containerFrame)) {
        modifyOriginFrame.origin.x = CGRectGetWidth(containerFrame) - CGRectGetWidth(modifyOriginFrame);
    }
    // 调整frame的竖直位置
    if (CGRectGetMinY(modifyOriginFrame) < 0) {
        modifyOriginFrame.origin.y = 0;
    } else if (CGRectGetMaxY(modifyOriginFrame) > CGRectGetHeight(containerFrame)) {
        modifyOriginFrame.origin.y = CGRectGetHeight(containerFrame) - CGRectGetHeight(modifyOriginFrame);
    }
    
    return modifyOriginFrame;
}

// 检查frame是否与给定的frames相交
- (BOOL)checkIfIntersectTargetFrame:(CGRect)targetFrame
                       otherViews:(NSArray *)otherViews {
    __block BOOL isIntersect = NO;
    [otherViews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        CGRect frame = view.frame;
        if (CGRectIntersectsRect(targetFrame, frame)) {
            isIntersect = YES;
            *stop = YES;
        }
    }];
    
    return isIntersect;
};

// 寻找空闲位置
// 如果找不到空闲位置，会返回originFrame
- (CGRect)findIdleSpaceFrameForTargetFrame:(CGRect)targetFrame
                            containerFrame:(CGRect)containerFrame
                                otherViews:(NSArray *)otherViews {
    // 调整frame，使其不越界
    CGRect modifyOriginFrame = [self modifyOutOfBoundsFrame:targetFrame containerBounds:containerFrame];
    
    // 如果没有与之前的frame相交，直接返回调整越界后的frame
    __block BOOL isIntersect = NO;
    [otherViews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        CGRect frame = view.frame;
        if (CGRectIntersectsRect(modifyOriginFrame, frame)) {
            isIntersect = YES;
            *stop = YES;
        }
    }];
    if (!isIntersect) {
        return modifyOriginFrame;
    }
    
    // 有相交，则寻找空闲位置
    CGRect curFrame = modifyOriginFrame;
    
    // 上下方向交替寻找空闲位置；
    __block BOOL isFindSuccess = NO;
    BOOL isToUp = NO;
    NSInteger step = 1;
    BOOL isTopOutOfBounds = NO;
    BOOL isBottomOutOfBounds = NO;
    while (!isFindSuccess
           && (!isTopOutOfBounds || !isBottomOutOfBounds)) {
        if (isToUp) {
            curFrame.origin.y -= kM7SISF_StepHight * step;
            if ([self outOfTopBoundsForCurFrame:curFrame]) {
                isTopOutOfBounds = YES;
                step++;
                isToUp = !isToUp;
                continue;
            }
        } else {
            curFrame.origin.y += kM7SISF_StepHight * step;
            if ([self outOfBottomBoundsForCurFrame:curFrame containerFrame:containerFrame]) {
                isBottomOutOfBounds = YES;
                step++;
                isToUp = !isToUp;
                continue;
            }
        }
        // curFrame在合法区域内，则判断是否与其他frame重叠
        isFindSuccess = YES;
        [otherViews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
            CGRect frame = view.frame;
            if (CGRectIntersectsRect(curFrame, frame)) {
                isFindSuccess = NO;
                *stop = YES;
            }
        }];
        step++;
        isToUp = !isToUp;
    }
    
    // 寻找成功
    if (isFindSuccess) {
        // 随机化frame的水平位置，防止引线竖直显示造成的单调
//        NSInteger maxX = floor(CGRectGetWidth(containerFrame) - CGRectGetWidth(curFrame));
//        curFrame.origin.x = arc4random() % maxX;
        return curFrame;
    } else {
//        NSInteger maxX = floor(CGRectGetWidth(containerFrame) - CGRectGetWidth(modifyOriginFrame));
//        modifyOriginFrame.origin.x = arc4random() % maxX;
        return modifyOriginFrame;
    }
}

- (BOOL)outOfTopBoundsForCurFrame:(CGRect)curFrame {
    if (CGRectGetMinY(curFrame) < 0) {
        return YES;
    }
    return NO;
}

- (BOOL)outOfBottomBoundsForCurFrame:(CGRect)curFrame containerFrame:(CGRect)containerFrame{
    if (CGRectGetMaxY(curFrame) > CGRectGetHeight(containerFrame)) {
        return YES;
    }
    return NO;
}

@end
