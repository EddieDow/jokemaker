//
//  LPScrollFullScreen.m
//  LPScrollFullScreenSample
//
//  Created by litt1e-p on 15/11/6.
//  Copyright © 2015年 litt1e-p. All rights reserved.
//

#import "LPScrollFullScreen.h"

typedef NS_ENUM(NSInteger, LPScrollDirection) {
    LPScrollDirectionNone,
    LPScrollDirectionUp,
    LPScrollDirectionDown,
};

LPScrollDirection detectScrollDirection(currentOffsetY, previousOffsetY)
{
    return currentOffsetY > previousOffsetY ? LPScrollDirectionUp   :
    currentOffsetY < previousOffsetY ? LPScrollDirectionDown :
    LPScrollDirectionNone;
}

@interface LPScrollFullScreen ()

@property (nonatomic) LPScrollDirection previousScrollDirection;
@property (nonatomic) CGFloat previousOffsetY;
@property (nonatomic) CGFloat accumulatedY;
@property (nonatomic, weak) id<UIScrollViewDelegate> forwardTarget;
@property (nonatomic, assign) CGFloat navigationBarOriginalBottom;

@end

@implementation LPScrollFullScreen

- (id)initWithForwardTarget:(id)forwardTarget
{
    self = [super init];
    if (self) {
        [self reset];
        _downThresholdY = 200.0;
        _upThresholdY = 0.0;
        _forwardTarget = forwardTarget;
        UIViewController *forwardTargetVc = (UIViewController *)forwardTarget;
        _navigationBarOriginalBottom = CGRectGetMaxY(forwardTargetVc.navigationController.navigationBar.frame);
    }
    return self;
}

