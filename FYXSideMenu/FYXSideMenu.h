//
//  FYXSideMenu.h
//  FYXComponent
//
//  Created by 欧阳云慧 on 2018/3/6.
//  Copyright © 2018年 欧阳云慧. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FYXSideMenu : UIView

@property(weak, nonatomic) UIView *sideMenuView;
@property(weak, nonatomic) UIView *backgroundView;     // 灰色背景
@property(assign, nonatomic) CGFloat sideMenY;
/**
* view添加滑动手势
*/
//- (void)addgestureView: (UIView *)gestureView hideView: (UIView *)hideView;

/**
* 设置侧边栏view的宽度
*/
- (void)setSideMenuViewWidth: (CGFloat)width;

- (void)clickDraw;
/**
 * 隐藏侧边栏
 */
- (void)sideMenuHidden;
/**
 *开始动画
 */
- (void)startAnimation;

@end



