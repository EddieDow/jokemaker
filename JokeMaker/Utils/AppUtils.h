//
//  AppUtils.h
//  sister
//
//  Created by eddie on 1/17/15.
//  Copyright (c) 2015 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "Moments.h"



@interface AppUtils : NSObject

+ (void)setMoment:(Moments *)var;
+ (Moments *)getMom;

+ (UIImage *) imageWithView:(UIView *)view;

+ (NSInteger) appId;


+ (CGFloat)labelHeightForWrappedString:(NSString *)string forWidth:(CGFloat)width withFont:(UIFont *)fontSpec;

+ (BOOL)isEmptyString:(id)string;

+ (BOOL)isEmpty:(id)obj;

+(CGSize) getMaxSizeWithSuperSize:(CGSize) superSize AndRealSize:(CGSize)imgSize;


+(UIImage *)getImage:(ALAsset *)asset isFullImage:(BOOL)fullImage;

@end
