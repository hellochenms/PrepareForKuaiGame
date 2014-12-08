//
//  BadgeView.m
//  PrepareForKuaiGame
//
//  Created by Chen Meisong on 14/12/8.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import "BadgeView.h"
#import "M2BadgeView.h"

@interface BadgeView ()
@property (nonatomic) M2BadgeView *rightTopBadge;
@property (nonatomic) M2BadgeView *leftBadge;
@property (nonatomic) M2BadgeView *rightBadge;
@end

@implementation BadgeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(10, 74, CGRectGetWidth(frame) - 10 * 2, 44);
        button.backgroundColor = [UIColor blueColor];
        [button setTitle:@"刷新文字" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onTapButton) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        //
        UILabel *rightTopBadgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(button.frame) + 30, 200, 30)];
        rightTopBadgeLabel.backgroundColor = [UIColor lightGrayColor];
        rightTopBadgeLabel.font = [UIFont systemFontOfSize:16];
        rightTopBadgeLabel.text = @"badge在右上角显示";
        [self addSubview:rightTopBadgeLabel];
        __weak UILabel *weakRightTopBadgeLabel = rightTopBadgeLabel;
        _rightTopBadge = [[M2BadgeView alloc] initWithTextFont:[UIFont systemFontOfSize:12]];
        _rightTopBadge.onBadageFrameDidChanged = ^(M2BadgeView *sender){
            sender.center = CGPointMake(CGRectGetMaxX(weakRightTopBadgeLabel.bounds), 0);
        };
        [rightTopBadgeLabel addSubview:_rightTopBadge];
        
        //
        UILabel *leftBadgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(rightTopBadgeLabel.frame) + 30, 200, 30)];
        leftBadgeLabel.backgroundColor = [UIColor lightGrayColor];
        leftBadgeLabel.font = [UIFont systemFontOfSize:16];
        leftBadgeLabel.text = @"badge靠左显示";
        [self addSubview:leftBadgeLabel];
        __weak UILabel *weakLeftBadgeLabel = leftBadgeLabel;
        _leftBadge = [[M2BadgeView alloc] initWithTextFont:[UIFont systemFontOfSize:12]];
        _leftBadge.onBadageFrameDidChanged = ^(M2BadgeView *sender){
            sender.center = CGPointMake(CGRectGetMidX(sender.bounds), CGRectGetMidY(weakLeftBadgeLabel.bounds));
        };
        [leftBadgeLabel addSubview:_leftBadge];
        
        //
        UILabel *rightBadgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(leftBadgeLabel.frame) + 30, 200, 30)];
        rightBadgeLabel.backgroundColor = [UIColor lightGrayColor];
        rightBadgeLabel.font = [UIFont systemFontOfSize:16];
        rightBadgeLabel.text = @"badge靠右显示";
        [self addSubview:rightBadgeLabel];
        __weak UILabel *weakRightBadgeLabel = rightBadgeLabel;
        _rightBadge = [[M2BadgeView alloc] initWithTextFont:[UIFont systemFontOfSize:12]];
        _rightBadge.onBadageFrameDidChanged = ^(M2BadgeView *sender){
            sender.center = CGPointMake(CGRectGetWidth(weakRightBadgeLabel.bounds) - CGRectGetMidX(sender.bounds), CGRectGetMidY(weakRightBadgeLabel.bounds));
        };
        [rightBadgeLabel addSubview:_rightBadge];
    }
    
    return self;
}

#pragma mark - 
- (void)onTapButton {
    NSInteger number = (arc4random() % 200);
    [self.rightTopBadge reloadData:[NSString stringWithFormat:@"%d", number]];
    [self.leftBadge reloadData:[NSString stringWithFormat:@"%d", number]];
    [self.rightBadge reloadData:[NSString stringWithFormat:@"%d", number]];
}

@end
