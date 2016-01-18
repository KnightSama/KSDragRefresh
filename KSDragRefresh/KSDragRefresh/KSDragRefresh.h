//
//  KSDragRefresh.h
//  KSLibrary
//
//  Created by zhang on 15/12/17.
//  Copyright © 2015年 KamiSama. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSDragRefreshBaseView.h"

#pragma mark - 代理协议

@protocol KSDragRefreshDelegate <NSObject>

/**
 *  @brief 加载下拉刷新数据
 */
- (void)reloadDataForDownPull;

/**
 *  @brief 加载上拉加载的数据
 */
- (void)reloadDataForUpPull;
@end

#pragma mark -

@interface KSDragRefresh : NSObject

/**
 *  @brief 刷新头部视图
 */
@property(nonatomic,strong) KSDragRefreshBaseView *refreshHeader;

/**
 *  @brief 刷新尾部视图
 */
@property(nonatomic,strong) KSDragRefreshBaseView *refreshFooter;

/**
 *  @brief 代理
 */
@property(nonatomic,weak) id<KSDragRefreshDelegate> delegate;

/**
 *  @brief 是否开启下拉刷新默认为YES
 */
@property(nonatomic,assign) BOOL canDownRefresh;

/**
 *  @brief 是否开启上拉加载默认为YES
 */
@property(nonatomic,assign) BOOL canUpRefresh;

/**
 *  @brief 下拉刷新需要拖拽的长度默认为下拉视图的高度
 */
@property(nonatomic,assign) CGFloat dragDownLength;

/**
 *  @brief 上拉加载需要拖拽的长度默认为上拉视图的高度
 */
@property(nonatomic,assign) CGFloat dragUpLength;

/**
 *  @brief 通过要添加的tableView初始化
 */
- (instancetype)initWithTableView:(UITableView *)tableView;

/**
 *  @brief 开始一次刷新
 */
- (void)startRefreshWithAnimationDuration:(NSTimeInterval)time;

/**
 *  @brief 停止头部刷新
 */
- (void)stopHeadRefreshWithAnimationDuration:(NSTimeInterval)time;

/**
 *  @brief 停止尾部刷新
 */
- (void)stopFootRefreshWithAnimationDuration:(NSTimeInterval)time;

/**
 *  @brief 移除刷新功能
 */
- (void)removeRefresh;
@end
