//
//  AppUtils.m
//  sister
//
//  Created by eddie on 1/17/15.
//  Copyright (c) 2015 Openlab. All rights reserved.
//

#import "AppUtils.h"
#import "AppConstants.h"
#import "FileSave.h"

static Moments *moment = nil;

@implementation AppUtils

+ (void)setMoment:(Moments *)var {
    moment = var;
}
+ (Moments *)getMom {
    return moment;
}

+ (void) saveIntoPresistentLayer: (Moments *)saveMoment {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];

    //get total count
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger count = [defaults integerForKey: kMomentCount];
    if (count == nil) {
        count = 0;
    }
    
    //prepare object for next item + 1
    count = count + 1;
    NSString *contentKey = [[NSString alloc] initWithFormat:@"%@_%d", kMomentPrefix, count];
    
    //Avatar key
    NSString *avatarImageName = [[NSString alloc] initWithFormat:@"%@_avatar.png", contentKey];
    [dic setValue:avatarImageName forKey:@"avatar"];
    [FileSave saveDataToDocumentsDirectory:UIImagePNGRepresentation(saveMoment.avatar) withName:avatarImageName andSubDirectory: kMomentCachedImagePath];

    //TODO: save avatar image
    
    [dic setValue:saveMoment.userName forKey:@"userName"];
    [dic setValue:saveMoment.content forKey:@"content"];
    [dic setValue:saveMoment.location forKey:@"location"];
    [dic setValue:saveMoment.time forKey:@"time"];
    [dic setValue:saveMoment.likes forKey:@"likes"];
    
    NSMutableArray *comments = [[NSMutableArray alloc] init];
    for (CommentItem* comment in saveMoment.comments) {
        NSDictionary *dicComment = [[NSDictionary alloc] init];
        [dicComment setValue:comment.userNick forKey:@"userNick"];
        [dicComment setValue:comment.replyUserNick forKey:@"replyUserNick"];
        [dicComment setValue:comment.comment forKey:@"comment"];
        [comments addObject:dicComment];
    }
    [dic setValue:comments forKey:@"comment"];
    
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (int i = 0; i < images.count; i++) {
        NSString *imageName = [[NSString alloc] initWithFormat:@"%@_%davatar.png", contentKey,i];
        [images addObject:imageName];
        [FileSave saveDataToDocumentsDirectory:UIImagePNGRepresentation(saveMoment.arrImage[i]) withName:imageName andSubDirectory: kMomentCachedImagePath];
    }
    [dic setValue:images forKey:@"arrImage"];
    
    //Set cached index
     NSMutableArray *indexs = [defaults objectForKey: kMomentIndex];
    if (indexs == nil) {
        indexs = [[NSMutableArray alloc] init];
    }
    NSMutableArray *mutableCopyArray = [indexs mutableCopy];
    [mutableCopyArray addObject:contentKey];
    
    [defaults setObject:mutableCopyArray forKey:kMomentIndex];
    [defaults setObject:dic forKey:contentKey];
    [defaults setInteger:count forKey:kMomentCount];
    [defaults synchronize];
//
//    //reset for testing
//    [defaults setInteger:0 forKey:kMomentCount];
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
