//
//  ImageEditView.h
//  PTPaiPaiCamera
//
//  Created by eddie on 1/26/15.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>


@protocol ImageEditViewDelegate;
@interface ImageEditView : UIView

@property (nonatomic, strong) UIImageView   *imageView;
@property (nonatomic, strong) UIButton      *deleteButton;
@property (nonatomic, strong) UIImage       *asset;
@property (nonatomic, assign) NSInteger     index;
@property (nonatomic, weak)   id<ImageEditViewDelegate> deleteEdit;

- (void)setImageAsset:(UIImage *)asset index:(NSInteger)index;

@end

@protocol ImageEditViewDelegate <NSObject>

- (void)responseToDelete:(id)sender;

@end
