//
//  RelaxColorChangeView.m
//  relapps
//
//  Created by Diego Loop on 17/07/16.
//  Copyright © 2016 Herzly. All rights reserved.
//

#import "RelaxColorChangeView.h"
#import "Data.h"

@interface RelaxColorChangeView ()

@property (strong, nonatomic) CAKeyframeAnimation *colorsAnimation;

@end

@implementation RelaxColorChangeView

#pragma mark - Animations

- (CAKeyframeAnimation *)colorsAnimation
{
    if (!_colorsAnimation) {
        _colorsAnimation = [CAKeyframeAnimation animationWithKeyPath:@"fillColor"];
        _colorsAnimation.values =   @[(id)[UIColor greenColor].CGColor, (id)[UIColor yellowColor].CGColor, (id)[UIColor orangeColor].CGColor, (id)[UIColor redColor].CGColor];
        _colorsAnimation.keyTimes = @[[NSNumber numberWithFloat:0.25], [NSNumber numberWithFloat:0.5],     [NSNumber numberWithFloat:0.75],   [NSNumber numberWithFloat:1.0]];
        _colorsAnimation.calculationMode = kCAAnimationPaced;
        _colorsAnimation.removedOnCompletion = NO;
        _colorsAnimation.fillMode = kCAFillModeForwards;
        _colorsAnimation.duration = 3.0f;
        
    }
    return _colorsAnimation;
}


#pragma mark - Initialization

- (void)setup
{
    self.contentMode = UIViewContentModeRedraw;
    self.frame = self.superview.frame;
    self.backgroundColor = UIColorFromRGB(BACKGROUND_UICOLOR_DEFAULT);
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}


@end
