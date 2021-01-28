//
//  BreatheBallView.m
//  relapps
//
//  Created by Diego Loop on 08/07/16.
//  Copyright © 2016 Herzly. All rights reserved.
//

#import "BreatheBallView.h"
#import "Data.h"
#import "RelaxView.h"
#import <QuartzCore/QuartzCore.h>

@interface BreatheBallView () <UIGestureRecognizerDelegate>

@property (strong, nonatomic) CAShapeLayer *breatheball;
@property (strong, nonatomic) CABasicAnimation *breathingAnimation;

@property (nonatomic) BOOL isBreathing;

@property (strong, nonatomic) UITapGestureRecognizer *tap;

@property (nonatomic, strong) UILabel *percent;
@property (nonatomic, strong) UILabel *time;

@end

@implementation BreatheBallView

#pragma mark - Properties
- (UILabel *)percent
{
    if (!_percent) {
        _percent = [[UILabel alloc] init];
        [_percent setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height/2)];
        _percent.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle3];
        
        _percent.text = [NSString stringWithFormat:@"%d%%", (int)self.dailyProgressPercent];
        _percent.font = [UIFont fontWithName:FONT_FAMILY_THIN size:BTNSIZE]; 
        
        _percent.numberOfLines = 1;
        [_percent sizeToFit];
        [_percent setCenter:CGPointMake(self.frame.size.width/2, (self.frame.size.height/2.25) - 2.5)];
        _percent.textColor = UIColorFromRGB(TEXT_COLOR_LIGHT);
        _percent.adjustsFontSizeToFitWidth = YES;
        _percent.textAlignment = NSTextAlignmentCenter;
    }
    return _percent;
}

- (UILabel *)time
{
    if (!_time) {
        _time = [[UILabel alloc] init];
        [_time setFrame:CGRectMake(self.frame.origin.x,
                                   self.percent.frame.origin.y + self.percent.frame.size.height,
                                   self.frame.size.width, self.frame.size.height/2)];
        _time.text = self.dailyProgressTime;
        _time.textAlignment = NSTextAlignmentCenter;
        _time.font = [UIFont fontWithName:FONT_FAMILY_THIN size:BTNSIZE/2];
        _time.textColor = UIColorFromRGB(TEXT_COLOR_LIGHT);
        [_time sizeToFit];
        [_time setCenter:CGPointMake(self.frame.size.width/2, self.percent.frame.origin.y + self.percent.frame.size.height + 5)];
    }
    return _time;
}

- (void)setDailyProgressPercent:(CGFloat)dailyProgressPercent
{
    _dailyProgressPercent = dailyProgressPercent;
    self.percent.text = [NSString stringWithFormat:@"%d%%", (int)self.dailyProgressPercent];
    [self setNeedsDisplay];
}

- (void)setDailyProgressTime:(NSString *)dailyProgressTime
{
    _dailyProgressTime = dailyProgressTime;
    [self setNeedsDisplay];
}

- (CABasicAnimation *)breathingAnimation
{
    if (!_breathingAnimation) {
        _breathingAnimation = [[CABasicAnimation alloc] init];
        
        CGFloat breathingSize =  self.breatheball.frame.size.height * BREATHEREDUCTION;
        CGRect fromPath = CGRectMake(self.breatheball.frame.size.width/2 - breathingSize,
                                     self.breatheball.frame.size.height/2 - breathingSize,
                                     breathingSize * 2.0f, breathingSize * 2.0);
        
        _breathingAnimation = [CABasicAnimation animationWithKeyPath:ANIMATION_KEYPATH_PATH];
        _breathingAnimation.fromValue = (id)self.breatheball.path;
        _breathingAnimation.toValue   = (id)[UIBezierPath bezierPathWithRoundedRect:fromPath cornerRadius:breathingSize].CGPath;
        _breathingAnimation.duration = RELAX_BREATHE_DURATION_DEFAULT; //RELAXTEMP_MD default
        _breathingAnimation.repeatCount = HUGE_VALF;
        _breathingAnimation.autoreverses = YES;
        _breathingAnimation.removedOnCompletion = YES;
        _breathingAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
    }
    return _breathingAnimation;
}

/* Piece of code for adding multiple animations in a group. Code below add colors to animation
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

- (CAAnimationGroup *)animationGroup
{
    if (!_animationGroup) {
        _animationGroup = [CAAnimationGroup animation];
        _animationGroup.fillMode = kCAFillModeForwards;
        _animationGroup.removedOnCompletion = YES;
        [_animationGroup setAnimations:[NSArray arrayWithObjects: self.breathingAnimation, self.colorsAnimation, nil]];
        _animationGroup.duration = RELAXTEMP_MD;
        _animationGroup.delegate = self;
        [_animationGroup setValue:self.breatheball forKey:@"imageViewBeingAnimated"];
    }
    return _animationGroup;
}
 */

-(CAShapeLayer *)breatheball
{
    if (!_breatheball) {
        _breatheball = [CAShapeLayer layer];
        _breatheball.cornerRadius = self.frame.size.width/4;
        _breatheball.fillColor = UIColorFromRGB([Data getInstance].ballColor).CGColor;
    }
    return _breatheball;
}

- (UITapGestureRecognizer *)tap
{
    if (!_tap) {
        _tap = [[UITapGestureRecognizer alloc] init];
        _tap.delegate = self;
    }
    return _tap;
}

#pragma mark - Delegates

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        CGPoint point = [touch locationInView:self];
        
        if ([[self.breatheball presentationLayer] hitTest:point]){
            if (self.isBreathing) {
                [self.breatheball removeAnimationForKey:ANIMATION_STARTBREATHING_BREATHEKEY];
                
                [self addSubview:self.percent];
                [self addSubview:self.time];
                
                self.isBreathing = NO;
            }else{
                
                [self.percent removeFromSuperview];
                [self.time removeFromSuperview];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.breatheball addAnimation:self.breathingAnimation forKey:ANIMATION_STARTBREATHING_BREATHEKEY];
                    self.isBreathing = YES;
                    
                });
            }
        }
    }
}

#pragma mark - Initialization

- (void)drawRect:(CGRect)rect
{
    CGPoint p = CGPointMake(CGPointZero.x, CGPointZero.y);
    CGSize  s = CGSizeMake(self.frame.size.width, self.frame.size.height);
    
    CGPathRef path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(p.x, p.y, s.width, s.height)
                                                cornerRadius:s.width/2].CGPath;
    self.breatheball.path = path;
    self.breatheball.frame = self.breatheball.bounds = CGPathGetBoundingBox(path);
    [self.layer insertSublayer:self.breatheball atIndex:0];
    
    [self addSubview:self.percent];
    [self addSubview:self.time];
}

- (void)setup
{
    self.backgroundColor = [UIColor clearColor];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self setup];
    }
    
    return self;
}

@end
