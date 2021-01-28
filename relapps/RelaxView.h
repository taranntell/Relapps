//
//  RelaxView.h
//  relapps
//
//  Created by Diego Loop on 23/04/16.
//  Copyright © 2016 Herzly. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RelaxView;
@protocol RelaxViewDelegate <NSObject>

- (void)relaxView:(RelaxView *)sender isRelaxingTouch:(BOOL)isRelaxing;
- (void)relaxView:(RelaxView *)sender isMilestoneAccomplished:(BOOL)flag ofProgress:(CGFloat)progress;
- (void)relaxView:(RelaxView *)sender isFailingContinously:(BOOL)isFalling;


@end

@interface RelaxView : UIView

@property (nonatomic, weak) id <RelaxViewDelegate> delegate;

@property (nonatomic, strong) NSString *upText;
@property (nonatomic, strong) NSString *downText;
@property (nonatomic) BOOL isFirstTimeLaunch;

// Relaxing Time approachment
// 1. Last relaxing duration time in seconds
@property (nonatomic) CGFloat lastRelaxingDurationTime;
// 2. one session relaxing duration
// i.e.: when user start to relax until go to OverviewViewController
@property (nonatomic) CGFloat sessionRelaxingDurationTime;
// 3. total complete relaxing time
@property (nonatomic) CGFloat totalRelaxingDurationTime;
// 4. total relaxing time in one day
@property (nonatomic) CGFloat oneDayRelaxingDurationTime;
// 5. total of session completed -> every time the user finished 100% of the goal
@property (nonatomic) NSInteger totalCompletedSessions;

- (void) startBreathing:(CAShapeLayer *)layer duration:(CFTimeInterval)duration layersize:(CGFloat)size;

#define ANIMATION_STARTBREATHING_BREATHEKEY @"BreatheKey"
#define ANIMATION_KEYPATH_PATH     @"path"



@end
