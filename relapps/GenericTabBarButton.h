//
//  GenericTabBarButton.h
//  relapps
//
//  Created by Diego Loop on 18/06/16.
//  Copyright © 2016 Herzly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GenericTabBarButton : UIButton

typedef NS_ENUM(NSInteger, ButtonStyleType){
    ButtonStyleBack,
    ButtonStyleClose,
    ButtonStyleCalm,
    ButtonStyleCalmoff,
    ButtonStyleWarning,
    ButtonStyleInfo,
    ButtonStyleLevitation,
    ButtonStyleBurger
};

- (void)setButtonType:(NSInteger )ButtonStyleType;

@end
