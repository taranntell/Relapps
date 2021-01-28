//
//  RelaxViewController.h
//  relapps
//
//  Created by Diego Loop on 16/04/16.
//  Copyright © 2016 Herzly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GenericTabBarButton.h"


@interface RelaxViewController : UIViewController

@property (nonatomic, strong) NSString *upText;
@property (nonatomic, strong) NSString *downText;
@property (nonatomic) BOOL isFirstTimeLaunch;
@property (nonatomic) ButtonStyleType buttonStyle;

#define SHADOW_RADIUS 10.0f
#define SHADOW_OPACITY 0.8f

@end

