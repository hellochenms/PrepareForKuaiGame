//
//  ScrollItemsBrowser.m
//  PrepareForKuaiGame
//
//  Created by Chen Meisong on 14/11/27.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import "ScrollItemsBrowser.h"
#import "ScrollItem.h"

@interface ScrollItemsBrowser ()<UIScrollViewDelegate>
@property (nonatomic) NSMutableArray    *items;
@property (nonatomic) UIScrollView      *scrollView;
@property (nonatomic) UIImageView       *preCover;
@property (nonatomic) UIImageView       *nextCover;
@property (nonatomic) UIButton          *preButton;
@property (nonatomic) UIButton          *nextButton;
@end

@implementation ScrollItemsBrowser

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor lightGrayColor];
        
        _items = [NSMutableArray array];
        
        double itemHeight = floor(CGRectGetHeight(frame) / 3);
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, itemHeight, CGRectGetWidth(frame), itemHeight)];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.clipsToBounds = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
        
        _preCover = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), itemHeight)];
        _preCover.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
        [self addSubview:_preCover];
        
        _nextCover = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(frame) - itemHeight, CGRectGetWidth(frame), itemHeight)];
        _nextCover.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
        [self addSubview:_nextCover];
        
        _preButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _preButton.frame = CGRectMake(0, 0, CGRectGetWidth(frame), 44);
        _preButton.backgroundColor = [UIColor blueColor];
        [_preButton setTitle:@"pre" forState:UIControlStateNormal];
        [_preButton addTarget:self action:@selector(onTapPreButton) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_preButton];
        
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextButton.frame = CGRectMake(0, CGRectGetHeight(frame) - 44, CGRectGetWidth(frame), 44);
        _nextButton.backgroundColor = [UIColor blueColor];
        [_nextButton setTitle:@"next" forState:UIControlStateNormal];
        [_nextButton addTarget:self action:@selector(onTapNextButton) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_nextButton];
    }
    
    return self;
}

#pragma mark - 
- (void)reloadDatas:(NSArray *)datas{
    // old
    [self.items enumerateObjectsUsingBlock:^(UIView *item, NSUInteger idx, BOOL *stop) {
        [item removeFromSuperview];
    }];
    [self.items removeAllObjects];
    // new
    NSInteger count = [datas count];
    double itemWidth = CGRectGetWidth(self.scrollView.bounds);
    double itemHeight = CGRectGetHeight(self.scrollView.bounds);
    if (count <= 0) {
        return;
    } else if (count == 1) {
        self.preButton.hidden = YES;
        self.nextButton.hidden = YES;
        ScrollItem *item = [[ScrollItem alloc] initWithFrame:self.scrollView.bounds];
        [self.items addObject:item];
        [self.scrollView addSubview:item];
        self.scrollView.contentSize = CGSizeMake(itemWidth, itemHeight);
    } else {
//        UIView *topPlaceHolderView = [[UIView alloc] initWithFrame:self.scrollView.bounds];
//        [self.items addObject:topPlaceHolderView];
//        [self.scrollView addSubview:topPlaceHolderView];
        __weak typeof(self) weakSelf = self;
        [datas enumerateObjectsUsingBlock:^(NSString *data, NSUInteger idx, BOOL *stop) {
            ScrollItem *item = [[ScrollItem alloc] initWithFrame:CGRectMake(0, itemHeight * idx, itemWidth, itemHeight)];
            [weakSelf.items addObject:item];
            [weakSelf.scrollView addSubview:item];
        }];
//        UIView *bottomPlaceHolderView = [[UIView alloc] initWithFrame:CGRectMake(0, itemHeight * (count + 1), itemWidth, itemHeight)];
//        [self.items addObject:bottomPlaceHolderView];
//        [self.scrollView addSubview:bottomPlaceHolderView];
        
        self.scrollView.contentSize = CGSizeMake(itemWidth, itemHeight * count);
        
        if (count == 2) {
            self.preButton.hidden = YES;
            self.nextButton.hidden = NO;
        } else {
            self.preButton.hidden = NO;
            self.nextButton.hidden = NO;
            self.scrollView.contentOffset = CGPointMake(0, itemHeight);
        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger count = [self.items count];
    if (count <= 1) {
        return;
    }
    [self refreshPageButtons];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.preButton.enabled = NO;
    self.nextButton.enabled = NO;
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        self.preButton.enabled = YES;
        self.nextButton.enabled = YES;
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.preButton.enabled = YES;
    self.nextButton.enabled = YES;
}

#pragma mark - 点击按钮
- (void)onTapPreButton {
    double offsetY = self.scrollView.contentOffset.y;
    offsetY -= CGRectGetHeight(self.scrollView.bounds);
    [self.scrollView setContentOffset:CGPointMake(0, offsetY) animated:YES];
    [self refreshPageButtons];
}
- (void)onTapNextButton {
    double offsetY = self.scrollView.contentOffset.y;
    offsetY += CGRectGetHeight(self.scrollView.bounds);
    [self.scrollView setContentOffset:CGPointMake(0, offsetY) animated:YES];
    [self refreshPageButtons];
}

#pragma mark -
- (void)refreshPageButtons {
    NSInteger count = [self.items count];
    double itemHeight = CGRectGetHeight(self.scrollView.bounds);
    if (self.scrollView.contentOffset.y < itemHeight / 2) {
        self.preButton.hidden = YES;
        self.nextButton.hidden = NO;
    } else if (self.scrollView.contentOffset.y > itemHeight * (count - 3.0 / 2)) {
        self.preButton.hidden = NO;
        self.nextButton.hidden = YES;
    } else {
        self.preButton.hidden = NO;
        self.nextButton.hidden = NO;
    }
}

@end
