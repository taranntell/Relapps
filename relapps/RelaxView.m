//
//  BaodingBall.m
//  relapps
//
//  Created by Diego Loop on 23/04/16.
//  Copyright © 2016 Herzly. All rights reserved.
//

#import "RelaxView.h"
#import "Data.h"
#import "GuideView.h"
#import "RelaxViewController.h"
#import "OverviewViewController.h"
#import <QuartzCore/QuartzCore.h>


@interface RelaxView () <UIGestureRecognizerDelegate, CAAnimationDelegate>

@property (nonatomic, strong) UILabel *upQuoteLabel;
@property (nonatomic, strong) UILabel *downQuoteLabel;

@property (nonatomic, strong) CAShapeLayer *baodingball;
@property (nonatomic, strong) CAShapeLayer *wave;
@property (nonatomic, strong) CAShapeLayer *breatheball;
@property (nonatomic, strong) CAShapeLayer *progressball;

@property (nonatomic, weak) NSSet <CALayer *> *animationLayers;

@property (nonatomic) BOOL isAnimationResumed;
@property (nonatomic) BOOL isFirstTap;
@property (nonatomic) BOOL wasAnimationBallActive;
@property (nonatomic) BOOL isAnimationAlreadyPaused;

@property (nonatomic) NSInteger numberOfFailedIntents;

@property (nonatomic, strong) UIView *quotesView;

@property (nonatomic) CGFloat scaleBallHeight;
@property (nonatomic) CGFloat scaleBallRadius;

@property (strong, nonatomic) CAKeyframeAnimation *moveBallAnimation;

@property (nonatomic) CGFloat relaxBallSpeedMove;
@property (nonatomic) CGFloat relaxWaveDurationPulse;

// Relaxing Time approachment
// 1. Last relaxing duration time in seconds
@property (nonatomic, strong) NSDate *lastRelaxingStartingDate;
// 2. one session relaxing duration
// i.e.: when user start to relax until go to OverviewViewController
//@property (nonatomic, strong) NSDate *sessionRelaxingDate;
// 3. all time complete relaxing time
@property (nonatomic, strong) NSDate *firstRelaxingDate;
// 4. total relaxing time in one day
@property (nonatomic, strong) NSDate *oneDayRelaxingDate;
@end

@implementation RelaxView

#define ANIMATION_STARTMOVING_BALLKEY       @"MoveBallKey"
#define ANIMATION_STARTMOVING_WAVEKEY       @"MoveWaveKey"
#define ANIMATION_STARTMOVING_PROGRESSKEY   @"MoveProgressKey"
#define ANIMATION_STARTWAVING_PULSEKEY      @"WavePulseKey"
#define ANIMATION_STARTWAVING_FADEKEY       @"WaveFadeKey"
#define ANIMATION_STARTPROGRESS_STROKEKEY   @"ProgressStrokeKey"

#define ANIMATION_KEYPATH_POSITION @"position"
#define ANIMATION_KEYPATH_OPACITY  @"opacity"
#define ANIMATION_KEYPATH_STROKEEND @"strokeEnd"

#pragma mark - Properties

- (NSDate *)lastRelaxingStartingDate
{
    if (!_lastRelaxingStartingDate) { _lastRelaxingStartingDate = [[NSDate alloc] init]; }
    return _lastRelaxingStartingDate;
}

- (NSDate *)firstRelaxingDate
{
    if (!_firstRelaxingDate) { _firstRelaxingDate = [[NSDate alloc] init]; }
    return _firstRelaxingDate;
}

- (NSDate *)oneDayRelaxingDate
{
    if (!_oneDayRelaxingDate) { _oneDayRelaxingDate = [[NSDate alloc] init]; }
    return _oneDayRelaxingDate;
}

- (CGFloat)relaxBallSpeedMove
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _relaxBallSpeedMove = [defaults floatForKey:RELAXVIEW_RELAXBALLSPEEDMOVE];
    if(!_relaxBallSpeedMove){
        _relaxBallSpeedMove = RELAX_BALL_SPEED_MOVE_MEDIUM_DEFAULT;
        // If default values are active, set same value in settings view
        [defaults setInteger:SETTINGS_BALL_SPEED_SEGMENT_DEFAULT forKey:SETTINGSTABLEVIEWCONTROLLER_RELAXBALLSPEEDMOVEINDEX];
    }
    return  _relaxBallSpeedMove;
}

