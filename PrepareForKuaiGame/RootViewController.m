//
//  RootViewController.m
//  PrepareForKuaiGame
//
//  Created by Chen Meisong on 14-10-12.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) NSArray       *datas;
@property (nonatomic) UITableView   *tableView;
@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _datas  = @[
                    @[@"临时测试", @"_tempViewController"],
                    @[@"图片吐槽", @"ImageCommentViewController"],
                    @[@"图片吐槽无线", @"ImageCommentNoLineViewController"],
                    @[@"中文转拼音", @"ZhToPinyinViewController"],
                    @[@"screen尺寸及键盘适配", @"KeyboardAdaptViewController"],
                    @[@"html", @"HtmlViewController"],
                    @[@"item浏览", @"ItemScrollViewController"],
                    @[@"AlertView等适配iOS8", @"AlertAdapterViewController"],
                    @[@"从1到N的tab", @"From1ToNViewController"],
                    ];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    _tableView.backgroundColor = [UIColor lightGrayColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _tableView.frame = self.view.bounds;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_datas count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [[_datas objectAtIndex:indexPath.row] objectAtIndex:0];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *className = [[_datas objectAtIndex:indexPath.row] objectAtIndex:1];
    UIViewController *subViewController = [NSClassFromString(className) new];
    [self.navigationController pushViewController:subViewController animated:YES];
}

@end
