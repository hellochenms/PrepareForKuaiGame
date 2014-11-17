//
//  ZhToPinyinViewController.m
//  PrepareForKuaiGame
//
//  Created by Chen Meisong on 14-10-21.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import "ZhToPinyinViewController.h"

@interface ZhToPinyinViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) NSArray *srcArr;
@property (nonatomic) NSMutableArray *destKeyArr;
@property (nonatomic) NSMutableDictionary *destDic;
@end

@implementation ZhToPinyinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // view中有scrollView且使用系统的naviBar时，不写下句，则系统会自动调整scrollView的inset。
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    CGRect frame = [UIScreen mainScreen].bounds;
    frame.origin.y += 64;
    frame.size.height -= 64;
    
    _srcArr = @[@"北京", @"上海", @"广州", @"深圳", @"杭州", @"大连", @"沈阳", @"西安", @"成都", @"无锡", @"拉萨", @"London", @"New York", @"Paris"];
    _destKeyArr = [NSMutableArray array];
    _destDic = [NSMutableDictionary dictionary];
    [self seperateFromSrcArr:_srcArr intoDestSortedKeyArr:_destKeyArr andDestDic:_destDic];
//    NSLog(@"_srcArr:%@  %s", _srcArr, __func__);
//    NSLog(@"_destKeyArr:%@  %s", _destKeyArr, __func__);
//    NSLog(@"_destDic:%@  %s", _destDic, __func__);
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake(100, 100, 120, 100);
//    button.backgroundColor = [UIColor blueColor];
//    [button setTitle:@"转换" forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(onTapButton) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];
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

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.destKeyArr count];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor lightGrayColor];
    label.text = [self.destKeyArr objectAtIndex:section];
    
    return label;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *items = [self.destDic objectForKey:[self.destKeyArr objectAtIndex:section]];
    
    return [items count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSArray *items = [self.destDic objectForKey:[self.destKeyArr objectAtIndex:indexPath.section]];
    cell.textLabel.text = [items objectAtIndex:indexPath.row];
    
    return cell;
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.destKeyArr;
}


#pragma mark -
- (void)onTapButton {
    [self test];
}

#pragma mark - tools
- (void)seperateFromSrcArr:(NSArray *)srcArr
      intoDestSortedKeyArr:(NSMutableArray *)destSortedKeyArr
                andDestDic:(NSMutableDictionary *)destDic {
    if (!srcArr || [srcArr count] <= 0 || !destSortedKeyArr || !destDic) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    __block NSString *firstLetter = nil;
    __block NSMutableArray *arr = nil;
    [srcArr enumerateObjectsUsingBlock:^(NSString *srcString, NSUInteger idx, BOOL *stop) {
        firstLetter = [weakSelf firstLetterOfString:srcString];
        if ([destDic objectForKey:firstLetter]) {
            arr = [destDic objectForKey:firstLetter];
        } else {
            arr = [NSMutableArray array];
            [destDic setObject:arr forKey:firstLetter];
            [destSortedKeyArr addObject:firstLetter];
        }
        [arr addObject:srcString];
    }];
    [destSortedKeyArr sortUsingComparator:^NSComparisonResult(NSString *string1, NSString *string2) {
        return [string1 compare:string2];
    }];
}

- (NSString *)firstLetterOfString:(NSString *)string {
    NSString *firstLetter = @"#";
    if (!string || [string length] <= 0) {
        return firstLetter;
    }
    
    NSMutableString *srcString = [NSMutableString stringWithString:string];
    if (CFStringTransform((__bridge CFMutableStringRef)srcString, 0, kCFStringTransformMandarinLatin, NO)
        && CFStringTransform((__bridge CFMutableStringRef)srcString, 0, kCFStringTransformStripDiacritics, NO)) {
        if ([srcString length] > 0) {
            firstLetter = [[srcString substringToIndex:1] uppercaseString];
        }
    }
    
    return firstLetter;
}

- (void)test {
    NSMutableString *string = [NSMutableString stringWithString:@"会当凌绝顶"];
    NSLog(@"中文：[%@]  %s", string, __func__);
    if (CFStringTransform((__bridge CFMutableStringRef)string, 0, kCFStringTransformMandarinLatin, NO)) {
        NSLog(@"带声调拼音：[%@]  %s", string, __func__);
    }
    if (CFStringTransform((__bridge CFMutableStringRef)string, 0, kCFStringTransformMandarinLatin, NO)
        && CFStringTransform((__bridge CFMutableStringRef)string, 0, kCFStringTransformStripDiacritics, NO)) {
        NSLog(@"拼音：[%@]  %s", string, __func__);
    }
    
    NSString *firstLetter = @"#";
    if ([string length] > 0) {
        firstLetter = [string substringToIndex:1];
    }
    NSLog(@"首字母：[%@]  %s", firstLetter, __func__);
}

@end
