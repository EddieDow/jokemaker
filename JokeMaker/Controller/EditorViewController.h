//
//  EditorViewController.h
//  sister
//
//  Created by Dou, Eddie on 9/12/16.
//  Copyright © 2016 Openlab. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ResultEditted <NSObject>

-(void) resultEditted:(NSString *) result title:(NSString *)title;

@end

@interface EditorViewController : UIViewController<UITextViewDelegate>

@property (nonatomic, strong) IBOutlet UITextView *editor;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *hint;

@property (weak) id<ResultEditted> delegate;

@end