- (CGFloat)relaxWaveDurationPulse
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _relaxWaveDurationPulse = [defaults floatForKey:RELAXVIEW_RELAXWAVEDURATIONPULSE];
    if (!_relaxWaveDurationPulse) {
        _relaxWaveDurationPulse = RELAX_WAVE_DURATION_PULSE_MEDIUM_DEFAULT;
        // If default values are active, set same value in settings view
        [defaults setInteger:SETTINGS_WAVE_DURATION_SEGMENT_DEFAULT forKey:SETTINGSTABLEVIEWCONTROLLER_RELAXWAVEDURATIONPULSEINDEX];
    }
    return _relaxWaveDurationPulse;
}

- (void)setUpText:(NSString *)upText
{
    _upText = upText;
    [self setNeedsDisplay];
}

- (void)setDownText:(NSString *)downText
{
    _downText = downText;
    [self setNeedsDisplay];
}

- (CGFloat)scaleBallHeight
{
    if (!_scaleBallHeight) {
        _scaleBallHeight = [Data scaleFactor:self.bounds.size.height];
    }
    return _scaleBallHeight;
}

- (CGFloat)scaleBallRadius
{
    if (!_scaleBallRadius) {
        _scaleBallRadius = self.scaleBallHeight / 2;
    }
    return _scaleBallRadius;
}

- (CAShapeLayer *)baodingball
{
    if (!_baodingball) {
        _baodingball = [CAShapeLayer layer];
        
        _baodingball.fillColor = UIColorFromRGB([Data getInstance].ballColor).CGColor;
        
        CGPoint center = self.superview.center;
        CGRect surface = CGRectMake(center.x-self.scaleBallRadius, center.y-self.scaleBallRadius, self.scaleBallRadius*2.0f, self.scaleBallRadius*2.0f);
        CGPathRef path = [UIBezierPath bezierPathWithRoundedRect:surface cornerRadius:surface.size.width].CGPath;
        
        _baodingball.path = path;
        _baodingball.frame  = _baodingball.bounds = CGPathGetPathBoundingBox(path);
        _baodingball.cornerRadius = surface.size.width;
        
        _baodingball.shadowColor = UIColorFromRGB(SHADOW_COLOR).CGColor;
        _baodingball.shadowRadius = SHADOW_RADIUS;
        _baodingball.shadowOpacity = SHADOW_OPACITY;
        _baodingball.shadowOffset = CGSizeZero;
        
        [self.layer addSublayer:_baodingball];
    }
    return _baodingball;
}

- (UILabel *)upQuoteLabel{
    if (!_upQuoteLabel) {
        _upQuoteLabel = [[UILabel alloc] init];
        [_upQuoteLabel setFrame:CGRectMake(self.quotesView.bounds.origin.x + MIN_MARGIN_2X,
                                self.quotesView.bounds.origin.y,
                                self.quotesView.bounds.size.width - (MIN_MARGIN_2X*2),
                                self.quotesView.bounds.size.height)];
        _upQuoteLabel.numberOfLines = 4;
        _upQuoteLabel.adjustsFontSizeToFitWidth = YES;
        _upQuoteLabel.textAlignment = NSTextAlignmentCenter;
        _upQuoteLabel.font = [UIFont systemFontOfSize:18];
        _upQuoteLabel.textColor = [UIColor darkGrayColor];
        _upQuoteLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _upQuoteLabel;
}

- (UILabel *)downQuoteLabel{
    if (!_downQuoteLabel) {
        _downQuoteLabel = [[UILabel alloc] init];
        [_downQuoteLabel setFrame:CGRectMake(self.quotesView.bounds.origin.x, self.quotesView.bounds.origin.y + self.upQuoteLabel.bounds.size.height, self.quotesView.bounds.size.width, self.quotesView.bounds.size.height/2)];
        _downQuoteLabel.textColor = [UIColor darkGrayColor];
        _downQuoteLabel.textAlignment = NSTextAlignmentCenter;
        _downQuoteLabel.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
    }
    return _downQuoteLabel;
}

- (UIView *)quotesView
{
    if (!_quotesView) {
        _quotesView = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.origin.x,
                                                              self.baodingball.bounds.origin.y + self.baodingball.bounds.size.height + (MIN_MARGIN),
                                                              self.bounds.size.width,
                                                              BTNSIZE * 1.25)]; // 50
        self.upQuoteLabel.text = self.upText;
        self.downQuoteLabel.text = self.downText;
        
        [_quotesView addSubview:self.upQuoteLabel];
        [_quotesView addSubview:self.downQuoteLabel];
    }
    return _quotesView;
}