- (void)reset
{
    _previousOffsetY = 0.0;
    _accumulatedY = 0.0;
    _previousScrollDirection = LPScrollDirectionNone;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([_forwardTarget respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [_forwardTarget scrollViewDidScroll:scrollView];
    }
    
    CGFloat currentOffsetY = scrollView.contentOffset.y;
    
    LPScrollDirection currentScrollDirection = detectScrollDirection(currentOffsetY, _previousOffsetY);
    CGFloat topBoundary = -scrollView.contentInset.top;
    CGFloat bottomBoundary = scrollView.contentSize.height + scrollView.contentInset.bottom;
    
    BOOL isOverTopBoundary = currentOffsetY <= topBoundary;
    BOOL isOverBottomBoundary = currentOffsetY >= bottomBoundary;
    
    BOOL isBouncing = (isOverTopBoundary && currentScrollDirection != LPScrollDirectionDown) || (isOverBottomBoundary && currentScrollDirection != LPScrollDirectionUp);
    if (isBouncing || !scrollView.isDragging) {
        return;
    }
    
    CGFloat deltaY = _previousOffsetY - currentOffsetY;
    _accumulatedY += deltaY;
    
    switch (currentScrollDirection) {
        case LPScrollDirectionUp:
        {
            BOOL isOverThreshold = _accumulatedY < -_upThresholdY;
            
            if (isOverThreshold || isOverBottomBoundary)  {
                if ([_delegate respondsToSelector:@selector(scrollFullScreen:scrollViewDidScrollUp:)]) {
                    [_delegate scrollFullScreen:self scrollViewDidScrollUp:deltaY];
                } else {
                    UIViewController *forwardTargetVc = (UIViewController *)_forwardTarget;
                    [forwardTargetVc moveNavigationBar:deltaY animated:YES];
                    [forwardTargetVc moveTabBar:-deltaY animated:YES];
                    [forwardTargetVc moveToolbar:-deltaY animated:YES];
                }
            }
        }
            break;
        case LPScrollDirectionDown:
        {
            BOOL isOverThreshold = _accumulatedY > _downThresholdY;
            
            if (isOverThreshold || isOverTopBoundary) {
                if ([_delegate respondsToSelector:@selector(scrollFullScreen:scrollViewDidScrollDown:)]) {
                    [_delegate scrollFullScreen:self scrollViewDidScrollDown:deltaY];
                } else {
                    UIViewController *forwardTargetVc = (UIViewController *)_forwardTarget;
                    [forwardTargetVc moveNavigationBar:deltaY animated:YES];
                    [forwardTargetVc moveTabBar:-deltaY animated:YES];
                    [forwardTargetVc moveToolbar:-deltaY animated:YES];
                }
            }
        }
            break;
        case LPScrollDirectionNone:
            break;
    }
    
    // reset acuumulated y when move opposite direction
    if (!isOverTopBoundary && !isOverBottomBoundary && _previousScrollDirection != currentScrollDirection) {
        _accumulatedY = 0;
    }
    
    _previousScrollDirection = currentScrollDirection;
    _previousOffsetY = currentOffsetY;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([_forwardTarget respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [_forwardTarget scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
    
    CGFloat currentOffsetY = scrollView.contentOffset.y;
    
    CGFloat topBoundary = -scrollView.contentInset.top;
    CGFloat bottomBoundary = scrollView.contentSize.height + scrollView.contentInset.bottom;
    
    switch (_previousScrollDirection) {
        case LPScrollDirectionUp:
        {
            BOOL isOverThreshold = _accumulatedY < -_upThresholdY;
            BOOL isOverBottomBoundary = currentOffsetY >= bottomBoundary;
            
            if (isOverThreshold || isOverBottomBoundary) {
                if ([_delegate respondsToSelector:@selector(scrollFullScreenScrollViewDidEndDraggingScrollUp:)]) {
                    [_delegate scrollFullScreenScrollViewDidEndDraggingScrollUp:self];
                } else {
                    UIViewController *forwardTargetVc = (UIViewController *)_forwardTarget;
                    [forwardTargetVc hideNavigationBar:YES];
                    [forwardTargetVc hideTabBar:YES];
                    [forwardTargetVc hideToolbar:YES];
                }
            }
            break;
        }
        case LPScrollDirectionDown:
        {
            BOOL isOverThreshold = _accumulatedY > _downThresholdY;
            BOOL isOverTopBoundary = currentOffsetY <= topBoundary;
            
            if (isOverThreshold || isOverTopBoundary) {
                if ([_delegate respondsToSelector:@selector(scrollFullScreenScrollViewDidEndDraggingScrollDown:)]) {
                    [_delegate scrollFullScreenScrollViewDidEndDraggingScrollDown:self];
                } else {
                    UIViewController *forwardTargetVc = (UIViewController *)_forwardTarget;
                    [forwardTargetVc showNavigationBar:YES];
                    [forwardTargetVc showTabBar:YES];
                    [forwardTargetVc showToolbar:YES];
                }
            }
            break;
        }
        case LPScrollDirectionNone:
            break;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y == -_navigationBarOriginalBottom) {
        UIViewController *forwardTargetVc = (UIViewController *)_forwardTarget;
        [UIView animateWithDuration:0.1f animations:^{
            [forwardTargetVc showNavigationBar:YES];
            [forwardTargetVc showTabBar:YES];
            [forwardTargetVc showToolbar:YES];
        }];
    }
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    BOOL ret = YES;
    if ([_forwardTarget respondsToSelector:@selector(scrollViewShouldScrollToTop:)]) {
        ret = [_forwardTarget scrollViewShouldScrollToTop:scrollView];
    }
    if ([_delegate respondsToSelector:@selector(scrollFullScreenScrollViewDidEndDraggingScrollDown:)]) {
        [_delegate scrollFullScreenScrollViewDidEndDraggingScrollDown:self];
    } else {
        UIViewController *forwardTargetVc = (UIViewController *)_forwardTarget;
        [forwardTargetVc showNavigationBar:YES];
        [forwardTargetVc showTabBar:YES];
        [forwardTargetVc showToolbar:YES];
    }
    return ret;
}

#pragma mark -
#pragma mark Method Forwarding

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
    NSMethodSignature *signature = [super methodSignatureForSelector:selector];
    if(!signature) {
        if([_forwardTarget respondsToSelector:selector]) {
            return [(id)_forwardTarget methodSignatureForSelector:selector];
        }
    }
    return signature;
}

- (void)forwardInvocation:(NSInvocation*)invocation
{
    if ([_forwardTarget respondsToSelector:[invocation selector]]) {
        [invocation invokeWithTarget:_forwardTarget];
    }
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    BOOL ret = [super respondsToSelector:aSelector];
    if (!ret) {
        ret = [_forwardTarget respondsToSelector:aSelector];
    }
    return ret;
}

- (BOOL)conformsToProtocol:(Protocol *)aProtocol
{
    BOOL ret = [super conformsToProtocol:aProtocol];
    if (!ret) {
        ret = [_forwardTarget conformsToProtocol:aProtocol];
    }
    return ret;
}

@end
