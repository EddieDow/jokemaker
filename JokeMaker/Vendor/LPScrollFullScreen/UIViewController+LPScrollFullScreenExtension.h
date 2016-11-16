//
//  UIViewController+LPScrollFullScreenExtension.h
//  LPScrollFullScreenSample
//
//  Created by litt1e-p on 15/11/6.
//  Copyright © 2015年 litt1e-p. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (LPScrollFullScreenExtension)

- (void)showNavigationBar:(BOOL)animated;
- (void)hideNavigationBar:(BOOL)animated;
- (void)moveNavigationBar:(CGFloat)deltaY animated:(BOOL)animated;
- (void)setNavigationBarOriginY:(CGFloat)y animated:(BOOL)animated;

- (void)showToolbar:(BOOL)animated;
- (void)hideToolbar:(BOOL)animated;
- (void)moveToolbar:(CGFloat)deltaY animated:(BOOL)animated;
- (void)setToolbarOriginY:(CGFloat)y animated:(BOOL)animated;

- (void)showTabBar:(BOOL)animated;
- (void)hideTabBar:(BOOL)animated;
- (void)moveTabBar:(CGFloat)deltaY animated:(BOOL)animated;
- (void)setTabBarOriginY:(CGFloat)y animated:(BOOL)animated;

@end

@interface UIViewController (LPFullScreenSupportDeprecated)

- (void)moveNavigtionBar:(CGFloat)deltaY animated:(BOOL)animated __deprecated_msg("Use `moveNavigationBar:animated:`");

@end