- (CAShapeLayer *)progressball
{
    if (!_progressball) {
        _progressball = [CAShapeLayer layer];
        
        _progressball.path = self.baodingball.path;
        
        _progressball.frame = _progressball.bounds = CGPathGetBoundingBox(_progressball.path);
        _progressball.fillColor = nil;
        _progressball.lineWidth = 3.0f;
        _progressball.strokeColor = UIColorFromRGB([Data getInstance].ballColor).CGColor;
        
        [self.layer insertSublayer:_progressball above:self.wave];
    }
    return _progressball;
}

-(CAShapeLayer *)breatheball
{
    if (!_breatheball) {
        _breatheball = [CAShapeLayer layer];
        _breatheball.cornerRadius = _breatheball.bounds.size.width;
        _breatheball.fillColor = UIColorFromRGB([Data getInstance].ballColor).CGColor;
        
        _breatheball.shadowColor = UIColorFromRGB(SHADOW_COLOR).CGColor;
        _breatheball.shadowRadius = SHADOW_RADIUS;
        _breatheball.shadowOpacity = SHADOW_OPACITY/1.3;
        _breatheball.shadowOffset = CGSizeZero;
        
        [self.layer addSublayer:_breatheball];
    }
    return _breatheball;

}

#define WAVE_OPACITY_VALUE 0.15f

- (CAShapeLayer *)wave
{
    if (!_wave) {
        _wave = [CAShapeLayer layer];
        
        _wave.path = self.baodingball.path;
        _wave.frame = _wave.bounds = CGPathGetBoundingBox(_wave.path);
        
        _wave.fillColor = CGColorCreateCopyWithAlpha(UIColorFromRGB([Data getInstance].ballColor).CGColor, WAVE_OPACITY_VALUE);
        
        _wave.lineWidth = RELAX_WAVE_LINEWIDTH;
        _wave.strokeColor = UIColorFromRGB([Data getInstance].ballColor).CGColor;
        
        _wave.shadowColor = UIColorFromRGB(SHADOW_COLOR).CGColor;//[UIColor blackColor].CGColor;//UIColorFromRGB(SHADOW_COLOR).CGColor;
        _wave.shadowRadius = SHADOW_RADIUS;
        _wave.shadowOpacity = 1.f; //SHADOW_OPACITY;
        _wave.shadowOffset = CGSizeZero;
        
        // send layer to background (index 0)
        [self.layer insertSublayer:_wave atIndex:0];
    }
    return _wave;
}

- (NSSet<CALayer *> *)animationLayers
{
    if (!_animationLayers) {
        _animationLayers = [NSSet setWithObjects:self.baodingball, self.wave, self.progressball, nil];
    }
    return _animationLayers;
}

#pragma mark - Methods

// Returns a random point from total display minus radius of "baoding ball"
- (CGPoint)randomPoint
{
    /*
     * RQ 7:
     * On RelaxView, OverviewButton overlaps with ball and is not possible to press.
     * Solution: Add limitations where the back btw is, so the ball won’t overlaps with OverviewButton - 01.01.00 - 13.08.2016
     */
    CGFloat width  = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    CGFloat radius = self.scaleBallRadius;
    
    CGFloat x = (CGFloat)(arc4random() % (int) width);
    CGFloat y = (CGFloat)(arc4random() % (int) height);
    
    if (x <= radius)             x = radius;
    else if(x >= width - radius) x = width - radius;
    
    if (y <= radius)             y = radius;
    else if (y >= height-radius) y = height - radius;
    
    return CGPointMake(x,y);
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self startBreathing:self.baodingball duration:RELAX_BREATHE_DURATION_DEFAULT layersize:self.scaleBallHeight];
    });
    
    [self addSubview:self.quotesView];
    [self sendSubviewToBack:self.quotesView];
}

