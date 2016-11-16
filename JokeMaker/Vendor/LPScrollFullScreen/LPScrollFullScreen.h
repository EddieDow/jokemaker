//
//  LPScrollFullScreen.h
//  LPScrollFullScreenSample
//
//  Created by litt1e-p on 15/11/6.
//  Copyright © 2015年 litt1e-p. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIViewController+LPScrollFullScreenExtension.h"

@protocol LPScrollFullscreenDelegate;

@interface LPScrollFullScreen : NSObject<UIScrollViewDelegate, UITableViewDelegate, UIWebViewDelegate>

@property (nonatomic, weak) id<LPScrollFullscreenDelegate> delegate;

@property (nonatomic) CGFloat upThresholdY; // up distance until fire. default 0 px.
@property (nonatomic) CGFloat downThresholdY; // down distance until fire. default 200 px.

- (id)initWithForwardTarget:(id)forwardTarget;
- (void)reset;

@end

@protocol LPScrollFullscreenDelegate <NSObject>

- (void)scrollFullScreen:(LPScrollFullScreen *)fullScreenProxy scrollViewDidScrollUp:(CGFloat)deltaY;
- (void)scrollFullScreen:(LPScrollFullScreen *)fullScreenProxy scrollViewDidScrollDown:(CGFloat)deltaY;
- (void)scrollFullScreenScrollViewDidEndDraggingScrollUp:(LPScrollFullScreen *)fullScreenProxy;
- (void)scrollFullScreenScrollViewDidEndDraggingScrollDown:(LPScrollFullScreen *)fullScreenProxy;

@end
