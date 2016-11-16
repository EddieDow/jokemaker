//
//  AppDelegate.h
//  JokeMaker
//
//  Created by Dou, Eddie on 11/17/16.
//  Copyright © 2016 GuDuTou. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "MSNavigationSwipeController.h"

@interface AppDelegate : NSObject <UIApplicationDelegate> {

}


@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet MSNavigationSwipeController *navigationController;

@end