- (CGMutablePathRef)curvePathRandomlyFromPoint:(CGPoint)fPoint toPoint:(CGPoint)tPoint
{
    /*
     * RQ 8:
     * On relaxing, the ball loses their path and jump in the middle to other point very quickly.
     */
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, fPoint.x, fPoint.y);
    CGPathAddCurveToPoint(path,NULL, self.bounds.size.width-self.scaleBallRadius, self.bounds.size.height-self.scaleBallRadius, self.scaleBallRadius, -self.scaleBallRadius, tPoint.x, tPoint.y);
    
    return path;
}

- (CAShapeLayer *)addBreatheballAtPosition:(CGPoint)position;
{
    CGPoint p = CGPointMake(position.x-self.scaleBallRadius, position.y-self.scaleBallRadius);
    CGSize  s = self.baodingball.bounds.size;
    
    CGPathRef path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(p.x, p.y, s.width, s.height)
                                                cornerRadius:self.breatheball.bounds.size.width].CGPath;
    self.breatheball.path = path;
    self.breatheball.frame = self.breatheball.bounds = CGPathGetBoundingBox(path);
    return self.breatheball;
}

#define mark - Animating

- (void) startBreathing:(CAShapeLayer *)layer duration:(CFTimeInterval)duration layersize:(CGFloat)size
{
    
    CGFloat breatheSize = size * BREATHEREDUCTION; // BREATHEREDUCTION = 75% of the original size of the ball
    
    CGRect fPath = CGRectMake(layer.position.x  -breatheSize,
                              layer.position.y-breatheSize,
                              breatheSize*2.0f, breatheSize*2.0f);
    
    CABasicAnimation *breathe = [CABasicAnimation animationWithKeyPath:ANIMATION_KEYPATH_PATH];
    breathe.fromValue = (id)layer.path;
    breathe.toValue   = (id)[UIBezierPath bezierPathWithRoundedRect:fPath cornerRadius:breatheSize].CGPath;
    breathe.duration = duration; //RELAXTEMP_MD default
    breathe.repeatCount = HUGE_VALF;
    breathe.autoreverses = YES;
    breathe.removedOnCompletion = YES;
    breathe.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [layer addAnimation:breathe forKey:ANIMATION_STARTBREATHING_BREATHEKEY];
}

