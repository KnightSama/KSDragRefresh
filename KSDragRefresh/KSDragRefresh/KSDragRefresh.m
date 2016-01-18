//
//  KSDragRefresh.m
//  KSLibrary
//
//  Created by zhang on 15/12/17.
//  Copyright © 2015年 KamiSama. All rights reserved.
//

#import "KSDragRefresh.h"
#import "UIView+KSFrame.h"

@interface KSDragRefresh ()

/**
 *  @brief 当前的刷新状态
 */
@property(nonatomic,assign) RefreshState currentState;

/**
 *  @brief 要添加的tableView
 */
@property(nonatomic,weak) UITableView *tableView;

/**
 *  @brief 头部视图是否已添加
 */
@property(nonatomic,assign) BOOL isHasHead;

/**
 *  @brief 尾部视图是否已添加
 */
@property(nonatomic,assign) BOOL isHasFoot;

/**
 *  @brief 基准高度
 */
@property(nonatomic,assign) CGFloat height;

@end

@implementation KSDragRefresh

/**
 *  @brief 通过要添加的tableView初始化
 */
- (instancetype)initWithTableView:(UITableView *)tableView{
    if (self = [super init]){
        _tableView = tableView;
        _canUpRefresh = YES;
        _canDownRefresh = YES;
        _dragUpLength = -1;
        _dragDownLength = -1;
        _currentState = RefreshStateNormal;
        _isHasFoot = NO;
        _isHasHead = NO;
        //监听tableView的滚动
        [tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
    return self;
}

/**
 *  @brief 监听数值变动后执行的方法
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    self.height = (self.tableView.contentSize.height)>(self.tableView.frame.size.height)?(self.tableView.contentSize.height):(self.tableView.frame.size.height);
    self.height = self.height - self.tableView.frame.size.height;
    CGPoint newP = [[change objectForKey:@"new"] CGPointValue];
    CGPoint oldP = [[change objectForKey:@"old"] CGPointValue];
    if ((newP.y!=oldP.y)&&(newP.y<0||newP.y>self.height)) {
        [self observeContentOffsetValueChange:newP oldPoint:oldP];
    }
    if (newP.y>=0&&newP.y<=self.height&&self.currentState!=RefreshStateNormal&&self.currentState!=RefreshStateRefreshing) {
        self.currentState = RefreshStateNormal;
        [self removeRefreshView];
    }
}

/**
 *  @brief 监听到tableView滚动后的方法
 */
- (void)observeContentOffsetValueChange:(CGPoint)newP oldPoint:(CGPoint)oldP{
    if (newP.y<0&&self.refreshHeader&&self.canDownRefresh) {
        if (self.dragDownLength<0) {
            self.dragDownLength = self.refreshHeader.frame.size.height;
        }
        if (newP.y>-self.dragDownLength&&self.currentState!=RefreshStateRefreshing) {
            self.currentState = RefreshStateWillRefresh;
            [self addHeadView];
            [self layoutView:self.refreshHeader offset:newP.y state:self.currentState];
        }
        if (newP.y<-self.dragDownLength&&self.currentState!=RefreshStateRefreshing) {
            self.currentState = RefreshStateCanRefresh;
            [self layoutView:self.refreshHeader offset:newP.y state:self.currentState];
        }
        if (self.tableView.decelerating&&oldP.y<-self.dragDownLength&&self.currentState!=RefreshStateRefreshing) {
            self.currentState = RefreshStateRefreshing;
            [self layoutView:self.refreshHeader offset:newP.y state:self.currentState];
            [self refreshHeadView];
        }
    }
    if (newP.y>self.height&&self.refreshFooter&&self.canUpRefresh) {
        if (self.dragUpLength<0) {
            self.dragUpLength = self.refreshFooter.frame.size.height;
        }
        if (newP.y<self.height+self.dragUpLength&&self.currentState!=RefreshStateRefreshing) {
            self.currentState = RefreshStateWillRefresh;
            [self addFootView];
            [self layoutView:self.refreshFooter offset:newP.y state:self.currentState];
        }
        if (newP.y>self.height+self.dragUpLength&&self.currentState!=RefreshStateRefreshing) {
            self.currentState = RefreshStateCanRefresh;
            [self layoutView:self.refreshFooter offset:newP.y state:self.currentState];
        }
        if (oldP.y>self.height+self.dragUpLength&&self.tableView.decelerating&&self.currentState!=RefreshStateRefreshing) {
            self.currentState = RefreshStateRefreshing;
            [self layoutView:self.refreshFooter offset:newP.y state:self.currentState];
            [self refreshFootView];
        }
    }
}

/**
 *  @brief 重新布局刷新视图
 */
- (void)layoutView:(UIView *)view offset:(CGFloat)offset state:(RefreshState)state{
    if (offset<0&&self.refreshHeader&&[self.refreshHeader respondsToSelector:@selector(layoutHeadView:contentOffset:)]) {
        [self.refreshHeader layoutHeadView:state contentOffset:offset];
    }
    if (offset>0&&self.refreshFooter&&[self.refreshFooter respondsToSelector:@selector(layoutFootView:contentOffset:)]) {
        [self.refreshFooter layoutFootView:state contentOffset:offset];
    }
}

/**
 *  @brief 添加头部视图视图
 */
- (void)addHeadView{
    if (!self.isHasHead) {
        [self.refreshHeader KSSetLocationY:-self.refreshHeader.KSHeight];
        [self.tableView addSubview:self.refreshHeader];
        self.isHasHead = YES;
    }
}

/**
 *  @brief 添加尾部视图
 */
- (void)addFootView{
    if (!self.isHasFoot) {
        [self.refreshFooter KSSetLocationY:self.height+self.tableView.frame.size.height];
        [self.tableView addSubview:self.refreshFooter];
        self.isHasFoot = YES;
    }
}

/**
 *  @brief 移除视图
 */
- (void)removeRefreshView{
    if (self.isHasFoot) {
        [self.refreshFooter removeFromSuperview];
        self.isHasFoot = NO;
    }
    if (self.isHasHead) {
        [self.refreshHeader removeFromSuperview];
        self.isHasHead = NO;
    }
}

/**
 *  @brief 正在刷新头部视图
 */
- (void)refreshHeadView{
    [UIView animateWithDuration:0.5 animations:^{
        [self.tableView setContentInset:UIEdgeInsetsMake(self.refreshHeader.KSHeight, 0, self.tableView.contentInset.bottom, 0)];
        [self.tableView setContentOffset:CGPointMake(0, -self.refreshHeader.KSHeight)];
    } completion:^(BOOL finished) {
        [self loadDownRefreshData];
    }];
}

/**
 *  @brief 正在刷新尾部视图
 */
- (void)refreshFootView{
    [UIView animateWithDuration:0.5 animations:^{
        if (self.height==0) {
            [self.tableView setContentInset:UIEdgeInsetsMake(self.tableView.contentInset.top, 0, self.refreshFooter.KSHeight+self.tableView.KSHeight-self.tableView.contentSize.height, 0)];
        }else{
            [self.tableView setContentInset:UIEdgeInsetsMake(self.tableView.contentInset.top, 0, self.refreshFooter.KSHeight, 0)];
        }
    } completion:^(BOOL finished) {
        [self loadUpRefreshData];
    }];
}

/**
 *  @brief 加载下拉刷新数据
 */
- (void)loadDownRefreshData{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(reloadDataForDownPull)]) {
        [self.delegate reloadDataForDownPull];
    }
}

