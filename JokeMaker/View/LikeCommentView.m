//
//  LikeCommentView.m
//  sister
//
//  Created by Dou, Eddie on 9/10/16.
//  Copyright © 2016 Openlab. All rights reserved.
//

#import "LikeCommentView.h"
#import "MLLinkLabel.h"
#import "MLExpressionManager.h"
#import "CommentItem.h"
#import "MLLabel+Size.h"
#import "AppUtils.h"

#define TopMargin 10
#define BottomMargin 6


#define LikeLabelFont [UIFont boldSystemFontOfSize:14]

#define LikeLabelLineHeight 1.1f

#define LikeIconLeftMargin 8
#define LikeIconTopMargin 14
#define LikeIconSize 15

#define LikeLabelIconSpace 5
#define LikeLabelRightMargin 10
#define HighLightTextColor [UIColor colorWithRed:92/255.0 green:140/255.0 blue:193/255.0 alpha:1.0]

#define CommentLabelFont [UIFont systemFontOfSize:14]

#define CommentLabelLineHeight 1.2f


#define CommentLabelMargin 10

#define LikeCommentSpace 5

#define LinkLabelTag 100

@interface LikeCommentView()


@property (nonatomic, strong) UIImageView *likeCmtBg;

@property (strong, nonatomic) UIImageView *likeIconView;

@property (strong, nonatomic) MLLinkLabel *likeLabel;

@property (strong, nonatomic) UIView *divider;


@property (strong, nonatomic) NSMutableArray *commentLabels;

@end

@implementation LikeCommentView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

       // _commentLabels = [NSMutableArray array];

        [self initView];
    }
    return self;
}


-(void) initView
{
    CGFloat x,y,width,height;

    if (_likeCmtBg == nil) {
        x = 0;
        y = 0;
        width = self.frame.size.width;
        height = self.frame.size.height;

        _likeCmtBg = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        UIImage *image = [UIImage imageNamed:@"LikeCmtBg"];
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(20, 30, 10, 10) resizingMode:UIImageResizingModeStretch];
        _likeCmtBg.image = image;
        [self addSubview:_likeCmtBg];
    }

    if (_likeIconView == nil) {
        x = LikeIconLeftMargin;
        y = LikeIconTopMargin;
        width = LikeIconSize;
        height = width;
        _likeIconView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        _likeIconView.image = [UIImage imageNamed:@"Like"];
        [self addSubview:_likeIconView];
    }


    if (_likeLabel == nil) {

        _likeLabel =[[MLLinkLabel alloc] initWithFrame:CGRectZero];
        _likeLabel.font = LikeLabelFont;
        _likeLabel.numberOfLines = 0;
        _likeLabel.adjustsFontSizeToFitWidth = NO;
        _likeLabel.textInsets = UIEdgeInsetsZero;

        _likeLabel.textColor = HighLightTextColor;
        _likeLabel.dataDetectorTypes = MLDataDetectorTypeAll;
        _likeLabel.allowLineBreakInsideLinks = NO;
        _likeLabel.linkTextAttributes = nil;
        _likeLabel.activeLinkTextAttributes = nil;
        _likeLabel.lineHeightMultiple = LikeLabelLineHeight;
        _likeLabel.linkTextAttributes = @{NSForegroundColorAttributeName: HighLightTextColor};


        [self addSubview:_likeLabel];
    }


    if (_divider == nil) {
        _divider = [[UIView alloc] initWithFrame:CGRectZero];
        _divider.backgroundColor = [UIColor colorWithWhite:225/255.0 alpha:1.0];
        [self addSubview:_divider];
    }
 
}


-(void)layoutSubviews
{
    CGFloat x,y,width,height;
    x = 0;
    y = 0;
    width = self.frame.size.width;
    height = self.frame.size.height;

    _likeCmtBg.frame = CGRectMake(x, y, width, height);

}


+(NSAttributedString *) genLikeAttrString:(Moments *) moment
{
    if (moment.likes.count == 0) {
        return nil;
    }

    NSString *result = @"";

    for (int i=0; i<moment.likes.count;i++) {
        NSString *like = [moment.likes objectAtIndex:i];
        if (i == 0) {
            result = [NSString stringWithFormat:@"%@",like];
        }else{
            result = [NSString stringWithFormat:@"%@, %@", result, like];
        }
    }

    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:result];

    return attrStr;
}


