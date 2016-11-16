//
//  GridImageView.m
//  sister
//
//  Created by Dou, Eddie on 9/11/16.
//  Copyright © 2016 Openlab. All rights reserved.


#import "GridImageView.h"
#import "ImageUnitView.h"


#define Padding 2

#define OneImageMaxWidth [UIScreen mainScreen].bounds.size.width*0.5

@interface GridImageView()


@property (nonatomic, strong) NSMutableArray *images;

@property (nonatomic, strong) NSMutableArray *imageViews;

@property (nonatomic, strong) UIImageView *oneImageView;


@end

@implementation GridImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        _imageViews = [NSMutableArray array];

        [self initView];
    }
    return self;
}

-(void) initView
{
    CGFloat x, y, width, height;

    width = (self.frame.size.width - 2*Padding)/3;
    height = width;

    for (int row=0; row<3; row++) {
        for (int column=0; column<3; column++) {

            x = (width+Padding)*column;
            y = (height+Padding)*row;
            ImageUnitView *imageUnitView = [[ImageUnitView alloc] initWithFrame:CGRectMake(x, y, width, height)];
            [self addSubview:imageUnitView];
            imageUnitView.hidden = YES;

            [_imageViews addObject:imageUnitView];
        }
    }

    _oneImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _oneImageView.hidden = YES;
    _oneImageView.backgroundColor = [UIColor lightGrayColor];


    [self addSubview:_oneImageView];


}
-(void)updateWithImages:(NSMutableArray *)images oneImageWidth:(CGFloat)oneImageWidth oneImageHeight:(CGFloat)oneImageHeight
{
    self.images = images;

    if (images.count == 1) {
        _oneImageView.hidden = NO;
        if (oneImageWidth > OneImageMaxWidth) {
            _oneImageView.frame = CGRectMake(0, 0, OneImageMaxWidth, oneImageHeight*(OneImageMaxWidth/oneImageWidth));
        }else{
            _oneImageView.frame = CGRectMake(0, 0, oneImageWidth, oneImageHeight);
        }
        _oneImageView.image = [images objectAtIndex:0];

    }else{
        _oneImageView.hidden = YES;
    }

    for (int i=0; i< _imageViews.count; i++) {
        ImageUnitView *imageUnitView = [_imageViews objectAtIndex:i];

        if (images.count == 1) {
            imageUnitView.hidden = YES;
        }else{

            if (images.count == 4) {
                if (i == 0 || i == 1 ) {
                    imageUnitView.imageView.image = [images objectAtIndex:i];
                    imageUnitView.hidden = NO;
                }else if (i == 3 || i == 4 ) {
                    imageUnitView.imageView.image = [images objectAtIndex:i-1];
                    imageUnitView.hidden = NO;
                }else{
                    imageUnitView.hidden = YES;
                }
            }else{
                if (i < images.count) {
                    imageUnitView.imageView.image = [images objectAtIndex:i];
                    imageUnitView.hidden = NO;
                }else{
                    imageUnitView.hidden = YES;
                }
            }
        }

    }
}




+(CGFloat)getHeight:(NSMutableArray *)images maxWidth:(CGFloat)maxWidth oneImageWidth:(CGFloat)oneImageWidth oneImageHeight:(CGFloat)oneImageHeight
{
    CGFloat height= (maxWidth - 2*Padding)/3;

    if (images == nil || images.count == 0) {
        return 0.0;
    }

    if (images.count == 1) {
        if (oneImageWidth > OneImageMaxWidth) {
            return oneImageHeight*(OneImageMaxWidth/oneImageWidth);
        }
        return oneImageHeight;
    }

    if (images.count >1 && images.count <=3 ) {
        return height;
    }

    if (images.count >3 && images.count <=6 ) {
        return height*2+Padding;
    }

    return height*3+Padding*2;

}

@end
