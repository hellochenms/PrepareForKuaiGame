//
//  M7Item1ToNTabView.m
//  PrepareForKuaiGame
//
//  Created by Chen Meisong on 14/12/2.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import "M2Item1ToNTabView.h"

static const NSInteger kMaxVisibleItemCount = 4;
static const double kUnderLineViewHeight = 2.5;
static const double kUnderLineViewHorizontalMargin = 20;
static const NSInteger kItemTagOffset = 6000;
static const double kAnimationDuration = 0.15;

@interface M2Item1ToNTabView ()
@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) NSMutableArray *items;
@property (nonatomic) NSInteger visibleItemCount;
@property (nonatomic) double itemWidth;
@property (nonatomic) UIView *selectedUnderLineView;
@end

@implementation M2Item1ToNTabView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.scrollEnabled = NO;
        [self addSubview:_scrollView];
        
        //
        _items = [NSMutableArray array];
        
        //
        _selectedUnderLineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_scrollView.bounds) - kUnderLineViewHeight, 0, kUnderLineViewHeight)];
        _selectedUnderLineView.backgroundColor = [UIColor blueColor];
        [_scrollView addSubview:_selectedUnderLineView];
    }
    
    return self;
}

#pragma mark - 
- (void)reloadDataWithTitles:(NSArray *)titles {
    // clear old
    [self.items enumerateObjectsUsingBlock:^(UIView *item, NSUInteger idx, BOOL *stop) {
        [item removeFromSuperview];
    }];
    [self.items removeAllObjects];
    self.itemWidth = 0;
    self.scrollView.contentOffset = CGPointZero;
    self.scrollView.contentSize = self.scrollView.bounds.size;
    self.scrollView.scrollEnabled = NO;
    CGRect selectedUnderLineViewFrame = self.selectedUnderLineView.frame;
    selectedUnderLineViewFrame.origin.x = 0;
    selectedUnderLineViewFrame.size.width = 0;
    self.selectedUnderLineView.frame = selectedUnderLineViewFrame;
    
    // build new
    NSInteger count = [titles count];
    if (count == 0) {
        return;
    }
    // 4个item以内等分宽度
    if (count <= kMaxVisibleItemCount) {
        self.itemWidth = CGRectGetWidth(self.scrollView.bounds) / count;
        self.visibleItemCount = count;
    }
    // 超过4个item允许滑动
    else {
        self.scrollView.scrollEnabled = YES;
        self.itemWidth = CGRectGetWidth(self.scrollView.bounds) / 4;
        self.visibleItemCount = kMaxVisibleItemCount;
    }
    double itemHeight = CGRectGetHeight(self.scrollView.bounds);
    for (NSInteger i = 0; i < count; i++) {
        UIView *item = [self buildItemForIndex:i itemWidth:self.itemWidth itemHeight:itemHeight title:[titles objectAtIndex:i]];
        [self.items addObject:item];
        [self.scrollView addSubview:item];
    }
    self.scrollView.contentSize = CGSizeMake(self.itemWidth * count, itemHeight);
    
    [self.scrollView bringSubviewToFront:self.selectedUnderLineView];
    CGRect underLineViewFrame = self.selectedUnderLineView.frame;
    underLineViewFrame.size.width = self.itemWidth - kUnderLineViewHorizontalMargin * 2;
    underLineViewFrame.origin.x = kUnderLineViewHorizontalMargin;
    self.selectedUnderLineView.frame = underLineViewFrame;
}

#pragma mark -
- (UIView *)buildItemForIndex:(NSInteger)index
                    itemWidth:(double)itemWidth
                   itemHeight:(double)itemHeight
                        title:(NSString *)title {
    UIButton *item = [UIButton buttonWithType:UIButtonTypeCustom];
    item.tag = index + kItemTagOffset;
    item.frame = CGRectMake(itemWidth * index, 0, itemWidth, itemHeight);
    item.titleLabel.font = [UIFont systemFontOfSize:15];
    [item setTitleColor:[UIColor colorWithRed:0x33 green:0x33 blue:0x33 alpha:1.0] forState:UIControlStateNormal];
    [item setTitle:title forState:UIControlStateNormal];
    [item addTarget:self action:@selector(onTapItem:) forControlEvents:UIControlEventTouchUpInside];
    
    return item;
}

#pragma mark -
- (void)onTapItem:(UIView *)sender {
    NSInteger index = sender.tag - kItemTagOffset;
    //
    [self adjustUnderLineViewOffsetForIndex:index animated:YES];
    
    //
    if (self.tapTabItemHandler) {
        self.tapTabItemHandler(index);
    }
}

- (void)adjustUnderLineViewOffsetForIndex:(NSInteger)index animated:(BOOL)animated {
    __weak typeof(self) weakSelf = self;
    if (animated) {
        [UIView animateWithDuration:kAnimationDuration
                         animations:^{
                             CGRect underLineViewFrame = weakSelf.selectedUnderLineView.frame;
                             underLineViewFrame.origin.x = weakSelf.itemWidth * index + kUnderLineViewHorizontalMargin;
                             weakSelf.selectedUnderLineView.frame = underLineViewFrame;
                         }];
    } else {
        CGRect underLineViewFrame = self.selectedUnderLineView.frame;
        underLineViewFrame.origin.x = self.itemWidth * index + kUnderLineViewHorizontalMargin;
        self.selectedUnderLineView.frame = underLineViewFrame;
    }
}

#pragma mark - public
- (void)selectIndex:(NSInteger)index {
    [self adjustUnderLineViewOffsetForIndex:index animated:NO];
    NSInteger shouldOffsetIndex = index;
    NSInteger maxOffsetIndex = [self.items count] - self.visibleItemCount;
    if (shouldOffsetIndex > maxOffsetIndex) {
        shouldOffsetIndex = maxOffsetIndex;
    }
    [self.scrollView setContentOffset:CGPointMake(self.itemWidth * shouldOffsetIndex, 0) animated:YES];
}

@end
