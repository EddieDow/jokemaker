//
//  ResultViewController.m
//  sister
//
//  Created by Dou, Eddie on 9/11/16.
//  Copyright © 2016 Openlab. All rights reserved.
//

#import "ResultViewController.h"

#import "HomeViewController.h"
#import "AppUtils.h"
#import "MLLinkLabel.h"
#import "MLLabel+Size.h"
#import "MLExpressionManager.h"
#import "LikeCommentView.h"
#import "CommentItem.h"
#import "Moments.h"
#import "GridImageView.h"
#import "MBProgressHUD.h"
#import <QuartzCore/QuartzCore.h>
#import "JTSImageViewController.h"
#import "LPScrollFullScreen.h"
#import "UIColor+Help.h"
#import "FFToast.h"

#define UserNickFont [UIFont boldSystemFontOfSize:18]
#define TitleLabelFont [UIFont systemFontOfSize:13]

#define LocationLabelFont [UIFont systemFontOfSize:14]

#define TimeLabelFont [UIFont systemFontOfSize:13]

#define TextFont [UIFont systemFontOfSize:16]

#define TextLineHeight 1.2f

#define TextImageSpace 15

#define GridMaxWidth (BodyMaxWidth)*0.85

#define Margin 10

#define Padding 10

#define UserAvatarSize 40

#define  BodyMaxWidth [UIScreen mainScreen].bounds.size.width - UserAvatarSize - 3*Margin

#define UserNickMaxWidth 150

#define LocationLabelHeight 15

#define TimeLabelHeight 15

#define UserNickLineHeight 1.0f

#define HighLightTextColor [UIColor colorWithRed:92/255.0 green:140/255.0 blue:193/255.0 alpha:1.0]

#define LikeLabelFont [UIFont systemFontOfSize:14]

#define LikeLabelLineHeight 1.1f

#define LikeCommentTimeSpace 3

#define ToolbarWidth 150
#define ToolbarHeight 30

@interface ResultViewController () {
    Moments *moment;
    UIView *mainView;
    UIImageView *localImageView;
    BOOL isSaved;
}

@property (nonatomic, strong) UIImageView *userAvatarView;
@property (nonatomic, strong) MLLinkLabel *userNickLabel;
@property (nonatomic, strong) UIView *bodyView;
@property (strong, nonatomic) MLLinkLabel *textContentLabel;
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *likeCmtButton;
@property (nonatomic, strong) LikeCommentView *likeCommentView;
@property (strong, nonatomic) GridImageView *gridImageView;


@end

@implementation ResultViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    isSaved = false;
    moment = [AppUtils getMom];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.extendedLayoutIncludesOpaqueBars = YES;

    self.view.backgroundColor = [UIColor whiteColor];
    screenHeight = self.view.frame.size.height;
    screenWidth = self.view.frame.size.width;
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenWidth-60, 30)];
    customLab.textAlignment = NSTextAlignmentCenter;
    [customLab setTextColor:[UIColor blackColor]];
    customLab.font = [UIFont boldSystemFontOfSize:20];
    customLab.backgroundColor= [UIColor clearColor];
    [customLab setText: @"完成"];
    self.navigationItem.titleView = customLab;

    UIButton *morebutton = [UIButton buttonWithType:UIButtonTypeCustom];
    morebutton.frame = CGRectMake(0, 5,28, 28);
    [morebutton setBackgroundImage:[UIImage imageNamed:@"icon_more.png"] forState:UIControlStateNormal];
    [morebutton addTarget:self action:@selector(moreAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:morebutton];

    mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, screenWidth, [self getHeight:moment])];
    mainView.backgroundColor = [UIColor whiteColor];

    [self setContent];

    [self performSelector:@selector(takeScreenshot) withObject:nil afterDelay:0.5];
    [self performSelector:@selector(creatSuspendBtn) withObject:nil afterDelay:1.5];
}

- (void)someBigImage:(UIImageView *)imageView {
    // Create image info
    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
    imageInfo.image = imageView.image;
    imageInfo.referenceRect = imageView.frame;
    imageInfo.referenceView = imageView.superview;

    // Setup view controller
    JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
                                           initWithImageInfo:imageInfo
                                           mode:JTSImageViewControllerMode_Image
                                           backgroundStyle:JTSImageViewControllerBackgroundOption_Scaled];

    // Present the view controller.
    [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOriginalPosition];
}

