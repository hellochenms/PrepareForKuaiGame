//
//  M7Item1ToNTabView.h
//  chenms.m2.m7
//
//  Created by Chen Meisong on 14/12/2.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface M2Item1ToNTabView : UIView
@property (nonatomic, copy) void (^tapTabItemHandler)(NSInteger selectedIndex);
- (void)reloadDataWithTitles:(NSArray *)titles;
- (void)selectIndex:(NSInteger)index;
@end
