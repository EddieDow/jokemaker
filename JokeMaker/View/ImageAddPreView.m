//
//  ImageAddPreView.m
//  PTPaiPaiCamera
//
//  Created by eddie on 1/26/15.
//

#import "ImageAddPreView.h"
#import "UIButton+Help.h"
#import "UIColor+Help.h"

#define Main_Screen_Height [[UIScreen mainScreen] bounds].size.height //主屏幕的高度
#define Main_Screen_Width  [[UIScreen mainScreen] bounds].size.width  //主屏幕的宽度

#define D_Pending_Width     5

#define D_ImageEditView_Width   80
#define D_ImageEditView_Height   100
@implementation ImageAddPreView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        [self initResource];
    }
    return self;
}



- (void)initResource {
    _imageassets = [NSMutableArray array];
    _imageEditViewArray = [NSMutableArray array];
//    UIGraphicsBeginImageContext(self.frame.size);
//    [[UIImage imageNamed:@"filter_bg_button.png"] drawInRect:self.bounds];
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    self.backgroundColor = [UIColor colorWithPatternImage:image];
    _selectBeforeLab = [[UILabel alloc] initWithFrame:CGRectMake(2*D_Pending_Width,
                                                                 D_Pending_Width,
                                                                 self.bounds.size.width - 100,
                                                                 20)];
    [_selectBeforeLab setTextColor:[UIColor blackColor]];
    [_selectBeforeLab setFont:[UIFont systemFontOfSize:17.0f]];
    [self addSubview: _selectBeforeLab];
    [_selectBeforeLab setTextAlignment:NSTextAlignmentLeft];
    
    _startPintuButton =  [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _startPintuButton.frame = CGRectMake(Main_Screen_Width -40 -D_Pending_Width,2,32,32);
    [_startPintuButton setBackgroundImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateNormal];
    [_startPintuButton addTarget:self action:@selector(startPintuButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_startPintuButton setUserInteractionEnabled:YES]; //禁用按钮
    
    [self addSubview:_startPintuButton];
    _contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,44,self.bounds.size.width,D_ImageEditView_Height)];
    _contentView.showsHorizontalScrollIndicator = true;
    [self addSubview:_contentView];
}

-(void)setDeclation{
    NSString *strMsg = [NSString stringWithFormat:@"请选择 0-%ld 张图片",(long)_maxSelected - [_imageassets count]];
    if ([_imageassets count] == 9) {
        strMsg = @"请选择 0 张图片";
    }
    
    [_selectBeforeLab setText:strMsg];
}


- (void)addImageWith:(UIImage *)asset isJoin:(BOOL) flag
{
    
    if(_imageassets.count < _maxSelected){
        [_imageassets addObject:asset];
        ImageEditView *editView = [[ImageEditView alloc] initWithFrame:CGRectMake([_imageassets count]*(D_ImageEditView_Width+D_Pending_Width)+D_Pending_Width,
                                                                                  0,
                                                                                  D_ImageEditView_Width,
                                                                                  D_ImageEditView_Height)];
        [editView setImageAsset:asset index:[_imageassets count]-1];
        editView.deleteEdit = self;
        [_imageEditViewArray addObject:editView];
        [_contentView addSubview:editView];
        [self resetContentView];
        if ([_imageassets count]*(D_ImageEditView_Width+D_Pending_Width)+D_Pending_Width > _contentView.frame.size.width) {
            [self.contentView setContentOffset:CGPointMake(self.contentView.contentSize.width - _contentView.frame.size.width, 0) animated:YES];
        }
    }

    
}

- (void)startPintuButtonAction:(id)sender
{
    if(_imageassets.count < _minSelected){
        NSString *strMsg = [NSString stringWithFormat:@"最少选择%ld张图片",(long)_minSelected];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:strMsg
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"确定", nil];
        [alert show];
    } else {
        if (_delegateSelectImage && [_delegateSelectImage respondsToSelector:@selector(startPintuAction:)]) {
            [_delegateSelectImage startPintuAction:self];
        }
    }
}

#pragma mark
#pragma mark ImageEditViewDelegate
- (void)responseToDelete:(id)sender
{
    //禁用按钮
    [_startPintuButton setBackgroundImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateNormal];
    [_startPintuButton setUserInteractionEnabled:YES];
    
    ImageEditView *imageEditView  = (ImageEditView *)sender;
    [imageEditView removeFromSuperview];
    [_imageEditViewArray removeObject:imageEditView];
    [_imageassets removeObjectAtIndex:imageEditView.index];
    [self resetContentView];
}




- (void)resetContentView
{
    for (int i = 0; i < [_imageassets count]; i++) {
        ImageEditView *tempEditView = [_imageEditViewArray objectAtIndex:i];
        tempEditView.index = i;
        [UIView animateWithDuration:0.2
                              delay:0.1
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             tempEditView.frame = CGRectMake(i*(D_ImageEditView_Width+D_Pending_Width)+D_Pending_Width,
                                                             0,
                                                             D_ImageEditView_Width,
                                                             D_ImageEditView_Width);
                         } completion:^(BOOL finished) {
                             
                         }];
        
    }

    CGFloat width = [_imageassets count]*(D_ImageEditView_Width) * 1.8;
    _contentView.contentSize = CGSizeMake(width, _contentView.frame.size.height);
    [self setDeclation];
}


- (void)reMoveAllResource
{
    [self.imageassets removeAllObjects];
    [self.imageEditViewArray removeAllObjects];
    for (UIView *v in  self.contentView.subviews) {
        [v removeFromSuperview];
    }
    [self resetContentView];
}




@end