-(void) takeScreenshot {
    UIImage *localImage = [AppUtils imageWithView:mainView];
    localImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    localImageView.image = localImage;
    localImageView.contentMode = UIViewContentModeScaleAspectFit;
    localImageView.userInteractionEnabled = true;
    [mainView removeFromSuperview];
    UITapGestureRecognizer *tap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(someBigImageButtonTapped:)];
    [localImageView addGestureRecognizer:tap];
    [self.view addSubview:localImageView];
}

- (void)someBigImageButtonTapped:(id)sender {
    [self someBigImage: localImageView];
}

-(void) setContent {
    CGFloat x = 0.0, y, width, height = 0.0;
    y = 5.0;
    if (_userAvatarView == nil ) {

        x = Margin;
        y += Margin;
        width = UserAvatarSize;
        height = width;
        _userAvatarView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        _userAvatarView.backgroundColor = [UIColor lightGrayColor];
        _userAvatarView.contentMode = UIViewContentModeScaleAspectFill;
        [_userAvatarView setClipsToBounds:YES];
        [mainView addSubview:_userAvatarView];
        _userAvatarView.image = moment.avatar;
    }

    if (_userNickLabel == nil) {
        _userNickLabel =[[MLLinkLabel alloc] initWithFrame:CGRectZero];
        _userNickLabel.textColor = HighLightTextColor;
        _userNickLabel.font = UserNickFont;
        _userNickLabel.numberOfLines = 1;
        _userNickLabel.adjustsFontSizeToFitWidth = NO;
        _userNickLabel.textInsets = UIEdgeInsetsZero;
        _userNickLabel.dataDetectorTypes = MLDataDetectorTypeAll;
        _userNickLabel.allowLineBreakInsideLinks = NO;
        _userNickLabel.linkTextAttributes = nil;
        _userNickLabel.activeLinkTextAttributes = nil;
        _userNickLabel.lineHeightMultiple = UserNickLineHeight;
        [mainView addSubview:_userNickLabel];
    }

    if (_bodyView == nil) {
        x = CGRectGetMaxX(_userAvatarView.frame) + Margin;
        y += 25.0;
        width = BodyMaxWidth;
        _bodyView = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        [mainView addSubview:_bodyView];
    }

    if (_textContentLabel == nil) {

        _textContentLabel =[[MLLinkLabel alloc] initWithFrame:CGRectZero];
        _textContentLabel.font = TextFont;
        _textContentLabel.numberOfLines = 0;
        _textContentLabel.adjustsFontSizeToFitWidth = NO;
        _textContentLabel.textInsets = UIEdgeInsetsZero;

        _textContentLabel.dataDetectorTypes = MLDataDetectorTypeAll;
        _textContentLabel.allowLineBreakInsideLinks = NO;
        _textContentLabel.linkTextAttributes = nil;
        _textContentLabel.activeLinkTextAttributes = nil;
        _textContentLabel.lineHeightMultiple = TextLineHeight;
        _textContentLabel.linkTextAttributes = @{NSForegroundColorAttributeName: HighLightTextColor};

        [self.bodyView addSubview:_textContentLabel];
    }

    if (_gridImageView == nil) {
        CGFloat x, y , width, height;

        x = 0;
        y = 0;
        width = GridMaxWidth;
        height = width;

        _gridImageView = [[GridImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        [self.bodyView addSubview:_gridImageView];
    }

    if (_locationLabel == nil) {
        _locationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _locationLabel.textColor = [UIColor colorWithRed:35/255.0 green:83/255.0 blue:120/255.0 alpha:1.0];
        _locationLabel.font = LocationLabelFont;
        _locationLabel.hidden = YES;
        [mainView addSubview:_locationLabel];
    }

    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.textColor = [UIColor lightGrayColor];
        _timeLabel.font = TimeLabelFont;
        _timeLabel.hidden = YES;
        [mainView addSubview:_timeLabel];
    }

    if (_likeCmtButton == nil) {
        _likeCmtButton = [[UIButton alloc] initWithFrame:CGRectZero];
        _likeCmtButton.hidden = YES;
        [_likeCmtButton setImage:[UIImage imageNamed:@"AlbumOperateMore"] forState:UIControlStateNormal];
        [mainView addSubview:_likeCmtButton];
    }

    if (_likeCommentView == nil) {
        y = 0;
        width = BodyMaxWidth;
        height = 10;
        _likeCommentView = [[LikeCommentView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        [mainView addSubview:_likeCommentView];
    }

    [self setFrameOfElements];
}

-(void) setFrameOfElements {
    CGFloat x = 0.0, y, width, height;
    NSAttributedString *userNick  = [[NSAttributedString alloc] initWithString:moment.userName];

    CGSize textSize = [MLLinkLabel getViewSize:userNick maxWidth:UserNickMaxWidth font:UserNickFont lineHeight:UserNickLineHeight lines:1];


    x = CGRectGetMaxX(_userAvatarView.frame) + Margin;
    y = CGRectGetMinY(_userAvatarView.frame) +2;
    width = textSize.width;
    height = textSize.height;

    _userNickLabel.frame = CGRectMake(x, y, width, height);
    _userNickLabel.attributedText = userNick;

    NSAttributedString *attrText = [MLExpressionManager expressionAttributedStringWithString:moment.content expression:[self sharedMLExpression]];
    textSize = [MLLinkLabel getViewSize:attrText maxWidth:BodyMaxWidth font:TextFont lineHeight:TextLineHeight lines:0];

    _textContentLabel.attributedText = attrText;
    [_textContentLabel sizeToFit];

    _textContentLabel.frame = CGRectMake(0, 0, BodyMaxWidth, textSize.height);

    CGFloat gridHeight = [GridImageView getHeight:moment.arrImage maxWidth:GridMaxWidth oneImageWidth:120 oneImageHeight:120];

    x = _gridImageView.frame.origin.x;
    y = CGRectGetMaxY(_textContentLabel.frame)+TextImageSpace;
    width = _gridImageView.frame.size.width;
    height = gridHeight;
    _gridImageView.frame = CGRectMake(x, y, width, height);

    [_gridImageView updateWithImages:moment.arrImage oneImageWidth:120 oneImageHeight:120];

    [self updateBodyView:(textSize.height+gridHeight+TextImageSpace)];
}

-(void)updateBodyView:(CGFloat) height
{
    CGFloat x, y, width;
    x = _bodyView.frame.origin.x;
    y = _bodyView.frame.origin.y;
    width = _bodyView.frame.size.width;
    height = height;
    _bodyView.frame = CGRectMake(x, y, width, height);

    [self updateLocationLikeComment:height];
}

-(void) updateLocationLikeComment:(CGFloat)height {
    CGFloat x, y, width, sumHeight=0.0;

    x = _bodyView.frame.origin.x;
    y = _bodyView.frame.origin.y;
    width = _bodyView.frame.size.width;

    //位置
    NSString *location = moment.location;
    if (location != nil && ![location isEqualToString:@""]) {
        y = CGRectGetMaxY(_bodyView.frame) + Padding;
        height = LocationLabelHeight;
        _locationLabel.hidden = NO;
        _locationLabel.frame = CGRectMake(x, y, width, height);
        _locationLabel.text = location;

        sumHeight+=LocationLabelHeight+Padding;

    }else{
        _locationLabel.hidden = YES;
    }

    //时间
    y = CGRectGetMaxY(_bodyView.frame) + sumHeight + Padding;
    width = 200;
    height = TimeLabelHeight;
    _timeLabel.hidden = NO;
    _timeLabel.frame = CGRectMake(x, y, width, height);
    _timeLabel.text = moment.time;

    //点赞评论按钮
    width = 25;
    height = 25;
    x = CGRectGetMaxX(_bodyView.frame) - width;
    _likeCmtButton.hidden = NO;
    _likeCmtButton.frame = CGRectMake(x+2, y-7, width, height);

    if (moment.likes.count ==0 && moment.comments.count == 0) {

        _likeCommentView.hidden = YES;
    }else{
        _likeCommentView.hidden = NO;

        x = CGRectGetMinX(_timeLabel.frame);
        y = CGRectGetMaxY(_timeLabel.frame)+LikeCommentTimeSpace;
        width = _likeCommentView.frame.size.width;
        height = [LikeCommentView getHeight:moment maxWidth:BodyMaxWidth];
        _likeCommentView.frame = CGRectMake(x, y, width, height);
        [_likeCommentView updateWithItem:moment];
    }
}

-(MLExpression *)sharedMLExpression {
    MLExpression * expression = [MLExpression expressionWithRegex:@"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]" plistName:@"Expression" bundleName:@"ClippedExpression"];

    return expression;
}

-(CGFloat)getHeight:(Moments *)item {
    //basic
    CGFloat height = Margin + UserAvatarSize;

    //location
    if (item.location != nil && ![item.location isEqualToString:@""]) {
        height+=LocationLabelHeight+Padding;
    }

    //time
    height+= TimeLabelHeight + Padding;

    //comment
    if (!(item.likes.count == 0 && item.comments.count == 0)) {
        height+=[LikeCommentView getHeight:item maxWidth:BodyMaxWidth]+LikeCommentTimeSpace;
    }

    MLExpression * expression = [MLExpression expressionWithRegex:@"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]" plistName:@"Expression" bundleName:@"ClippedExpression"];
    NSAttributedString *attrText = [MLExpressionManager expressionAttributedStringWithString:item.content expression:expression];

    CGSize textSize = [MLLinkLabel getViewSize: attrText maxWidth:BodyMaxWidth font:TextFont lineHeight:TextLineHeight lines:0];


    CGFloat gridHeight = [GridImageView getHeight:item.arrImage maxWidth:GridMaxWidth oneImageWidth:120 oneImageHeight:120];

    return height+textSize.height + gridHeight+TextImageSpace;
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error == nil) {
        [self customViewContent:@"保存成功"];
    }else{
        [self customViewContent:@"保存失败"];
    }
}

- (void)customViewContent:(NSString *)message  {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];

    // Set the custom view mode to show any view.
    hud.mode = MBProgressHUDModeCustomView;
    // Set an image view with a checkmark.
    UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    hud.customView = [[UIImageView alloc] initWithImage:image];
    // Looks a bit nicer if we make it square.
    hud.square = YES;
    // Optional label text.
    hud.label.text = message;
    [hud hideAnimated:YES afterDelay:1.5f];
}


- (void)moreAction{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"分享",@"保存图片", @"保存作品", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NSArray *activityItems = @[localImageView.image];

        UIActivityViewController *activityController =
        [[UIActivityViewController alloc] initWithActivityItems:activityItems
                                          applicationActivities:nil];

        [self presentViewController:activityController
                           animated:YES completion:nil];
    } else if (buttonIndex == 1) {
        [self saveImage];
    } else if (buttonIndex == 2) {
        [self saveMoments];
    }
}

