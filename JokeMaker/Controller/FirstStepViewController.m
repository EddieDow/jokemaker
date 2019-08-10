//
//  FirstStepViewController.m
//  sister
//
//  Created by Dou, Eddie on 9/11/16.
//  Copyright © 2016 Openlab. All rights reserved.
//

#import "FirstStepViewController.h"
#import "SecondStepViewController.h"
#import "Moments.h"
#import "AppUtils.h"
#import "SimpleEditViewCell.h"
#import "EditorViewController.h"
#import "VerticalTableViewCell.h"
#import "DNImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "DNAsset.h"

@interface FirstStepViewController() <DNImagePickerControllerDelegate>{
    Moments *moment;
}
@end

@implementation FirstStepViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    moment = [[Moments alloc] init];

    moment.avatar = [UIImage imageNamed:@"Avatar.png"];
    [AppUtils setMoment:moment];
    UIButton *morebutton = [UIButton buttonWithType:UIButtonTypeCustom];
    morebutton.frame = CGRectMake(0, 5,28, 28);
    [morebutton setBackgroundImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
    [morebutton addTarget:self action:@selector(nextStep) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:morebutton];

    UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleButton setBackgroundColor:[UIColor clearColor]];
    [titleButton setFrame:(CGRect){0,0,100,44}];
    [titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [titleButton setContentEdgeInsets:UIEdgeInsetsMake(-2, 0, 0, 0)];
    [titleButton setTitle:@"第一步" forState:UIControlStateNormal];
    [titleButton.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [titleButton.titleLabel setShadowOffset:(CGSize){1,1}];
    [self.navigationItem setTitleView:titleButton];

    

    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 90.0;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    [self.tableView registerNib:[UINib nibWithNibName:@"SimpleEditViewCell" bundle:nil]
         forCellReuseIdentifier:@"SipleEditCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"VerticalTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"VerticalTableCell"];
}

-(void) nextStep {
    if([AppUtils isEmptyString:moment.userName ]) {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"提醒"
                                              message:@"昵称不能为空~"
                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:@"确定"
                                       style:UIAlertActionStyleCancel
                                       handler:nil];


        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }


    SecondStepViewController *vc = [[SecondStepViewController alloc] initWithNibName:@"SecondStepViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:vc animated:true];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0) {
        return 4;
    }
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0 ) {
        NSString *title = [self getTitleSection:indexPath.section row:indexPath.row];
        NSString *result = [self getResultSection:indexPath.section row:indexPath.row];
        if (indexPath.row > 0 && indexPath.row < 4) {
            SimpleEditViewCell *cell = (SimpleEditViewCell *)[tableView dequeueReusableCellWithIdentifier:@"SipleEditCell"];
            cell.nameLabel.text = title;
            cell.resultLabel.text = result;
            if([result isEqualToString:@"点击编辑"]) {
                cell.resultLabel.textColor = [UIColor grayColor];
            } else {
                cell.resultLabel.textColor = [UIColor blackColor];
            }
            
            return cell;
        } else if ( indexPath.row == 0) {
            VerticalTableViewCell *cell = (VerticalTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"VerticalTableCell"];
            cell.nameLabel.text = title;
            cell.avatar.image = moment.avatar;
            return cell;
        }

    }
//    static NSString *CellIdentifier = @"newFriendCell";
//    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
//    cell.textLabel.text = @"等会更新";
    return nil;
}


-(NSString *) getTitleSection:(NSInteger) section row:(NSInteger) row {
    NSString *title = @"";
    if (section ==0) {
        if(row==1) {
            title = @"昵称";
        } else if(row==2) {
            title = @"发布时间";
        } else if(row==3) {
            title = @"当前位置";

        } else if(row==4) {
            title = @"内容";
        } else if(row==0) {
            title = @"头像";
        }
    }

    return title;
}

-(NSString *) getResultSection:(NSInteger) section row:(NSInteger) row {
    NSString *result = @"点击编辑";
    if (section ==0) {
        if(row > 0) {
            if(row==1) {
                if(![AppUtils isEmpty:moment.userName]) {
                    result = moment.userName;
                }
            } else if(row==2) {
                if(![AppUtils isEmpty:moment.time]) {
                    result = moment.time;
                }

            } else if(row==3) {
                if(![AppUtils isEmpty:moment.location]) {
                    result = moment.location;
                }

            } else if(row==4) {
                if(![AppUtils isEmpty:moment.content]) {
                    result = moment.content;
                }

            }
        }
    }
    
    return result;
}

-(void) resultEditted:(NSString *) result title:(NSString *)title {
    // Define Enum?
    if([result isEqualToString:@"点击编辑"]) {
        return;
    }

    if([title isEqualToString:@"昵称"]) {
        moment.userName = result;
    } else if([title isEqualToString:@"发布时间"]) {
        moment.time = result;
    } else if([title isEqualToString:@"当前位置"]) {
        moment.location = result;
    } else if([title isEqualToString:@"内容"]) {
        moment.content = result;
    }
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 70.0;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == 0) {
        return @"基本信息";
    } 

    return NULL;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if(indexPath.row == 0) {
        [self launchGMImagePicker];
    } else {
        EditorViewController *vc = [[EditorViewController alloc] initWithNibName:@"EditorViewController" bundle:[NSBundle mainBundle]];
        vc.title = [self getTitleSection:indexPath.section row:indexPath.row];
        vc.hint = [self getResultSection:indexPath.section row:indexPath.row];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:true];
    }
}

- (void)launchGMImagePicker
{
    DNImagePickerController *imagePicker = [[DNImagePickerController alloc] init];
    imagePicker.imagePickerDelegate = self;
    imagePicker.maxSelected = 1;
    [self presentViewController:imagePicker animated:YES completion:nil];
}


#pragma mark - DNImagePickerControllerDelegate

- (void)dnImagePickerController:(DNImagePickerController *)imagePickerController sendImages:(NSArray *)imageAssets isFullImage:(BOOL)fullImage
{

    DNAsset * dnasset = imageAssets.firstObject;

    ALAssetsLibrary *lib = [ALAssetsLibrary new];
    [lib assetForURL:dnasset.url resultBlock:^(ALAsset *asset){
        if (asset) {

            moment.avatar = [AppUtils getImage:asset isFullImage:fullImage];
            [self.tableView reloadData];
        } else {
            // On iOS 8.1 [library assetForUrl] Photo Streams always returns nil. Try to obtain it in an alternative way
            [lib enumerateGroupsWithTypes:ALAssetsGroupPhotoStream
                               usingBlock:^(ALAssetsGroup *group, BOOL *stop)
             {
                 [group enumerateAssetsWithOptions:NSEnumerationReverse
                                        usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {

                                            if([[result valueForProperty:ALAssetPropertyAssetURL] isEqual:dnasset.url])
                                            {
                                                moment.avatar = [AppUtils getImage:asset isFullImage:fullImage];
                                                [self.tableView reloadData];
                                            }
                                        }];
             }
                             failureBlock:nil];
        }

    } failureBlock:^(NSError *error){

    }];
}

- (void)dnImagePickerControllerDidCancel:(DNImagePickerController *)imagePicker
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{

    }];
}


@end
