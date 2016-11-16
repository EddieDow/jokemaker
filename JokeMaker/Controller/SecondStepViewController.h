//
//  SecondStepViewController.h
//  sister
//
//  Created by Dou, Eddie on 9/11/16.
//  Copyright © 2016 Openlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Moments.h"

@interface SecondStepViewController : UIViewController <UITextViewDelegate>{
    NSString *hint;
}


@property (nonatomic, strong) IBOutlet UITextView *textView;
@property (nonatomic, strong) IBOutlet UIView *parentView;


@end
