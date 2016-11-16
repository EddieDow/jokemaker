//
//  AppUtils.m
//  sister
//
//  Created by eddie on 1/17/15.
//  Copyright (c) 2015 Openlab. All rights reserved.
//

#import "AppUtils.h"

static Moments *moment = nil;

@implementation AppUtils

+ (void)setMoment:(Moments *)var {
    moment = var;
}
+ (Moments *)getMom {
    return moment;
}



+ (NSInteger) appId{
    return 692526057;
}

+ (CGFloat)labelHeightForWrappedString:(NSString *)string forWidth:(CGFloat)width withFont:(UIFont *)fontSpec {
    if ([AppUtils isEmptyString:string]) {
        return 0.0f;
    }

    CGSize boundingSize = CGSizeMake(width, CGFLOAT_MAX);
    CGSize requiredSize = [string boundingRectWithSize:boundingSize
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:@{NSFontAttributeName:fontSpec}
                                               context:nil].size;
    return ceilf(requiredSize.height);
}


+ (BOOL)isEmptyString:(id)string{
    return (string == nil || string == [NSNull null] || [string isEqualToString:@""]);
}

+ (BOOL)isEmpty:(id)obj{
    BOOL ret = (obj == nil || obj==[NSNull null]);
    if (!ret && [obj respondsToSelector:@selector(count)]) {
        if ([obj count] == 0) {
            ret = YES;
        }
    }
    return ret;
}

+ (UIImage *) imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    UIImage * snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snapshotImage;
}

+(CGSize) getMaxSizeWithSuperSize:(CGSize) superSize AndRealSize:(CGSize)imgSize {
    float maxHeight = imgSize.height;
    float maxWidth = imgSize.width;
    if(imgSize.height>superSize.height){
        if(imgSize.width>superSize.width) {
            if (imgSize.width/superSize.width>imgSize.height/superSize.height) {
                maxWidth = superSize.width;
                maxHeight = maxWidth * imgSize.height/imgSize.width;
            } else {
                maxHeight = superSize.height;
                maxWidth = maxHeight * imgSize.width/imgSize.height;
            }
        } else {
            maxHeight = superSize.height;
            maxWidth = maxHeight * imgSize.width/imgSize.height;
        }
    } else if(imgSize.width>superSize.width){
        if(imgSize.height>superSize.height) {
            if (imgSize.height/superSize.height>imgSize.width/superSize.width) {
                maxHeight = superSize.height;
                maxWidth = maxHeight * imgSize.width/imgSize.height;
            } else {
                maxWidth = superSize.width;
                maxHeight = maxWidth * imgSize.height/imgSize.width;
            }
        } else {
            maxWidth = superSize.width;
            maxHeight = maxWidth * imgSize.height/imgSize.width;
        }
    }
    return CGSizeMake(maxWidth, maxHeight);
}

+(UIImage *)getImage:(ALAsset *)asset isFullImage:(BOOL)fullImage{
    UIImage *image = nil;
    if (fullImage) {
        NSNumber *orientationValue = [asset valueForProperty:ALAssetPropertyOrientation];
        UIImageOrientation orientation = UIImageOrientationUp;
        if (orientationValue != nil) {
            orientation = [orientationValue intValue];
        }

        image = [UIImage imageWithCGImage:asset.thumbnail];

    } else {
        image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];

    }
    return image;
}

@end
