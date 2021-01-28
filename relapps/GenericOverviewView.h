//
//  GenericOverviewView.h
//  relapps
//
//  Created by Diego Loop on 04/07/16.
//  Copyright © 2016 Herzly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GenericTabBarButton.h"

@interface GenericOverviewView : UIView


@property (nonatomic, strong) NSString *titleText;
@property (nonatomic, strong) UILabel *subtitle;
@property (nonatomic, strong) NSString *subtitleText;
@property (nonatomic) ButtonStyleType ltypeb;
@property (nonatomic) ButtonStyleType rtype;
@property (nonatomic, strong) GenericTabBarButton *lTabBtn;
@property (nonatomic, strong) GenericTabBarButton *rTabBtn;
@property (nonatomic, strong) NSString *bottomTitle;
@property (nonatomic, strong) NSString *bottomText1;
@property (nonatomic, strong) NSString *bottomText2;
@property (nonatomic, strong) NSString *bottomText3;

@property (nonatomic, strong) CAShapeLayer *breathBall;


@end
