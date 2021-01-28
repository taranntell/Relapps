//
//  RelaxViewController.m
//  relapps
//
//  Created by Diego Loop on 16/04/16.
//  Copyright © 2016 Herzly. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

#import "RelaxViewController.h"
#import "GenericTabBarButton.h"
#import "OverviewViewController.h"
#import "RelaxColorChangeView.h"
#import "BackgroundColorView.h"
#import "RelaxView.h"
#import "GuideView.h"
#import "Data.h"


@interface RelaxViewController () <UIGestureRecognizerDelegate, AVAudioPlayerDelegate, RelaxViewDelegate>

@property (nonatomic, strong) IBOutlet RelaxView *relaxView;
@property (nonatomic, strong) GenericTabBarButton *itemVCBtn;

@property (strong, nonatomic) UIView *backGuideView;

@property (nonatomic, strong) AVAudioPlayer *basealterTrack;
@property (nonatomic, strong) AVAudioPlayer *baseConTrack;
@property (nonatomic, strong) AVAudioPlayer *noiseTouchTrack;
@property (nonatomic, strong) AVAudioPlayer *breathing46;
@property (nonatomic, strong) AVAudioPlayer *whaleBreathe;
@property (nonatomic, strong) AVAudioPlayer *modwheelCosmosTrack;

@property (nonatomic) BOOL isProgressMilestoneAccomplished;

@property (nonatomic) float oldRelaxingTime;

@end

@implementation RelaxViewController

#pragma mark - Properties

#define BASE_VOLUME 0.5

- (UIView *)backGuideView
{
    if (!_backGuideView) {
        _backGuideView = [[UIView alloc] initWithFrame:self.view.bounds];
        _backGuideView.backgroundColor = [UIColor grayColor];
        _backGuideView.alpha = LIGHT_ALPHA_BACKGROUND;
    }
    return _backGuideView;
}

- (AVAudioPlayer *)noiseTouchTrack
{
    if (!_noiseTouchTrack) {
        NSError *error;
        NSURL *trackURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"NoiseRelaxTouch" ofType:@"m4a"]];
        _noiseTouchTrack = [[AVAudioPlayer alloc] initWithContentsOfURL:trackURL error:&error];
        if (!error) {
            [_noiseTouchTrack prepareToPlay];
            _noiseTouchTrack.numberOfLoops = -1;

        }else NSLog(@"Error on track %@ : error %@", _basealterTrack.url, error);
    }
    return _noiseTouchTrack;
}

- (AVAudioPlayer *)modwheelCosmosTrack
{
    if (!_modwheelCosmosTrack) {
        NSError *error;
        NSURL *trackURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"ModwheelCosmos" ofType:@"m4a"]];
        _modwheelCosmosTrack = [[AVAudioPlayer alloc] initWithContentsOfURL:trackURL error:&error];
        _modwheelCosmosTrack.volume = BASE_VOLUME;
        if (!error) {
            [_modwheelCosmosTrack prepareToPlay];
            _modwheelCosmosTrack.numberOfLoops = -1;
        }else NSLog(@"Error on track %@ : error %@", _modwheelCosmosTrack.url, error);
    }
    return _modwheelCosmosTrack;
}

- (AVAudioPlayer *)basealterTrack
{
    if (!_basealterTrack) {
        NSError *error;
        NSURL *trackURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"BaseVariation" ofType:@"m4a"]];
        _basealterTrack = [[AVAudioPlayer alloc] initWithContentsOfURL:trackURL error:&error];
        _basealterTrack.volume = BASE_VOLUME;
        if (!error) {
            [_basealterTrack prepareToPlay];
            _basealterTrack.numberOfLoops = -1;
        }else NSLog(@"Error on track %@ : error %@", _basealterTrack.url, error);
        
    }
    return _basealterTrack;
}

- (AVAudioPlayer *)baseConTrack
{
    if (!_baseConTrack) {
        NSError *error;
        NSURL *trackURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"BaseStable" ofType:@"m4a"]];
        _baseConTrack = [[AVAudioPlayer alloc] initWithContentsOfURL:trackURL error:&error];
        _baseConTrack.volume = BASE_VOLUME;
        if (!error) {
            [_baseConTrack prepareToPlay];
            _baseConTrack.numberOfLoops = -1;
        }else NSLog(@"Error on track %@ : error %@", _baseConTrack.url, error);
    }
    return _baseConTrack;
}