/**
 *  @brief 加载上拉数据
 */
- (void)loadUpRefreshData{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(reloadDataForUpPull)]) {
        [self.delegate reloadDataForUpPull];
    }
}

/**
 *  @brief 开始一次刷新
 */
- (void)startRefreshWithAnimationDuration:(NSTimeInterval)time{
    self.currentState = RefreshStateRefreshing;
    [self addHeadView];
    [self layoutView:self.refreshHeader offset:-1 state:self.currentState];
    [UIView animateWithDuration:time animations:^{
        [self refreshHeadView];
    } completion:^(BOOL finished) {
        [self loadDownRefreshData];
    }];
}

/**
 *  @brief 停止头部刷新
 */
- (void)stopHeadRefreshWithAnimationDuration:(NSTimeInterval)time{
    self.currentState = RefreshStateNormal;
    [self.refreshHeader layoutHeadView:self.currentState contentOffset:0];
    [UIView animateWithDuration:time animations:^{
        [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, self.tableView.contentInset.bottom, 0)];
    }];
}

/**
 *  @brief 停止尾部刷新
 */
- (void)stopFootRefreshWithAnimationDuration:(NSTimeInterval)time{
    [self.refreshFooter KSSetLocationY:self.height+self.tableView.frame.size.height];
    self.currentState = RefreshStateNormal;
    [self.refreshFooter layoutFootView:self.currentState contentOffset:0];
    [UIView animateWithDuration:time animations:^{
        [self.tableView setContentInset:UIEdgeInsetsMake(self.tableView.contentInset.top, 0, 0, 0)];
    }];
}

/**
 *  @brief 移除刷新功能
 */
- (void)removeRefresh{
    [self removeRefreshView];
    [self.tableView removeObserver:self forKeyPath:@"contentOffset"];
    self.tableView = nil;
}

@end
