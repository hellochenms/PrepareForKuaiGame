//
//  From1ToNViewController.m
//  PrepareForKuaiGame
//
//  Created by Chen Meisong on 14/12/1.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import "From1ToNViewController.h"
#import "M2Item1ToNTabView.h"

@interface From1ToNViewController ()
@property (nonatomic) M2Item1ToNTabView *tabView;
@property (nonatomic) NSArray *titles;
@end

@implementation From1ToNViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _tabView = [[M2Item1ToNTabView alloc] initWithFrame:CGRectMake(0, 70, CGRectGetWidth(self.view.bounds), 44)];
    _tabView.tapTabItemHandler = ^(NSInteger selectedIndex) {
        NSLog(@"selectedIndex(%d)  %s", selectedIndex, __func__);
    };
    [self.view addSubview:_tabView];
    self.titles = @[@"0", @"1", @"2", @"3", @"4"];
    [_tabView reloadDataWithTitles:self.titles];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, CGRectGetMaxY(_tabView.frame) + 10, 300, 30);
    button.backgroundColor = [UIColor blueColor];
    [button setTitle:@"随机选中index" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onTapButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)onTapButton {
    NSInteger index = arc4random() % [self.titles count];
    [self.tabView selectIndex:index];
}

@end
