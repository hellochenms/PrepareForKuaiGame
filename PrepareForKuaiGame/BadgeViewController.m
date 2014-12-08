//
//  BadgeViewController.m
//  PrepareForKuaiGame
//
//  Created by Chen Meisong on 14/12/8.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import "BadgeViewController.h"
#import "BadgeView.h"

@interface BadgeViewController ()
@property (nonatomic) BadgeView *mainView;
@end

@implementation BadgeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.mainView = [[BadgeView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:self.mainView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
