//
//  KSDragRefreshBaseView.h
//  KSLibrary
//
//  Created by zhang on 15/12/21.
//  Copyright © 2015年 KamiSama. All rights reserved.
//
//------------------------------------------------
//  用来实现下拉刷新头部与尾部视图的基类
//  需要自定义头部与尾部视图时需要继承该类并重写方法
//------------------------------------------------

#import <UIKit/UIKit.h>

/**
 *  @brief tableView的刷新状态
 */
typedef NS_ENUM(NSUInteger, RefreshState) {
    /**
     *  普通状态
     */
    RefreshStateNormal,
    /**
     *  可见刷新视图
     */
    RefreshStateWillRefresh,
    /**
     *  松手即可刷新
     */
    RefreshStateCanRefresh,
    /**
     *  正在刷新
     */
    RefreshStateRefreshing,
};

@interface KSDragRefreshBaseView : UIView

/**
 *  @brief 文本显示框
 */
@property(nonatomic,strong) UILabel *textLabel;

/**
 *  @brief 转动的菊花视图
 */
@property(nonatomic,strong) UIActivityIndicatorView *activity;

/**
 *  @brief 初始化
 */
- (instancetype)initWithWidth:(CGFloat)width Height:(CGFloat)height;

/**
 *  @brief 在不同状态下重新布局刷新头部视图
 */
- (void)layoutHeadView:(RefreshState)state contentOffset:(CGFloat)offset;

/**
 *  @brief 在不同状态下重新布局刷新尾部视图
 */
- (void)layoutFootView:(RefreshState)state contentOffset:(CGFloat)offset;
@end
