//
//  M7SimpleIdleSpaceFinder.h
//  chenms.m2.m7
//
//  Created by Chen Meisong on 14-11-6.
//  Copyright (c) 2014年 chenms.m2 All rights reserved.
//

#import <Foundation/Foundation.h>

@interface M7SimpleIdleSpaceFinder : NSObject
- (CGRect)modifyOutOfBoundsFrame:(CGRect)targetFrame
                  containerBounds:(CGRect)containerFrame;
- (BOOL)checkIfIntersectTargetFrame:(CGRect)targetFrame
                         otherViews:(NSArray *)otherViews;
- (CGRect)findIdleSpaceFrameForTargetFrame:(CGRect)targetFrame
                            containerFrame:(CGRect)containerFrame
                                otherViews:(NSArray *)otherViews;
@end
