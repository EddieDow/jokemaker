//
//  AddViewController.m
//  sister
//
//  Created by Dou, Eddie on 9/17/16.
//  Copyright © 2016 Openlab. All rights reserved.
//

#import "AddViewController.h"
#import "AppUtils.h"

@interface AddViewController ()

@end

@implementation AddViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    UIButton *morebutton = [UIButton buttonWithType:UIButtonTypeCustom];
    morebutton.frame = CGRectMake(0, 5,28, 28);
    [morebutton setBackgroundImage:[UIImage imageNamed:@"Checkmark.png"] forState:UIControlStateNormal];
    [morebutton addTarget:self action:@selector(nextStep) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:morebutton];

    UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleButton setBackgroundColor:[UIColor clearColor]];
    [titleButton setFrame:(CGRect){0,0,100,44}];
    [titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [titleButton setContentEdgeInsets:UIEdgeInsetsMake(-2, 0, 0, 0)];
    [titleButton setTitle:@"添加评论" forState:UIControlStateNormal];
    [titleButton.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [titleButton.titleLabel setShadowOffset:(CGSize){1,1}];
    [self.navigationItem setTitleView:titleButton];

    [self setBorder:self.nickName];
    [self setBorder:self.replyNickName];
    [self setBorder:self.comment];

    if (![AppUtils isEmpty:self.item]) {
        self.nickName.text = self.item.userNick;
        self.replyNickName.text = self.item.replyUserNick;
        self.comment.text = self.item.comment;
    }


}

-(void) setBorder:(UITextView *)textview {
    textview.layer.backgroundColor = [[UIColor clearColor] CGColor];

    textview.layer.borderColor = [[UIColor grayColor]CGColor];
    textview.layer.borderWidth = 0.5;
    textview.layer.cornerRadius = 4.0f;
    [textview.layer setMasksToBounds:YES];
}

-(void)showAlert:(NSString *)message {
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"提醒"
                                          message: message
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"取消"
                                   style:UIAlertActionStyleCancel
                                   handler:nil];


    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void) nextStep {
    if ([AppUtils isEmptyString:self.nickName.text]) {
        [self showAlert:@"用户昵称不能为空~"];
        return;
    }

    if ([AppUtils isEmptyString:self.comment.text]) {
        [self showAlert:@"评论内容不能为空~"];
        return;
    }

    if ([AppUtils isEmpty:self.item]) {
        self.item = [[CommentItem alloc] init];
    }
    
    self.item.userNick = self.nickName.text;
    self.item.replyUserNick = self.replyNickName.text;
    self.item.comment = self.comment.text;

    [self.delegate commentEditted:self.item];
    [self.navigationController popViewControllerAnimated:true];
}

@end
