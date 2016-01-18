//
//  BaseViewController.m
//  KSDragRefresh
//
//  Created by zhang on 16/1/18.
//  Copyright © 2016年 KnightSama. All rights reserved.
//

#import "BaseViewController.h"
#import "KSDragRefresh.h"
#import "MyDragRefreshHeader.h"
#import "MyDragRefreshFooter.h"
#define KS_ScrWidth ([UIScreen mainScreen].bounds.size.width)
@interface BaseViewController ()<UITableViewDataSource,KSDragRefreshDelegate>
@property(nonatomic,strong) KSDragRefresh *drag;
@property(nonatomic,strong) NSMutableArray *dataArr;
@property(nonatomic,strong) UITableView *tableView;
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64)];
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.title = @"首页";
    
    for (int i=0; i<10; i++) {
        [self.dataArr addObject:[NSString stringWithFormat:@"data:%i",i]];
    }
    self.drag = [[KSDragRefresh alloc]initWithTableView:self.tableView];
    self.drag.refreshHeader = [[MyDragRefreshHeader alloc]initWithWidth:KS_ScrWidth Height:50];
    self.drag.refreshFooter = [[MyDragRefreshFooter alloc]initWithWidth:KS_ScrWidth Height:50];
    self.drag.delegate = self;
}

-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc]init];
    }
    return _dataArr;
}

-(void)viewDidAppear:(BOOL)animated{
    [self.drag startRefreshWithAnimationDuration:0.5];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [self.dataArr objectAtIndex:indexPath.row];
    return cell;
}

- (void)reloadDataForDownPull{
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
    [self.tableView reloadData];
    [self.drag stopHeadRefreshWithAnimationDuration:0.5];
}

-(void)reloadDataForUpPull{
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:2]];
    [self.dataArr addObject:[NSString stringWithFormat:@"data new"]];
    [self.tableView reloadData];
    [self.drag stopFootRefreshWithAnimationDuration:0.5];
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
