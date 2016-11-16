//
//  APRoundedButton.m
//  WeChatTool
//
//  Created by Dou, Eddie on 9/24/16.
//  Copyright © 2016 Openlab. All rights reserved.
//

#import "APRoundedButton.h"

@implementation APRoundedButton

-(void)drawRect:(CGRect)rect
{
    UIRectCorner corners = UIRectCornerAllCorners;   //默认全部

    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                   byRoundingCorners:corners
                                                         cornerRadii:CGSizeMake(20.0, 30.0)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame         = self.bounds;
    maskLayer.path          = maskPath.CGPath;
    self.layer.mask         = maskLayer;
}


@end