- (void)startWaving
{
    float waveSize = self.frame.size.width/2;
    CGRect endPath = CGRectMake(self.baodingball.bounds.origin.x + self.baodingball.cornerRadius/2 - waveSize,
                                self.baodingball.bounds.origin.y + self.baodingball.cornerRadius/2 - waveSize,
                                waveSize*2.0f, waveSize*2.0f);
    
    // Start wave pulsing
    CABasicAnimation *pulse = [CABasicAnimation animationWithKeyPath:ANIMATION_KEYPATH_PATH];
    pulse.fromValue = (id)self.wave.path;
    pulse.toValue   = (id)[UIBezierPath bezierPathWithRoundedRect:endPath cornerRadius:waveSize].CGPath;
    pulse.duration = self.relaxWaveDurationPulse;
    pulse.repeatCount = HUGE_VALF;
    [pulse setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [self.wave addAnimation:pulse forKey:ANIMATION_STARTWAVING_PULSEKEY];
    
    // Fade out wave
    CABasicAnimation *fade = [CABasicAnimation animationWithKeyPath:ANIMATION_KEYPATH_OPACITY];
    fade.duration = self.relaxWaveDurationPulse;
    fade.fromValue = [NSNumber numberWithFloat:1.0f];
    fade.toValue = [NSNumber numberWithFloat:0.0f];
    fade.repeatCount = HUGE_VALF;
    fade.fillMode = kCAFillModeBoth;
    [self.wave addAnimation:fade forKey:ANIMATION_STARTWAVING_FADEKEY];

}

- (CGFloat)minutesGoal
{
    return [OverviewViewController alloc].relaxMinutesGoal * 60;
}

-(void)startProgressOfTotalTime:(CGFloat)time
{
    CGFloat minutesGoal = [self minutesGoal];
    CGFloat startProgressFromValue = (time * 1) /minutesGoal;
    
    CABasicAnimation *progressAnim = [CABasicAnimation animationWithKeyPath:ANIMATION_KEYPATH_STROKEEND];
    [progressAnim setDuration:minutesGoal - time];
    [progressAnim setFromValue:[NSNumber numberWithFloat:startProgressFromValue]];
    [progressAnim setToValue:[NSNumber numberWithFloat:1.0f]];
    [progressAnim setRemovedOnCompletion:NO];
    [progressAnim setFillMode:kCAFillModeBackwards];
    progressAnim.delegate = self; // TODO: NOT SURE IF HAS TO BE REMOVED 24.09.2016
    [progressAnim setTimingFunction:
     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];

    [self.progressball addAnimation:progressAnim forKey:ANIMATION_STARTPROGRESS_STROKEKEY];
}

- (BOOL)isRelaxationProgressPassed:(CGFloat)def{
    
    CGFloat minutesGoal = [self minutesGoal];
    CGFloat startProgressFromValue = (self.oneDayRelaxingDurationTime * 1) /minutesGoal;
    
    if (startProgressFromValue > def) {
        return YES;
    }
    return NO;
}

- (CAKeyframeAnimation *)moveBallAnimation
{
    if (!_moveBallAnimation) {
        _moveBallAnimation = [CAKeyframeAnimation animationWithKeyPath:ANIMATION_KEYPATH_POSITION];
        _moveBallAnimation.duration = RELAX_BALL_DURATION_MOVE_DEFAULT;
        _moveBallAnimation.speed = self.relaxBallSpeedMove;
    }
    return _moveBallAnimation;
}

#define MILESTONE_PROGRESS 0.40f

- (void)startMovingFromPoint:(CGPoint)fromPoint
{
    [self updateRelaxingTime];
    self.lastRelaxingStartingDate = [NSDate date];
    
    
    CGPoint guidePoint = [self randomPoint];
    
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    [CATransaction setDisableActions:YES];
    
    self.moveBallAnimation.path = [self curvePathRandomlyFromPoint:fromPoint toPoint:guidePoint];
    
    self.baodingball.position = guidePoint;
    
    [CATransaction setCompletionBlock:^{
        // I think this is not the best approach (using hidden) to determine
        // if a block should stop or continue
        // But for the moment is working and it's avoiding **memory leak**
        if (!self.hidden) {
            [self startMovingFromPoint:guidePoint];
        }
    }];
    
    
    [self.baodingball addAnimation:self.moveBallAnimation forKey:ANIMATION_STARTMOVING_BALLKEY];
    
    [self.wave addAnimation:self.moveBallAnimation forKey:ANIMATION_STARTMOVING_WAVEKEY];
    
    [self.progressball addAnimation:self.moveBallAnimation forKey:ANIMATION_STARTMOVING_PROGRESSKEY];

    [self.breatheball  removeFromSuperlayer];
    
    
    CGFloat progress = MILESTONE_PROGRESS;
    if ([self isRelaxationProgressPassed:progress]) {
        [self.delegate relaxView:self isMilestoneAccomplished:YES ofProgress:progress];
        [self.delegate relaxView:self isRelaxingTouch:YES];
    }
    
    [CATransaction commit];
     

}

- (void)startAnimation
{
    //Remove note text
    
    [self.quotesView removeFromSuperview];
    
    [self.baodingball removeAnimationForKey:ANIMATION_STARTBREATHING_BREATHEKEY];
    
    [self startWaving];
    
    [self startProgressOfTotalTime:self.oneDayRelaxingDurationTime];
    
    [self startMovingFromPoint:self.baodingball.position];
    
    [self.delegate relaxView:self isRelaxingTouch:YES];
    
    self.wasAnimationBallActive = YES;
}

- (void) updateRelaxingTime
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.lastRelaxingDurationTime = [[NSDate date] timeIntervalSinceDate:self.lastRelaxingStartingDate];
    self.sessionRelaxingDurationTime += self.lastRelaxingDurationTime;
    if (self.sessionRelaxingDurationTime >= 0.001) [defaults setFloat:self.sessionRelaxingDurationTime forKey:RELAXVIEW_LASTRELAXINGSESSIONDURATIONTIME];
    
    self.totalRelaxingDurationTime += self.lastRelaxingDurationTime;
    [defaults setFloat:self.totalRelaxingDurationTime forKey:RELAXVIEW_TOTALRELAXINGDURATIONTIME];
    
    self.oneDayRelaxingDurationTime += self.lastRelaxingDurationTime;
    [defaults setFloat:self.oneDayRelaxingDurationTime forKey:RELAXVIEW_ONEDAYRELAXINGTIME];
}

