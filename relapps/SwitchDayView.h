//
//  SwitchDayView.h
//  relapps
//
//  Created by Diego Loop on 02/08/16.
//  Copyright © 2016 Herzly. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SwitchDayView;

@protocol SwitchDayViewDelegate <NSObject>

- (void)switchDayView:(SwitchDayView *)sender insertDayWithIndex:(NSInteger)idx;
- (void)switchDayView:(SwitchDayView *)sender removeDayWithIndex:(NSInteger)idx;
- (void)switchDayView:(SwitchDayView *)sender pressOnDay:(BOOL)isPressed;

@end

@interface SwitchDayView : UIView

@property (strong, nonatomic) NSString *title;
@property (nonatomic) BOOL isDaySelected;
@property (nonatomic) BOOL isSelected;
@property (weak, nonatomic) id <SwitchDayViewDelegate> delegate;

@end
