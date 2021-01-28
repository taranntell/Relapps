//
//  SettingsTableViewController.m
//  relapps22
//
//  Created by Diego Loop on 15/07/16.
//  Copyright © 2016 Herzly. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "OverviewViewController.h"
#import "GenericOverviewView.h"
#import "Data.h"

@interface SettingsTableViewController ()

@property (weak, nonatomic) IBOutlet UISlider *minutesGoalSlider;
@property (weak, nonatomic) IBOutlet UISegmentedControl *speedBallSegment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *speedWaveSegment;
@property (weak, nonatomic) IBOutlet UILabel *minutesGoalLabel;

@end

// Things to set up

// 1. Relaxing Ball
// a. Velocity of the movement of the ball (Just 3 values)

// 2. Wave
// a. Duration of the wave to dissapear

// 3. Minutes per day goal

// In App Purchase
// 1. Music

@implementation SettingsTableViewController

- (void)initMinutesGoalSlider
{
    [self.minutesGoalSlider addTarget:self action:@selector(minutesGoalChanged:) forControlEvents:UIControlEventValueChanged];
    
    self.minutesGoalSlider.minimumValue = RELAX_MINIMUM_MINUTES_GOAL;
    self.minutesGoalSlider.maximumValue = RELAX_MAXIMUM_MINUTES_GOAL;
    
    NSInteger value = [[NSUserDefaults standardUserDefaults] integerForKey:OVERVIEWVIEWCONTROLLER_RELAXMINUTESGOAL];
    
    self.minutesGoalSlider.value = (!value || isnan(value) || value == (long)0) ? RELAX_MINUTES_GOAL_DEFAULT : value;
    
    self.minutesGoalLabel.text = [NSString stringWithFormat:@"%d min", (int)self.minutesGoalSlider.value];
}

- (void) minutesGoalChanged:(UISlider *)sender
{
    [sender setValue:(int)sender.value animated:YES];
    self.minutesGoalLabel.text = [NSString stringWithFormat:@"%d min", (int)sender.value];
}

- (void)initSpeedBallSegment
{
    NSInteger idx = [[NSUserDefaults standardUserDefaults] integerForKey:SETTINGSTABLEVIEWCONTROLLER_RELAXBALLSPEEDMOVEINDEX];
    if (isnan(idx) || idx == (long)0 || !idx) { idx = SETTINGS_BALL_SPEED_SEGMENT_DEFAULT; }
    self.speedBallSegment.selectedSegmentIndex = idx;
}

- (void)initSpeedWaveSegment
{
    NSInteger idx = [[NSUserDefaults standardUserDefaults] integerForKey:SETTINGSTABLEVIEWCONTROLLER_RELAXWAVEDURATIONPULSEINDEX];
    if (isnan(idx) || idx == (long)0 || !idx) { idx = SETTINGS_WAVE_DURATION_SEGMENT_DEFAULT; }
    self.speedWaveSegment.selectedSegmentIndex = idx;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initMinutesGoalSlider];
    
    [self initSpeedBallSegment];
    
    [self initSpeedWaveSegment];
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSUserDefaults *defautls = [NSUserDefaults standardUserDefaults];
    [defautls setInteger:self.minutesGoalSlider.value forKey:OVERVIEWVIEWCONTROLLER_RELAXMINUTESGOAL];
    [self.delegate settingsTableViewController:self updateValues:YES];
    
    
    if (self.speedBallSegment.selectedSegmentIndex == 0)
        [defautls setFloat:RELAX_BALL_SPEED_MOVE_SLOW forKey:RELAXVIEW_RELAXBALLSPEEDMOVE];
    else if (self.speedBallSegment.selectedSegmentIndex == 1)
        [defautls setFloat:RELAX_BALL_SPEED_MOVE_MEDIUM_DEFAULT forKey:RELAXVIEW_RELAXBALLSPEEDMOVE];
    else if (self.speedBallSegment.selectedSegmentIndex == 2)
        [defautls setFloat:RELAX_BALL_SPEED_MOVE_FAST forKey:RELAXVIEW_RELAXBALLSPEEDMOVE];
    
    [defautls setInteger:self.speedBallSegment.selectedSegmentIndex forKey:SETTINGSTABLEVIEWCONTROLLER_RELAXBALLSPEEDMOVEINDEX];
    
    
    if (self.speedWaveSegment.selectedSegmentIndex == 0)
        [defautls setFloat:RELAX_WAVE_DURATION_PULSE_SLOW forKey:RELAXVIEW_RELAXWAVEDURATIONPULSE];
    else if (self.speedWaveSegment.selectedSegmentIndex == 1)
        [defautls setFloat:RELAX_WAVE_DURATION_PULSE_MEDIUM_DEFAULT forKey:RELAXVIEW_RELAXWAVEDURATIONPULSE];
    else if (self.speedWaveSegment.selectedSegmentIndex == 2)
        [defautls setFloat:RELAX_WAVE_DURATION_PULSE_FAST forKey:RELAXVIEW_RELAXWAVEDURATIONPULSE];
    
    [defautls setInteger:self.speedWaveSegment.selectedSegmentIndex forKey:SETTINGSTABLEVIEWCONTROLLER_RELAXWAVEDURATIONPULSEINDEX];
    
}
@end