#pragma mark - Delegates

- (void) addTotalCompletedSessions
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.totalCompletedSessions = [defaults integerForKey:RELAXVIEW_TOTALCOMPLETEDSESSIONS];
    if (![defaults boolForKey:RELAXVIEW_ISTOTALCOMPLETEDSESSIONALREADYADDED]) {
        self.totalCompletedSessions += 1;
        [defaults setBool:YES forKey:RELAXVIEW_ISTOTALCOMPLETEDSESSIONALREADYADDED];
    }
    [defaults setInteger:self.totalCompletedSessions forKey:RELAXVIEW_TOTALCOMPLETEDSESSIONS];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    UIColor *color = UIColorFromRGB(0x80CABC);
    if (flag) {
        self.baodingball.fillColor = color.CGColor;
        self.breatheball.fillColor = color.CGColor;
        self.wave.fillColor = color.CGColor;
        self.wave.fillColor = CGColorCreateCopyWithAlpha(color.CGColor, WAVE_OPACITY_VALUE);
        self.wave.strokeColor = color.CGColor;
        
        self.baodingball.shadowColor = self.breatheball.shadowColor = self.wave.shadowColor = color.CGColor;
        
        [self addTotalCompletedSessions];
    }
}


- (void) showFailingGuideView
{
    BOOL isGuideViewVisible = NO;
    static int failingTimes = 3;
    if (self.numberOfFailedIntents <= NUMBER_OF_FAIL_RELAXING_ATTEMS * failingTimes) {
        
        for (UIView *v in  [[UIApplication sharedApplication].keyWindow subviews]){//self.view.subviews) {
            
            if ([v isKindOfClass:[GuideView class]]) isGuideViewVisible = YES;
        }
    }
    
    if (isGuideViewVisible) self.numberOfFailedIntents = NUMBER_OF_FAIL_RELAXING_ATTEMS + 1;
    else self.numberOfFailedIntents += 1;
    
    // If the user fail then a guide view to help him to understan will be shown
    if ((self.numberOfFailedIntents == NUMBER_OF_FAIL_RELAXING_ATTEMS || self.numberOfFailedIntents == (NUMBER_OF_FAIL_RELAXING_ATTEMS * failingTimes) )
        && self.totalCompletedSessions == 0
        && ![self isRelaxationProgressPassed:0.10]){

        [self.delegate relaxView:self isFailingContinously:YES];
    }
}


- (void)pauseAnimationLayer:(NSSet <CALayer *>*)layers
{
    for (CAShapeLayer *layer in layers) {
        CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
        layer.speed = 0.0;
        layer.timeOffset = pausedTime;
    
        [self.layer addSublayer:[self addBreatheballAtPosition:[[layer presentationLayer] position]]];
    }
    
    self.isAnimationResumed = NO;
    [self startBreathing:self.breatheball duration:RELAX_BREATHE_DURATION_DEFAULT layersize:self.scaleBallHeight];
    
    [self updateRelaxingTime];
    
    [self.delegate relaxView:self isRelaxingTouch:NO];
    
    if (self.totalCompletedSessions == 0) [self showFailingGuideView];
}

- (void)resumeAnimationLayer:(NSSet <CALayer *>*)layers
{
    [self.breatheball removeFromSuperlayer];
    
    for (CAShapeLayer *layer in layers) {
        
        CFTimeInterval pausedTime = [layer timeOffset];
        layer.speed = 1.0;
        layer.timeOffset = 0.0;
        layer.beginTime = 0.0;
        CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
        layer.beginTime = timeSincePause;
    }
    self.isAnimationResumed = YES;
    self.isAnimationAlreadyPaused = NO;
    [self.delegate relaxView:self isRelaxingTouch:YES];
}

- (void)storeFirstDateOfRelaxing
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (![defaults objectForKey:RELAXVIEW_FIRSTRELAXINGDATE]) {
        self.firstRelaxingDate = [NSDate date];
        [defaults setObject:self.firstRelaxingDate forKey:RELAXVIEW_FIRSTRELAXINGDATE];
    }else{
        self.firstRelaxingDate = [defaults objectForKey:RELAXVIEW_FIRSTRELAXINGDATE];
    }
}

