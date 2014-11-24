//
//  M7IdleSpaceFinder.h
//  chenms.m2.m7
//
//  Created by Chen Meisong on 14-11-6.
//  Copyright (c) 2014年 chenms.m2 All rights reserved.
//

#import <UIKit/UIKit.h>

@interface M7IdleSpaceFinder : NSObject
- (void)reloadDataWithContainerFrame:(CGRect)containerFrame
                        targetSize:(CGSize)targetSize
                      originCenter:(CGPoint)originCenter
                      beUsedFrames:(NSArray *)beUsedFrames;
- (CGRect)findIdleSpaceFrame;
@end
