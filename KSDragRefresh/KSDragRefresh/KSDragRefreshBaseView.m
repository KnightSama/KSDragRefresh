//
//  KSDragRefreshBaseView.m
//  KSLibrary
//
//  Created by zhang on 15/12/21.
//  Copyright © 2015年 KamiSama. All rights reserved.
//

#import "KSDragRefreshBaseView.h"

@implementation KSDragRefreshBaseView

/**
 *  @brief 初始化
 */
- (instancetype)initWithWidth:(CGFloat)width Height:(CGFloat)height{
    if (self = [super init]) {
        [self setFrame:CGRectMake(0, 0, width, height)];
        
        self.textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, width, height)];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.textLabel];
        self.activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:self.activity];
    }
    return self;
}

/**
 *  @brief 在不同状态下重新布局刷新头部视图
 */
-(void)layoutHeadView:(RefreshState)state contentOffset:(CGFloat)offset{
    
}

/**
 *  @brief 在不同状态下重新布局刷新头部视图
 */
-(void)layoutFootView:(RefreshState)state contentOffset:(CGFloat)offset{
}

@end
