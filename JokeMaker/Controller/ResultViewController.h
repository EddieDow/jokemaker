//
//  ResultViewController.h
//  sister
//
//  Created by Dou, Eddie on 9/11/16.
//  Copyright © 2016 Openlab. All rights reserved.
//

#import "Moments.h"
#import "APRoundedButton.h"

@interface ResultViewController : UIViewController<UIActionSheetDelegate> {
    int screenHeight;
    int screenWidth;
}

@property (nonatomic, strong) UIWindow *window;
 
@property (nonatomic, strong) UIButton *button;

@end
