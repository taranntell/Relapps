//
//  GuideView.h
//  relapps
//
//  Created by Diego Loop on 11/08/16.
//  Copyright © 2016 Herzly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GenericTabBarButton.h"

@interface GuideView : UIView

@property (strong, nonatomic) UIImage *guideImage;
@property (strong, nonatomic) NSString *text;
@property (nonatomic, strong) GenericTabBarButton *rTabBtn;
@property (nonatomic) ButtonStyleType rtype;

- (void)startMovingAnimation;

@end
