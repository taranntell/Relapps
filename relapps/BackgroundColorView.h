//
//  BackgroundColorView.h
//  relapps
//
//  Created by Diego Loop on 30/06/16.
//  Copyright © 2016 Herzly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BackgroundColorView : UIView

typedef NS_ENUM(NSInteger, BackgroundStyle){
    BackgroundStyleDefault,
    BackgroundStyleInvert,
    BackgroundStyleWatterSee,
    BackgroundStyleWatterSeeInvert,
    BackgroundStyleMexicoLake,
    BackgroundStyleBlueDemon,
    BackgroundStyleGreenDemon,
    BackgroundStylePastelDream,
    BackgroundStyleGreenBall,
    BackgroundStyleGreenLightBall,
    BackgroundStyleNight
};

@property (nonatomic) NSInteger backgroundStyle;

@end