-(AVAudioPlayer *)breathing46
{
    if (!_breathing46) {
        NSError *error;
        NSURL *trackURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"breathing4-6Trimmed" ofType:@"m4a"]];
        _breathing46 = [[AVAudioPlayer alloc] initWithContentsOfURL:trackURL error:&error];
        _breathing46.volume = BASE_VOLUME - 0.2;
        if (!error) {
            [_breathing46 prepareToPlay];
            _breathing46.numberOfLoops = -1;
        }else NSLog(@"Error on track %@ : error %@", _breathing46.url, error);
    }
    return _breathing46;
}

-(AVAudioPlayer *)whaleBreathe
{
    if (!_whaleBreathe) {
        NSError *error;
        NSURL *trackURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"whaleBreath" ofType:@"m4a"]];
        _whaleBreathe = [[AVAudioPlayer alloc] initWithContentsOfURL:trackURL error:&error];
        _whaleBreathe.volume = BASE_VOLUME;
        if (!error) {
            [_whaleBreathe prepareToPlay];
            _whaleBreathe.numberOfLoops = -1;
        }else NSLog(@"Error on track %@ : error %@", _whaleBreathe.url, error);
    }
    return _whaleBreathe;
}

- (void)setUpText:(NSString *)upText
{
    _upText = upText;
    [self.relaxView setNeedsDisplay];
}

- (void)setDownText:(NSString *)downText
{
    _downText = downText;
    [self.relaxView setNeedsDisplay];
}

- (UIButton *)itemVCBtn
{
    if (!_itemVCBtn) {
        _itemVCBtn = [[GenericTabBarButton alloc] init];
        [_itemVCBtn setButtonType:self.buttonStyle];
        [_itemVCBtn addTarget:self action:@selector(closeViewController:) forControlEvents:UIControlEventTouchDown];
        [_itemVCBtn setFrame:CGRectMake(MIN_MARGIN, MIN_MARGIN, BTNSIZE, BTNSIZE)];
    }
    return _itemVCBtn;
}

#pragma mark - Methods
- (float)findRelaxingTimeDuringOneDay
{
    return 0.0;
}

- (void)closeViewController: (UIButton*)sender
{
    // Important! setting relaxView.hidden to YES increase performace
    // For more information see -(void)startMovingFromPoint on RelaxView.m
    self.relaxView.hidden = YES;
    
    [self performSegueWithIdentifier:SEGUE_OVERVIEWVIEW sender:nil];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IS_APP_ALREADY_LAUNCHED];
}

- (void)startSounding
{
    [self.basealterTrack play];
    [self.breathing46 play];
    
    
//    [self.noiseTouchTrack play]; *
//    [self.modwheelCosmosTrack play]; *
//    [self.basealterTrack play]; *
//    [self.baseConTrack play]; **
//    [self.breathing46 play]; *
//    [self.whaleBreathe play];
}

#pragma mark - Drawing

- (void)showGuideView
{
    [[UIApplication sharedApplication].keyWindow addSubview:self.backGuideView];
    CGRect rect = CGRectMake(MIN_MARGIN_2X,
                             self.navigationController.navigationBar.bounds.size.height + (MIN_MARGIN_2X),
                             self.view.bounds.size.width - (MIN_MARGIN_2X*2),
                             (self.view.bounds.size.height / 1.1) - self.navigationController.navigationBar.bounds.size.height-[UIApplication sharedApplication].statusBarFrame.size.height- (MIN_MARGIN_2X*2));
    GuideView *guideView = [[GuideView alloc] initWithFrame:rect];
    
    guideView.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
    guideView.rtype = ButtonStyleClose;
    [guideView.rTabBtn addTarget:self action:@selector(closeGuideView:) forControlEvents:UIControlEventTouchDown];
    guideView.guideImage = [UIImage imageNamed:@"pointerhand"];
    guideView.text = @"Just press the ball and follow it!";
    guideView.alpha = 0.f;
    [[UIApplication sharedApplication].keyWindow addSubview:guideView];
    
    [UIView animateWithDuration:1.5 animations:^{
        guideView.alpha = 1.f;
    }];
    
    [guideView startMovingAnimation];

}

- (void)closeGuideView:(UIButton *) sender
{
    [self.backGuideView removeFromSuperview];
    [sender.superview removeFromSuperview];
}

#pragma mark - Delegates