-(void)updateWithItem:(Moments *)moment
{
    CGFloat x, y, width, height;
    _divider.hidden = YES;

    if (moment.likes.count > 0) {

        _likeLabel.hidden = NO;
        _likeIconView.hidden = NO;


        x = CGRectGetMaxX(_likeIconView.frame)+LikeLabelIconSpace;
        y = TopMargin;
        width = self.frame.size.width - x - LikeLabelRightMargin;


        NSAttributedString *attrText = [LikeCommentView genLikeAttrString:moment];

        _likeLabel.attributedText = attrText;

        [_likeLabel sizeToFit];

        CGSize textSize = [MLLinkLabel getViewSize:attrText maxWidth:width font:LikeLabelFont lineHeight:LikeLabelLineHeight lines:0];

        _likeLabel.frame = CGRectMake(x, y, width, textSize.height);
    }else{
        _likeLabel.hidden = YES;
        _likeIconView.hidden = YES;
    }

    //CommentItem Array
    if (moment.comments.count > 0) {

        if (moment.likes.count > 0) {
            //显示分割线
            y = CGRectGetMaxY(_likeLabel.frame) + LikeCommentSpace;
            _divider.hidden = NO;
            _divider.frame = CGRectMake(0, y, self.frame.size.width, 0.5);
        }

        CGFloat sumHeight = TopMargin;

        if (moment.likes.count > 0) {
            sumHeight = CGRectGetMaxY(_likeLabel.frame) + LikeCommentSpace;
        }

        NSUInteger labelCount = _commentLabels.count;

        for (int i=0; i<labelCount; i++) {
            MLLinkLabel *label = [_commentLabels objectAtIndex:i];
            label.attributedText = nil;
            label.frame = CGRectZero;
            label.hidden = !(i<moment.comments.count);
        }

        for (int i=0;i < moment.comments.count;i++) {

            MLLinkLabel *label;

            if ( labelCount > 0 && i < labelCount) {
                label = [_commentLabels objectAtIndex:i];
            }else{
                label = [self createLinkLabel];
                [_commentLabels addObject:label];
                [self addSubview:label];
            }

            CommentItem *commentItem = [moment.comments objectAtIndex:i];

            label.hidden = NO;

            NSAttributedString *str = [MLExpressionManager expressionAttributedStringWithString:[LikeCommentView genCommentAttrString:commentItem] expression:[self sharedMLExpression]];


            label.attributedText = str ;
            [label sizeToFit];

            width = self.frame.size.width - 2*CommentLabelMargin;
            CGSize size = [MLLabel getViewSize:str maxWidth:width font:CommentLabelFont lineHeight:CommentLabelLineHeight lines:0];


            x = CommentLabelMargin;
            y = sumHeight;
            height = size.height;

            sumHeight+=height;

            label.frame = CGRectMake(x, y, width, height);
        }




    }else{

        for (int i=0; i<_commentLabels.count; i++) {
            MLLinkLabel *label = [_commentLabels objectAtIndex:i];
            label.attributedText = nil;
            label.frame = CGRectZero;
            label.hidden = YES;
        }
    }
}


-(MLLinkLabel *) createLinkLabel {
    MLLinkLabel *lable = [[MLLinkLabel alloc] initWithFrame:CGRectZero];

    lable.font = CommentLabelFont;
    lable.numberOfLines = 0;
    lable.adjustsFontSizeToFitWidth = NO;
    lable.textInsets = UIEdgeInsetsZero;

    lable.dataDetectorTypes = MLDataDetectorTypeAll;
    lable.allowLineBreakInsideLinks = NO;
    lable.linkTextAttributes = nil;
    lable.activeLinkTextAttributes = nil;
    lable.lineHeightMultiple = CommentLabelLineHeight;
    lable.linkTextAttributes = @{NSForegroundColorAttributeName: HighLightTextColor};

    return lable;
}

-(MLExpression *)sharedMLExpression
{
    MLExpression * expression = [MLExpression expressionWithRegex:@"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]" plistName:@"Expression" bundleName:@"ClippedExpression"];

    return expression;
}




+(CGFloat)getHeight:(Moments *)item maxWidth:(CGFloat)maxWidth
{
    CGFloat height = TopMargin;

    if (item.likes.count > 0) {

        CGFloat width = maxWidth -  LikeIconLeftMargin - LikeIconSize - LikeLabelIconSpace - LikeLabelRightMargin;

        CGSize textSize = [MLLinkLabel getViewSize:[LikeCommentView genLikeAttrString:item] maxWidth:width font:LikeLabelFont lineHeight:LikeLabelLineHeight lines:0];

        height+= textSize.height;
    }


    if (item.comments.count > 0) {

        CGFloat width = maxWidth - CommentLabelMargin*2;

        NSArray *commentStrArray = item.comments;

        for (CommentItem* item in commentStrArray) {

            CGSize textSize = [MLLinkLabel getViewSize:[LikeCommentView genCommentAttrString:item] maxWidth:width font:CommentLabelFont lineHeight:CommentLabelLineHeight lines:0];
            height+= textSize.height;
        }

        if (item.likes.count > 0) {
            height+= LikeCommentSpace;
        }
    }


    height+=BottomMargin;
    return height;
}



+(NSAttributedString *) genCommentAttrString:(CommentItem *)comment
{
    NSString *resultStr;
    if ([AppUtils isEmptyString: comment.replyUserNick]) {
        resultStr = [NSString stringWithFormat:@"%@: %@",comment.userNick, comment.comment];
    }else{
        resultStr = [NSString stringWithFormat:@"%@回复%@: %@",comment.userNick, comment.replyUserNick, comment.comment];
    }

    NSMutableAttributedString *commentStr = [[NSMutableAttributedString alloc]initWithString:resultStr];
    if ([AppUtils isEmptyString: comment.replyUserNick]) {
        [commentStr addAttribute:NSLinkAttributeName value:comment.userNick range:NSMakeRange(0, comment.userNick.length)];
    }else{
        NSUInteger localPos = 0;
        [commentStr addAttribute:NSLinkAttributeName value:comment.userNick range:NSMakeRange(localPos, comment.userNick.length)];
        localPos += comment.userNick.length + 2;
        [commentStr addAttribute:NSLinkAttributeName value:comment.replyUserNick range:NSMakeRange(localPos, comment.replyUserNick.length)];
    }

    //NSLog(@"ffff: %@", resultStr);

    return commentStr;
}




@end
