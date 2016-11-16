//
//  SecondStepViewController.m
//  sister
//
//  Created by Dou, Eddie on 9/11/16.
//  Copyright © 2016 Openlab. All rights reserved.
//

#import "SecondStepViewController.h"
#import "ResultViewController.h"
#import "ImageAddPreView.h"
#import "DNImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "DNAsset.h"
#import "AppUtils.h"
#import "ThirdStepViewController.h"

@interface SecondStepViewController ()<ImageAddPreViewDelegate,DNImagePickerControllerDelegate>{
    ImageAddPreView *imageSetPreview;
}


@end

@implementation SecondStepViewController




- (void)viewDidLoad
{
    [super viewDidLoad];

    UIButton *morebutton = [UIButton buttonWithType:UIButtonTypeCustom];
    morebutton.frame = CGRectMake(0, 5,28, 28);
    [morebutton setBackgroundImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
    [morebutton addTarget:self action:@selector(nextStep) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:morebutton];

    UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleButton setBackgroundColor:[UIColor clearColor]];
    [titleButton setFrame:(CGRect){0,0,100,44}];
    [titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [titleButton setContentEdgeInsets:UIEdgeInsetsMake(-2, 0, 0, 0)];
    [titleButton setTitle:@"第二步" forState:UIControlStateNormal];
    [titleButton.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [titleButton.titleLabel setShadowOffset:(CGSize){1,1}];
    [self.navigationItem setTitleView:titleButton];

    _textView.delegate  = self;
    self.textView.font = [UIFont systemFontOfSize:17.0];

    hint = @"说点什么...";
    if([AppUtils isEmptyString:[AppUtils getMom].content]) {
        self.textView.text = hint;
        self.textView.textColor = [UIColor grayColor];
    } else {
        self.textView.text = [AppUtils getMom].content;
    }


    [self addImagePreviewView];
}

-(void) nextStep {
    if([AppUtils isEmptyString:self.textView.text ] || [self.textView.text isEqualToString: hint]) {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"提醒"
                                              message:@"内容不能为空~"
                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:@"确定"
                                       style:UIAlertActionStyleCancel
                                       handler:nil];

        
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    [AppUtils getMom].arrImage = [imageSetPreview imageassets];

    [AppUtils getMom].content = self.textView.text;


    ThirdStepViewController *vc = [[ThirdStepViewController alloc] initWithNibName:@"ThirdStepViewController" bundle:[NSBundle mainBundle]];

    [self.navigationController pushViewController:vc animated:true];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:hint]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; 
    }
    [textView becomeFirstResponder];
}



- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = hint;
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
}

-(void) addImagePreviewView {
    imageSetPreview = [[ImageAddPreView alloc] initWithFrame:CGRectMake(0,  10, self.parentView.frame.size.width, self.parentView.frame.size.height-20)];
    [self.parentView addSubview:imageSetPreview];
    [imageSetPreview setAlpha:0];
    [UIView animateWithDuration:0.5
                          delay:0.1
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [imageSetPreview setAlpha:1];
                     } completion:^(BOOL finished) {

                     }];
    [imageSetPreview setHidden:NO];
    imageSetPreview.maxSelected = 9;
   // imageSetPreview.minSelected = 0;
    imageSetPreview.delegateSelectImage = self;
    [imageSetPreview reMoveAllResource];

    if (![AppUtils isEmpty:[AppUtils getMom].arrImage]) {
        for (UIImage *image in [AppUtils getMom].arrImage) {
            [imageSetPreview addImageWith:image isJoin:true];
        }
    }
}

- (void)startPintuAction:(ImageAddPreView *)sender {
    [self launchGMImagePicker];
}

- (void)dnImagePickerController:(DNImagePickerController *)imagePickerController sendImages:(NSArray *)imageAssets isFullImage:(BOOL)fullImage
{

    for(NSInteger i = 0; i < imageAssets.count; i++) {
        DNAsset * dnasset = imageAssets[i];

        ALAssetsLibrary *lib = [ALAssetsLibrary new];
        [lib assetForURL:dnasset.url resultBlock:^(ALAsset *asset){
            if (asset) {

                UIImage *img = [AppUtils getImage:asset isFullImage:fullImage];
                [imageSetPreview addImageWith:img isJoin:true];
            } else {
                // On iOS 8.1 [library assetForUrl] Photo Streams always returns nil. Try to obtain it in an alternative way
                [lib enumerateGroupsWithTypes:ALAssetsGroupPhotoStream
                                   usingBlock:^(ALAssetsGroup *group, BOOL *stop)
                 {
                     [group enumerateAssetsWithOptions:NSEnumerationReverse
                                            usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {

                                                if([[result valueForProperty:ALAssetPropertyAssetURL] isEqual:dnasset.url])
                                                {
                                                    UIImage *img = [AppUtils getImage:asset isFullImage:fullImage];
                                                    [imageSetPreview addImageWith:img isJoin:true];
                                                }
                                            }];
                 }
                                 failureBlock:nil];
            }
            
        } failureBlock:^(NSError *error){
            
        }];
    }

    NSString *str = [NSString stringWithFormat:@"请选择 0-%lu 张图片", 9 - [imageSetPreview.imageassets count] ];
    if ([imageSetPreview.imageassets count] == 9) {
        str = @"请选择 0 张图片";
    }
    imageSetPreview.selectBeforeLab.text = str;
}

- (void)dnImagePickerControllerDidCancel:(DNImagePickerController *)imagePicker
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)launchGMImagePicker
{
    DNImagePickerController *imagePicker = [[DNImagePickerController alloc] init];
    imagePicker.imagePickerDelegate = self;
    imagePicker.maxSelected = 9;
    [self presentViewController:imagePicker animated:YES completion:nil];
}



@end
