//
//  M2BadgeView.m
//  chenms.m2
//
//  Created by Chen Meisong on 14/12/8.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import "M2BadgeView.h"

@interface M2BadgeView ()
@property (nonatomic) UIEdgeInsets textEdgeInsets;
@property (nonatomic) UILabel *label;
@end

@implementation M2BadgeView
- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithTextFont:[UIFont systemFontOfSize:10] textEdgeInsets:UIEdgeInsetsMake(2, 5, 2, 5)];
}

- (instancetype)initWithTextFont:(UIFont *)textFont {
    return [self initWithTextFont:textFont textEdgeInsets:UIEdgeInsetsMake(2, 5, 2, 5)];
}

- (instancetype)initWithTextFont:(UIFont *)textFont textEdgeInsets:(UIEdgeInsets)textEdgeInsets {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _textEdgeInsets = textEdgeInsets;
        
        self.backgroundColor = [UIColor redColor];
        self.layer.cornerRadius = [self cornerRadiusForSelf];
        
        _label = [UILabel new];
        _label.backgroundColor = [UIColor clearColor];
        _label.textColor = [UIColor whiteColor];
        _label.font = textFont;
        [self addSubview:_label];
    }
    
    return self;
}

#pragma mark - 
- (void)reloadData:(NSString *)text {
    self.label.text = text;
    
    CGSize textSize = [self sizeForText:self.label.text font:self.label.font];
    CGRect labelFrame = self.label.frame;
    labelFrame.origin.x = self.textEdgeInsets.left;
    labelFrame.origin.y = self.textEdgeInsets.top;
    labelFrame.size = textSize;
    self.label.frame = labelFrame;
    
    CGRect selfFrame = self.frame;
    selfFrame.size.width = self.textEdgeInsets.left + textSize.width + self.textEdgeInsets.right;
    selfFrame.size.height = self.textEdgeInsets.top + textSize.height + self.textEdgeInsets.bottom;
    self.frame = selfFrame;

    self.layer.cornerRadius = [self cornerRadiusForSelf];
    
    if (self.onBadageFrameDidChanged) {
        self.onBadageFrameDidChanged(self);
    }
}

#pragma mark - 
- (double)cornerRadiusForSelf {
    return MIN(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
}
- (CGSize)sizeForText:(NSString *)text font:(UIFont *)font {
    if (!text || !font) {
        return CGSizeZero;
    }
    NSDictionary *attributes = @{NSFontAttributeName: font};
    CGSize size = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                                     options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  attributes:attributes
                                     context:nil].size;
    
    return size;
}
@end
