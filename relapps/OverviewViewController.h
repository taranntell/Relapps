//
//  OverviewViewController.h
//  relapps
//
//  Created by Diego Loop on 19/06/16.
//  Copyright © 2016 Herzly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OverviewViewController : UIViewController

@property (nonatomic) NSInteger relaxMinutesGoal;

- (void)showRelaxView:(UIButton*)sender;

// Time Things to Track
@property (nonatomic) float lastRelaxingSessionDurationTimeOverview;
@property (nonatomic) float totalRelaxingDurationTimeOverview;
@property (nonatomic) float oneDayRelaxingDurationTimeOverview;
@property (nonatomic) NSInteger totalCompletedSessionsOverview;

@end