- (void)storeOneDayDateOfRelaxing
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:RELAXVIEW_ONEDAYRELAXINGDATE]) {
        self.oneDayRelaxingDate = [NSDate date];
    }else{
        self.oneDayRelaxingDate = [defaults objectForKey:RELAXVIEW_ONEDAYRELAXINGDATE];
    }
    
    // TODO: Should check if day is over!!! Improvement
    if ([Data isRelaxingTimeOverOnDays:1 oldDate:self.oneDayRelaxingDate newDate:[NSDate date]]) {
        self.oneDayRelaxingDate = [NSDate date];
        self.oneDayRelaxingDurationTime = 0.0f;
        
        [defaults setBool:NO forKey:RELAXVIEW_ISTOTALCOMPLETEDSESSIONALREADYADDED];
    }
    
    [defaults setObject:self.oneDayRelaxingDate forKey:RELAXVIEW_ONEDAYRELAXINGDATE];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        CGPoint point = [touch locationInView:self];
        
        if ([[self.baodingball presentationLayer] hitTest:point]) {
            if (self.isFirstTap) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self startAnimation];
                });
                [self storeOneDayDateOfRelaxing];
                
                self.isFirstTap = NO;
                
            }else{
                if (self.isAnimationResumed){
                    if (!self.isAnimationAlreadyPaused) {
                        [self pauseAnimationLayer:self.animationLayers];
                        self.isAnimationAlreadyPaused = YES;
                    }
                }else
                    [self resumeAnimationLayer:self.animationLayers];
            }
        
            self.lastRelaxingStartingDate = [NSDate date];
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // On touch moving the animiation will be stopped
    for (UITouch *touch in touches) {
        CGPoint point = [touch locationInView:self];
        
        if ([[self.baodingball presentationLayer] hitTest:point]) {
            
            if (self.isAnimationResumed) {
                if (!self.isAnimationAlreadyPaused) {
                    [self pauseAnimationLayer:self.animationLayers];
                    self.isAnimationAlreadyPaused = YES;
                }
            }
        }else{
            // This code is working but there is a problem on the logic... isAnimationResumed start as YES (see setup)
            // it should be NO as default
            // Problem:
            // self.isAnimationResumed and the user touches for the very first time outside the ball
            // the breathball will be added at point (0,0)
            if (self.wasAnimationBallActive) {
                if (!self.isAnimationAlreadyPaused) {
                    [self pauseAnimationLayer:self.animationLayers];
                    self.isAnimationAlreadyPaused = YES;
                }
            }
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        CGPoint point = [touch locationInView:self];
        
        if ([[self.baodingball presentationLayer] hitTest:point]) {
            
            if (self.isFirstTap) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self startAnimation];
                });
                self.isFirstTap = NO;
            }
            
            if (!self.isAnimationResumed){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self resumeAnimationLayer:self.animationLayers];
                });
                self.lastRelaxingStartingDate = [NSDate date];
            }
            
        }else{
            if (self.isAnimationResumed && !self.isFirstTap){
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (!self.isAnimationAlreadyPaused) {
                        [self pauseAnimationLayer:self.animationLayers];
                        self.isAnimationAlreadyPaused = YES;
                    }
                });
            }
        }
    }
}

#pragma mark - Initialization

- (void)setup
{
    self.contentMode = UIViewContentModeRedraw;
    self.backgroundColor = [UIColor clearColor];
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;

    self.isAnimationResumed = YES;
    self.isFirstTap = YES;
    self.wasAnimationBallActive = NO;
    self.isAnimationAlreadyPaused = NO;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.totalRelaxingDurationTime = [defaults floatForKey:RELAXVIEW_TOTALRELAXINGDURATIONTIME];
    if (isnan(self.totalRelaxingDurationTime)) self.totalRelaxingDurationTime = 0.0f;
    
    self.oneDayRelaxingDurationTime = [defaults floatForKey:RELAXVIEW_ONEDAYRELAXINGTIME];
    if (isnan(self.oneDayRelaxingDurationTime)) self.oneDayRelaxingDurationTime = 0.0f;
    
    self.totalCompletedSessions = [defaults integerForKey:RELAXVIEW_TOTALCOMPLETEDSESSIONS];
    
    [self updateRelaxingTime];
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
