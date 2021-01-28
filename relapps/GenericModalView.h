//
//  GenericModalView.h
//  relapps
//
//  Created by Diego Loop on 18/06/16.
//  Copyright © 2016 Herzly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GenericTabBarButton.h"
#import "GenericButton.h"

@interface GenericModalView : UIView

@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *subtitle;
@property (nonatomic, strong) GenericTabBarButton *lTabBtn;
@property (nonatomic, strong) GenericTabBarButton *rTabBtn;
@property (nonatomic, strong) UIView *totalTimeOverview;
@property (nonatomic, strong) UIView *bottomSeparationLine;
@property (nonatomic, strong) GenericButton *continueBtn;
@property (nonatomic, strong) UIView *relaxProgressView;

@property (nonatomic, strong) CAShapeLayer *breathBall;

- (void)addTopTitle:(NSString*)text;
- (void)addTopSubtitle:(NSString*)text;
- (void)addLeftTabBtn:(ButtonStyleType)type;
- (void)addRightTabBtn:(ButtonStyleType)type;
- (void)addBigTime:(NSTimeInterval)time;
- (void)addBreathingBall;
- (void)addContinueBtn:(NSString*)title forState:(UIControlState)state;
- (void)addBottomSeparationLine;
- (void)addRelaxViewWithProgress:(float)progress totaltime:(float)totaltime;


@end
