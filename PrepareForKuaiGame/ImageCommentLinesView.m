//
//  ImageCommentLinesView.m
//  PrepareForKuaiGame
//
//  Created by Chen Meisong on 14-11-5.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import "ImageCommentLinesView.h"

@interface ImageCommentLinesView ()
@end

@implementation ImageCommentLinesView
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;
        self.scale = 1;
        self.layer.shouldRasterize = YES;
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextSetLineWidth(context, 1 * self.scale);
    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
    CGContextBeginPath(context);
    [self.Lines enumerateObjectsUsingBlock:^(NSArray *points, NSUInteger idx, BOOL *stop) {
        if ([points count] == 2) {
            // 画线
            CGContextBeginPath(context);
            [points enumerateObjectsUsingBlock:^(NSValue *pointValue, NSUInteger idx, BOOL *stop) {
                CGPoint point = [pointValue CGPointValue];
                if (idx == 0) {
                    CGContextMoveToPoint(context, point.x, point.y);
                } else {
                    CGContextAddLineToPoint(context, point.x, point.y);
                }
            }];
            CGContextStrokePath(context);
            
            // 画圆点
            CGContextBeginPath(context);
            CGPoint point = [[points firstObject] CGPointValue];
            CGContextAddArc(context, point.x, point.y, 2 * self.scale, 0, M_PI * 2, 0);
            CGContextStrokePath(context);
        }
    }];
    
    CGContextRestoreGState(context);
}

@end
