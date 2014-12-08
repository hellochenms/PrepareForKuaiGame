//
//  M2BadgeView.h
//  chenms.m2
//
//  Created by Chen Meisong on 14/12/8.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface M2BadgeView : UIView
@property (nonatomic, readonly) UILabel *label;
@property (nonatomic, copy) void (^onBadageFrameDidChanged)(M2BadgeView *sender);
- (instancetype)initWithTextFont:(UIFont *)textFont;
- (instancetype)initWithTextFont:(UIFont *)textFont textEdgeInsets:(UIEdgeInsets)textEdgeInsets;
- (void)reloadData:(NSString *)text;
@end
