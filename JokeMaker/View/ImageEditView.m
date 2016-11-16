//
//  ImageEditView.m
//  PTPaiPaiCamera
//
//  Created by eddie on 1/26/15.
//

#import "ImageEditView.h"

@implementation ImageEditView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initResource];
    }
    return self;
}

- (void)initResource
{
    self.backgroundColor = [UIColor clearColor];
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                               10,
                                                               self.frame.size.width - 10,
                                                               self.frame.size.height - 10)];
    _imageView.contentMode=UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds=YES;
    _imageView.layer.borderWidth = 2.0f;
    _imageView.userInteractionEnabled = TRUE;
    _imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    [self addSubview:_imageView];
    
    UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteButtonAction)];
    [_imageView addGestureRecognizer:gr];
    
    
    _deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-30,
                                                               0,
                                                               30,
                                                               30)];
    [_deleteButton.layer setCornerRadius:12.5f];
    [_deleteButton setImage:[UIImage imageNamed:@"mark_button_delete"] forState:UIControlStateNormal];
    [_deleteButton addTarget:self
                      action:@selector(deleteButtonAction)
            forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_deleteButton];
}

- (void)setImageAsset:(UIImage *)asset index:(NSInteger)index
{
    _asset = asset;
    _index = index;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_imageView setImage:asset];
    });
}

- (void)deleteButtonAction
{
    if(_deleteEdit && [_deleteEdit respondsToSelector:@selector(responseToDelete:)])
    {
        [_deleteEdit responseToDelete:self];
    }
}


@end
