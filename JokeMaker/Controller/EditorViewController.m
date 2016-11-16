//
//  EditorViewController.m
//  sister
//
//  Created by Dou, Eddie on 9/12/16.
//  Copyright © 2016 Openlab. All rights reserved.
//

#import "EditorViewController.h"

@interface EditorViewController ()

@end

@implementation EditorViewController

- (void)viewDidLoad {
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
    [titleButton setTitle:self.title forState:UIControlStateNormal];
    [titleButton.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [titleButton.titleLabel setShadowOffset:(CGSize){1,1}];
    [self.navigationItem setTitleView:titleButton];

    self.editor.text = self.hint;
    self.editor.delegate = self;
    self.editor.font = [UIFont systemFontOfSize:16.0];

    if([self.hint isEqualToString:@"点击编辑"]) {
        self.editor.textColor = [UIColor grayColor];
    } else {
        self.editor.textColor = [UIColor blackColor];
    }
    [self.editor becomeFirstResponder];
}

- (void)nextStep {
    [self resultEditted:self.editor.text];
}

-(void) resultEditted:(NSString *) result {
    [self.delegate resultEditted:result  title:self.title];
    [self.navigationController popViewControllerAnimated:true];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"点击编辑"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"点击编辑"]) {
        textView.text = self.hint;
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
}

@end
