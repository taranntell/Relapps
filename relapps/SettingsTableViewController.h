//
//  SettingsTableViewController.h
//  relapps
//
//  Created by Diego Loop on 15/07/16.
//  Copyright © 2016 Herzly. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SettingsTableViewController;

@protocol SettingsTableViewControllerDelegate <NSObject>

-(void)settingsTableViewController:(SettingsTableViewController *)sender updateValues:(BOOL)isUpdate;

@end


@interface SettingsTableViewController : UITableViewController

@property (nonatomic, weak) id <SettingsTableViewControllerDelegate> delegate;

@end