//Move to a special class
-(void) saveMoments {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:false];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = @"保存中...";
    Moments *mom = AppUtils.getMom;
    mom.product = localImageView.image;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [AppUtils saveIntoPresistentLayer:mom];
        dispatch_async(dispatch_get_main_queue(), ^{
        [hud hideAnimated:YES];
        [FFToast showToastWithTitle:@"提示" message:@"作品已经保存成功，请勿成功保存." iconImage:[UIImage imageNamed:@"fftoast_success_highlight.png"] duration:3 toastType:FFToastTypeDefault];
        });
    });
    
//    [hud hideAnimated:YES];
}

-(void) saveImage {
    isSaved = true;
    UIImageWriteToSavedPhotosAlbum(localImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);

}

-(void)creatSuspendBtn{
    _button = [APRoundedButton buttonWithType:UIButtonTypeCustom];

    _button.frame = CGRectMake(0,0, 180, 45);
    [_button addTarget:self action:@selector(suspendBtnClick) forControlEvents:UIControlEventTouchUpInside];

    UIFont *font = [UIFont fontWithName:@"Avenir-Black" size:18.0];
    UIColor *btnTitleColor = [UIColor colorWithHexString:@"#eb5350"];
    [_button setBackgroundColor:btnTitleColor];
    [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _button.titleLabel.font = font;
    [_button setTitle:@"再来一张" forState:UIControlStateNormal];

    _button.frame = CGRectMake(screenWidth*0.5-90, screenHeight-74, 180, 45);
    [_button addTarget:self action:@selector(suspendBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button];
    [self.view bringSubviewToFront:_button];
}

-(void) suspendBtnClick {
    if (!isSaved) {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"提醒"
                                              message:@"图片还没有保存，放弃保存开始制作新的一张吗？"
                                              preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *confirmAction = [UIAlertAction
                                       actionWithTitle:@"确定"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * _Nonnull action) {
                                           [self popToRoot];
                                       }];


        [alertController addAction:confirmAction];

        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:@"取消"
                                       style:UIAlertActionStyleCancel
                                       handler:nil];


        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }

    [self popToRoot];
}

-(void)popToRoot {
    [self.navigationController popToRootViewControllerAnimated:true];
}

@end
