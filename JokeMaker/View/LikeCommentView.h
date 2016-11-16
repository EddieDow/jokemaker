//
//  LikeCommentView.h
//  sister
//
//  Created by Dou, Eddie on 9/10/16.
//  Copyright © 2016 Openlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Moments.h"

@interface LikeCommentView : UIView

+(CGFloat)getHeight:(Moments *)item maxWidth:(CGFloat)maxWidth;
-(void)updateWithItem:(Moments *)comment;

@end
