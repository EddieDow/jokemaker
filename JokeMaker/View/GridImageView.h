//
//  GridImageView.h
//  sister
//
//  Created by Dou, Eddie on 9/11/16.
//  Copyright © 2016 Openlab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GridImageView : UIView


-(void) updateWithImages:(NSMutableArray *)images oneImageWidth:(CGFloat)oneImageWidth oneImageHeight:(CGFloat)oneImageHeight;

+(CGFloat) getHeight:(NSMutableArray *) images maxWidth:(CGFloat)maxWidth oneImageWidth:(CGFloat)oneImageWidth oneImageHeight:(CGFloat)oneImageHeight;

@end
