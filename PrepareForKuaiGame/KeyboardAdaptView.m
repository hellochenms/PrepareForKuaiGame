//
//  KeyboardAdaptView.m
//  PrepareForKuaiGame
//
//  Created by Chen Meisong on 14/11/17.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import "KeyboardAdaptView.h"
#import "KeyboardAdaptUnFullScreenView.h"

@interface KeyboardAdaptView ()
@property (nonatomic) KeyboardAdaptUnFullScreenView *mainView;
@end

@implementation KeyboardAdaptView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blueColor];
        
        _mainView = [[KeyboardAdaptUnFullScreenView alloc] initWithFrame:CGRectZero];
        _mainView.backgroundColor = [UIColor redColor];
        [self addSubview:_mainView];
        
        [self adjustSubViewsLayout];
    }
    
    return self;
}

#pragma mark - 
- (void)adjustSubViewsLayout {
    CGRect mainViewFrame = self.bounds;
    mainViewFrame.origin.y = 100;
    mainViewFrame.size.height -= 250;
    self.mainView.frame = mainViewFrame;
    
    [self.mainView adjustSubViewsLayout];
}


@end
