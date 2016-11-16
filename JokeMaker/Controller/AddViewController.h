//
//  AddViewController.h
//  sister
//
//  Created by Dou, Eddie on 9/17/16.
//  Copyright © 2016 Openlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentItem.h"

@protocol CommentEdittedDelegate <NSObject>

-(void) commentEditted:(CommentItem *) item;

@end

@interface AddViewController : UIViewController

@property (nonatomic, strong) IBOutlet UITextView *nickName;
@property (nonatomic, strong) IBOutlet UITextView *replyNickName;
@property (nonatomic, strong) IBOutlet UITextView *comment;

@property (weak) id<CommentEdittedDelegate> delegate;
@property (nonatomic, strong) CommentItem *item;


@end
