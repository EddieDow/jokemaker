//
//  ImageAddPreView.h
//  PTPaiPaiCamera
//
//  Created by eddie on 1/26/15.
//

#import <UIKit/UIKit.h>
#import "ImageEditView.h"

@protocol  ImageAddPreViewDelegate;
@interface ImageAddPreView : UIView<ImageEditViewDelegate>

@property (nonatomic, strong) UILabel           *selectBeforeLab;

@property(assign) NSInteger minSelected;
@property(assign) NSInteger maxSelected;

@property (nonatomic, strong) UIButton          *startPintuButton;
@property (nonatomic, strong) UIScrollView      *contentView;
@property (nonatomic, weak)   id<ImageAddPreViewDelegate> delegateSelectImage;
@property (nonatomic, strong) NSMutableArray    *imageassets;
@property (nonatomic, strong) NSMutableArray    *imageEditViewArray;

- (void)addImageWith:(UIImage *)asset isJoin:(BOOL) flag;
- (void)reMoveAllResource;
- (void) setDeclation;
@end


@protocol  ImageAddPreViewDelegate <NSObject>

- (void)startPintuAction:(ImageAddPreView *)sender;
@end
