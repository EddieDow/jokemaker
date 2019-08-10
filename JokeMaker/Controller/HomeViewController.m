//
//  HomeViewController.m
//  sister
//
//  Created by Dou, Eddie on 9/11/16.
//  Copyright © 2016 Openlab. All rights reserved.
//

#import "HomeViewController.h"
#import "BButton.h"
#import "FirstStepViewController.h"
#import "Moments.h"
#import "UIColor+Help.h"
#import "AutoSlideScrollView.h"
#import "jokermaker-Swift.h"


static const NSInteger kTotalPageCount = 2;

@interface HomeViewController () {
    CGFloat screenWidth;
    CGFloat screenHeight;
}

@property (nonatomic , strong) AutoSlideScrollView *mainScorllView;

@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleButton setBackgroundColor:[UIColor clearColor]];
    [titleButton setFrame:(CGRect){0,0,100,44}];
    [titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [titleButton setContentEdgeInsets:UIEdgeInsetsMake(-2, 0, 0, 0)];
    [titleButton setTitle:@"段子手神器" forState:UIControlStateNormal];
    [titleButton.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [titleButton.titleLabel setShadowOffset:(CGSize){1,1}];
    [self.navigationItem setTitleView:titleButton];

    screenWidth = [UIScreen mainScreen].bounds.size.width;
    screenHeight = [UIScreen mainScreen].bounds.size.height;


    NSMutableArray *viewsArray = [@[] mutableCopy];
    NSArray *colorArray = @[@"sample1.jpg",@"sample2.jpg"];
    for (int i = 0; i < kTotalPageCount; ++i) {
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-200)];
        image.contentMode = UIViewContentModeScaleAspectFit;
        image.image = [UIImage imageNamed:[colorArray objectAtIndex:i]];
        [viewsArray addObject:image];
    }

    self.mainScorllView = [[AutoSlideScrollView alloc] initWithFrame:CGRectMake(0, 60, screenWidth, screenHeight-200) animationDuration:3];
    //self.mainScorllView.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:0.1];

    self.mainScorllView.totalPagesCount = ^NSInteger(void){
        return viewsArray.count;
    };
    self.mainScorllView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
        return viewsArray[pageIndex];
    };
    self.mainScorllView.TapActionBlock = ^(NSInteger pageIndex){
        //NSLog(@"点击了第%ld个",pageIndex);
    };
    [self.view addSubview:self.mainScorllView];

    [self creatSuspendBtn];
    
    //sample reels
    UIButton *morebutton = [UIButton buttonWithType:UIButtonTypeCustom];
    morebutton.frame = CGRectMake(0, 5,28, 28);
    [morebutton setTitle:@"作品集" forState: UIControlStateNormal];
    [morebutton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    morebutton.titleLabel.font = [UIFont systemFontOfSize: 15.0];
    [morebutton addTarget:self action:@selector(openSamplesPage) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:morebutton];
}

-(void)openSamplesPage {
    RecordsViewController *recordsVC = [[RecordsViewController alloc] init];
    [self.navigationController pushViewController:recordsVC animated:true];
}

-(void)creatSuspendBtn {
    _button = [APRoundedButton buttonWithType:UIButtonTypeCustom];

    _button.frame = CGRectMake(0,0, 180, 45);
    [_button addTarget:self action:@selector(suspendBtnClick) forControlEvents:UIControlEventTouchUpInside];

    UIFont *font = [UIFont fontWithName:@"Avenir-Black" size:18.0];
    UIColor *btnTitleColor = [UIColor colorWithHexString:@"#eb5350"];
    [_button setBackgroundColor:btnTitleColor];
    [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _button.titleLabel.font = font;
    [_button setTitle:@"开始制作" forState:UIControlStateNormal];

    _button.frame = CGRectMake(screenWidth*0.5-90, screenHeight-100, 180, 45);
    [_button addTarget:self action:@selector(suspendBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button];
    [self.view bringSubviewToFront:_button];



}

-(void) suspendBtnClick {
    [self startProduce];
}



-(void) startProduce {

    FirstStepViewController *vc = [[FirstStepViewController alloc] initWithNibName:@"FirstStepViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:vc animated:true];
}

@end
