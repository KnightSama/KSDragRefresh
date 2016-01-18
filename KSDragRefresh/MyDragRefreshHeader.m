//
//  MyDragRefreshHeader.m
//  KSDragRefresh
//
//  Created by zhang on 16/1/18.
//  Copyright © 2016年 KnightSama. All rights reserved.
//

#import "MyDragRefreshHeader.h"

@implementation MyDragRefreshHeader

- (void)layoutHeadView:(RefreshState)state contentOffset:(CGFloat)offset{
    switch (state) {
        case RefreshStateNormal: {
            self.textLabel.text = @"刷新已完成";
            [self.activity stopAnimating];
            break;
        }
        case RefreshStateWillRefresh: {
            self.textLabel.text = @"下拉可刷新";
            break;
        }
        case RefreshStateCanRefresh: {
            self.textLabel.text = @"松开可刷新";
            break;
        }
        case RefreshStateRefreshing: {
            self.textLabel.text = @"正在刷新";
            [self.activity setFrame:CGRectMake(self.frame.size.width/2-80 ,self.frame.size.height/2-16, 32, 32)];
            [self.activity startAnimating];
            break;
        }
    }
}

@end