- (void)relaxView:(RelaxView *)sender isRelaxingTouch:(BOOL)isRelaxing
{
    // IF TOUCHING BALL
    if (isRelaxing) {
        // IF BEGINNING
        [self.whaleBreathe play];
        
        // IF MILESTONE (0.50) ACCOMPLISHED
        if (self.isProgressMilestoneAccomplished){
            if (!self.modwheelCosmosTrack.isPlaying) [self.modwheelCosmosTrack play];
        }
        
        // STOP BREATHING 46 IF TOUCHING
        [self.breathing46 stop];
    
        
    // IF STOP TOUCHING BALL
    }else{
        
        if (self.whaleBreathe.isPlaying) [self.whaleBreathe stop];
        if (self.noiseTouchTrack.isPlaying) [self.noiseTouchTrack stop];
        if (self.modwheelCosmosTrack.isPlaying) [self.modwheelCosmosTrack stop];
    
        // PLAY BREATHING 46 IF NOT TOUCHING
        [self.breathing46 play];
    }
}

- (void)relaxView:(RelaxView *)sender isMilestoneAccomplished:(BOOL)flag ofProgress:(CGFloat)progress
{
    if (flag) {
        self.isProgressMilestoneAccomplished = YES;

//        if (!self.baseConTrack.isPlaying) [self.baseConTrack play];
        if (!self.basealterTrack.isPlaying) [self.basealterTrack play];
        if (!self.whaleBreathe.isPlaying) [self.whaleBreathe play];
        if (self.noiseTouchTrack.isPlaying) [self.noiseTouchTrack stop];
    }
}

- (void)relaxView:(RelaxView *)sender isFailingContinously:(BOOL)isFalling
{
    if (isFalling) {
        [self showGuideView];
    }
}


#pragma mark - Initialization

- (void)addStyle
{
    BackgroundColorView *backgroundView = [[BackgroundColorView alloc] init];
    [backgroundView setFrame:self.view.bounds];
    [self.view insertSubview:backgroundView atIndex:0];
    backgroundView.backgroundStyle = BackgroundStyleGreenBall;
    
    //Adding extra blur effect
    self.view.backgroundColor = [UIColor clearColor];
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = self.view.bounds;
    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view insertSubview:blurEffectView atIndex:1];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addStyle];
    self.relaxView.isFirstTimeLaunch = self.isFirstTimeLaunch;
    self.relaxView.upText = self.upText;
    self.relaxView.downText = self.downText;
    self.relaxView.delegate = self;
    [self.relaxView addSubview:self.itemVCBtn];
    
    [self startSounding];
    
    RelaxColorChangeView *relaxColorChangeView = [[RelaxColorChangeView alloc] init];
    [relaxColorChangeView setFrame:self.view.bounds];
    [self.view insertSubview:relaxColorChangeView  atIndex:0];

    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: nil];
    
    self.isProgressMilestoneAccomplished = NO;    
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.basealterTrack.isPlaying) [self.basealterTrack stop];
    
    if (self.baseConTrack.isPlaying) [self.baseConTrack stop];
    
    if (self.noiseTouchTrack.isPlaying) [self.noiseTouchTrack stop];
    
    if (self.whaleBreathe.isPlaying)[self.whaleBreathe stop];
    
    if (self.breathing46.isPlaying) [self.breathing46 stop];
    
    if (self.modwheelCosmosTrack.isPlaying) [self.modwheelCosmosTrack stop];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"didReceiveMemoryWarning!!!! ");
    // TODO: Performace memory warning check
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:SEGUE_OVERVIEWVIEW]) {
        UINavigationController *nav = (UINavigationController *)segue.destinationViewController;
        
        if ([[nav topViewController] isKindOfClass:[OverviewViewController class]]) {
            OverviewViewController *ovc = (OverviewViewController *)[nav topViewController];
            
            if (self.relaxView.sessionRelaxingDurationTime <= 0.001) {
                self.relaxView.sessionRelaxingDurationTime = [[NSUserDefaults standardUserDefaults] floatForKey:RELAXVIEW_LASTRELAXINGSESSIONDURATIONTIME];
            }
            
            ovc.lastRelaxingSessionDurationTimeOverview = self.relaxView.sessionRelaxingDurationTime;
            ovc.totalRelaxingDurationTimeOverview = self.relaxView.totalRelaxingDurationTime;
            ovc.oneDayRelaxingDurationTimeOverview = self.relaxView.oneDayRelaxingDurationTime;
            ovc.totalCompletedSessionsOverview = self.relaxView.totalCompletedSessions;
        }
    }
}

@end
