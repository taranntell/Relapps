//
//  OverviewViewController.m
//  relapps
//
//  Created by Diego Loop on 19/06/16.
//  Copyright © 2016 Herzly. All rights reserved.
//

#import "OverviewViewController.h"
#import "StartViewController.h"
#import "GenericOverviewView.h"
#import "GenericInfoView.h"
#import "GenericButton.h"
#import "BackgroundColorView.h"
#import "RelaxViewController.h"
#import "BreatheBallView.h"
#import "StatisticsView.h"
#import "SettingsTableViewController.h"
#import "Data.h"

@interface OverviewViewController () <SettingsTableViewControllerDelegate>

@property (strong, nonatomic) GenericOverviewView *overviewView;
@property (strong, nonatomic) UIView *infoView;
@property (strong, nonatomic) GenericButton *continueVCBtn;
@property (strong, nonatomic) BreatheBallView *breatheBallView;
@property (strong, nonatomic) UIView *statisticsBaseView;
@property (strong, nonatomic) SettingsTableViewController *settingsTableViewController;

@property (nonatomic) CGFloat scaleBallHeight;
@property (nonatomic) CGFloat scaleBallRadius;

@end

@implementation OverviewViewController

#pragma mark - Properties

- (NSInteger)relaxMinutesGoal
{
    
    _relaxMinutesGoal = [[NSUserDefaults standardUserDefaults] integerForKey:OVERVIEWVIEWCONTROLLER_RELAXMINUTESGOAL];
    if (!_relaxMinutesGoal || isnan(_relaxMinutesGoal)) {
        _relaxMinutesGoal = RELAX_MINUTES_GOAL_DEFAULT;
    }
    return _relaxMinutesGoal;
}

- (CGFloat)scaleBallHeight
{
    if (!_scaleBallHeight) { _scaleBallHeight = [Data scaleFactor:self.view.bounds.size.height]; }
    return _scaleBallHeight;
}

- (CGFloat)scaleBallRadius
{
    if (!_scaleBallRadius) { _scaleBallRadius = self.scaleBallHeight / 2; }
    return _scaleBallRadius;
}

- (BreatheBallView *)breatheBallView
{
    if (!_breatheBallView) {
        _breatheBallView = [[BreatheBallView alloc] init];
        const float ballSize = self.scaleBallRadius*3.0f;
        [_breatheBallView setFrame:CGRectMake(self.overviewView.frame.size.width/2 - (ballSize/2),
                                              (self.statisticsBaseView.frame.origin.y/2) + ((self.overviewView.subtitle.frame.origin.y + self.overviewView.subtitle.frame.size.height)/2) - (ballSize/2),
                                              ballSize, ballSize)];
        
        _breatheBallView.layer.shadowColor = UIColorFromRGB(SHADOW_COLOR).CGColor;
        _breatheBallView.layer.shadowRadius = SHADOW_RADIUS;
        _breatheBallView.layer.shadowOpacity = SHADOW_OPACITY/1.75;
        _breatheBallView.layer.shadowOffset = CGSizeZero;
    }
    return _breatheBallView;
}

- (GenericButton *)continueVCBtn
{
    if (!_continueVCBtn) {
        _continueVCBtn = [[GenericButton alloc] init];
        
        _continueVCBtn.frame = CGRectMake(MIN_MARGIN,
                                          self.view.frame.size.height-MIN_MARGIN-BTNSIZE,
                                          self.view.bounds.size.width-MIN_MARGIN_2X,
                                          BTNSIZE);
        
        [_continueVCBtn addTarget:self
                           action:@selector(showRelaxView:)
                 forControlEvents:UIControlEventTouchDown];
        
        [_continueVCBtn setTitle:@"Start to relax" forState:UIControlStateNormal];
    }
    return _continueVCBtn;
}

-(UIView *)infoView
{
    if (!_infoView) {
        _infoView = [[UIView alloc] init];
        _infoView.backgroundColor = [UIColor grayColor];
        _infoView.alpha = DARK_ALPHA_BACKGROUND;
        _infoView.frame = self.view.bounds;
    }
    return _infoView;
}

- (GenericOverviewView *)overviewView
{
    if (!_overviewView) {
        _overviewView = [[GenericOverviewView alloc] init];
        _overviewView.frame = CGRectMake(MIN_MARGIN,
                                      MIN_MARGIN + self.navigationController.navigationBar.bounds.size.height,
                                      self.view.bounds.size.width - MIN_MARGIN_2X,
                                      self.view.bounds.size.height - self.navigationController.navigationBar.bounds.size.height - (MIN_MARGIN*3) - self.continueVCBtn.frame.size.height);
        
        _overviewView.layer.masksToBounds = NO;
        _overviewView.layer.shadowOffset = CGSizeMake(0, 0);
        _overviewView.layer.shadowColor = [[UIColor blackColor] CGColor];
        _overviewView.layer.shadowRadius = BIG_CORNER_RADIUS;
        _overviewView.layer.shadowOpacity = 0.1f;
        
    }
    return _overviewView;
}

#define STATISTIC_ROWS 3

- (UIView *)statisticsBaseView
{
    
    if (!_statisticsBaseView) {
        
        float statisticSizeRow = self.overviewView.frame.size.height/9;
        
        _statisticsBaseView = [[UIView alloc] init];
        [_statisticsBaseView setFrame:CGRectMake(MIN_MARGIN,
                                                 self.overviewView.frame.size.height - (statisticSizeRow * STATISTIC_ROWS) - MIN_MARGIN,
                                                 self.overviewView.frame.size.width - MIN_MARGIN_2X,
                                                 statisticSizeRow * STATISTIC_ROWS )];
        
        _statisticsBaseView.backgroundColor = UIColorFromRGB(BACKGROUND_STATISTICS_COLOR);
        _statisticsBaseView.layer.cornerRadius = BIG_CORNER_RADIUS;
        _statisticsBaseView.layer.masksToBounds = YES;
        _statisticsBaseView.opaque = NO;
    }
    return _statisticsBaseView;
}

#pragma mark - Methods

- (void)showInfoView:(UIButton*)sender
{
    [[UIApplication sharedApplication].keyWindow addSubview:self.infoView];
    
    GenericInfoView *infoView = [[GenericInfoView alloc] init];
    [infoView setFrame:CGRectMake(MIN_MARGIN_2X,
                self.navigationController.navigationBar.bounds.size.height + (MIN_MARGIN_2X),
                self.view.bounds.size.width - (MIN_MARGIN_2X*2),
                self.view.bounds.size.height - self.navigationController.navigationBar.bounds.size.height-[UIApplication sharedApplication].statusBarFrame.size.height- (MIN_MARGIN_2X*2) )];
    infoView.title = @"Information";
    infoView.text = @"Please note that you can change your daily minutes goal at any time in settings.\n\nYou can also adjust the speed of the relaxation ball as well as its waves.\n\nAdditionally, you can set a reminder, so you won’t miss your next relaxing moment.";
    /*
    infoView.text = @"Taking a moment every day to do some deep breathing can reduce stress, calm the body-mind as well as have long term health benefits.”\nPara Citen\n\nHere are some hints on how to get more of this app. Notice that when you start to relax the ball is green after you finished your goal of the day this will be turned to blue. We use 3 of our 5 sense to get the best of the app.\n\n+ Sight: while you holding the ball the ball will start to move around your display, we use advance curve methods to find the best path to follow.\n\n+ Hearing: With the use of 3D audio you can feel how the vibrations of the spezilized sound will try to flow into your mind.\n\n+ Touch every time you touch the ball and depending on your progress the app will react accordingly this will helps you to concentrate better.\n\nYou can at anytime change the goal of your day in the settings; The speed of the ball and the speed of the waves every time you hold the ball are also customizable. Please don't use this app while driving or on task that need full of your concentration.";
     */
    
    [[UIApplication sharedApplication].keyWindow addSubview:infoView];

    [infoView.bottomButton setTitle:@"Ok, got it" forState:UIControlStateNormal];
    [infoView.bottomButton addTarget:self action:@selector(closeInfoView:) forControlEvents:UIControlEventTouchDown];
    [infoView addSubview:infoView.bottomButton];
    

    
}

- (void)closeInfoView:(UIButton *)sender
{
    [self.infoView removeFromSuperview];
    [sender.superview removeFromSuperview];
}

- (void)showRelaxView:(UIButton*)sender
{
    [self performSegueWithIdentifier:SEGUE_RELAXVIEW sender:self];
}

- (NSString *)updateLastRelaxingDate
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *datetext = [Data formatDate:[defaults objectForKey:RELAXVIEW_ONEDAYRELAXINGDATE] format:@"dd MMMM yyyy" ];
    if (!datetext) {
        datetext = @"Not started yet";
    }
    
    return datetext;
}

- (void) addStatistics
{
    // Math
    
    float percent = [[Data class] findRelaxingPercentUsageGoal:(int)self.relaxMinutesGoal currentTimeInMin:self.oneDayRelaxingDurationTimeOverview];
    percent *= 100;
    
    //BreatheBallView
    self.breatheBallView.dailyProgressPercent = percent;
    
    NSString *end = [[self findProgressActiveTime:self.oneDayRelaxingDurationTimeOverview] objectAtIndex:1];
    if ([end isEqualToString:@"seconds"]) { end = @"sec"; }
    else if ([end isEqualToString:@"minutes"]) { end = @"min"; }
    else if ([end isEqualToString:@"hours"]) { end = @"hrs"; }
    self.breatheBallView.dailyProgressTime = [NSString stringWithFormat:@"%@ %@", [[self findProgressActiveTime:self.oneDayRelaxingDurationTimeOverview] objectAtIndex:0], end];
    
    [self.overviewView addSubview:self.breatheBallView];
    
    
    StatisticsView *lastRelax = [[StatisticsView alloc] init];
    [lastRelax setFrame:CGRectMake(0,0, self.statisticsBaseView.frame.size.width, self.statisticsBaseView.frame.size.height/STATISTIC_ROWS)];
    
    
    lastRelax.titleText = [NSString stringWithFormat:@"Last relaxation time\n%@", [self updateLastRelaxingDate]];
    lastRelax.resultText = [[self findProgressActiveTime:self.lastRelaxingSessionDurationTimeOverview] objectAtIndex:0];
    lastRelax.subresultText = [[self findProgressActiveTime:self.lastRelaxingSessionDurationTimeOverview] objectAtIndex:1];
    lastRelax.image = [UIImage imageNamed:@"brain.png"];
    lastRelax.showSeparationLine = YES;
    
    
    StatisticsView *totalRelax = [[StatisticsView alloc] init];
    [totalRelax setFrame:CGRectMake(lastRelax.frame.origin.x,
                                    lastRelax.frame.origin.y + lastRelax.frame.size.height,
                                    lastRelax.frame.size.width,
                                    lastRelax.frame.size.height)];
    
    totalRelax.titleText = @"Total relaxation time";
    totalRelax.resultText = [[self findProgressActiveTime:self.totalRelaxingDurationTimeOverview] objectAtIndex:0];
    totalRelax.subresultText = [[self findProgressActiveTime:self.totalRelaxingDurationTimeOverview] objectAtIndex:1];
    totalRelax.image = [UIImage imageNamed:@"sessions.png"];
    totalRelax.showSeparationLine = YES;
    
    
    StatisticsView *totalSessions = [[StatisticsView alloc] init];
    [totalSessions setFrame:CGRectMake(totalRelax.frame.origin.x,
                                    totalRelax.frame.origin.y + totalRelax.frame.size.height,
                                    totalRelax.frame.size.width,
                                    totalRelax.frame.size.height)];
    
    totalSessions.titleText = @"Total sessions completed";
    totalSessions.resultText = [NSString stringWithFormat:@"%ld", (long)self.totalCompletedSessionsOverview];
    totalSessions.subresultText = (self.totalCompletedSessionsOverview == 1) ? @"time" : @"times";
    totalSessions.image = [UIImage imageNamed:@"touch.png"];
    
    
    [self.statisticsBaseView addSubview:lastRelax];
    [self.statisticsBaseView addSubview:totalRelax];
    [self.statisticsBaseView addSubview:totalSessions];
    
    [self.overviewView addSubview:self.statisticsBaseView];
}

- (NSArray *)findProgressActiveTime:(float)totalRelaxTime
{
    // Daily Time
    NSArray *hms = [Data hourMinSecFromTimeInterval:totalRelaxTime];
    
    NSString *h = [hms objectAtIndex:0];
    NSString *m = [hms objectAtIndex:1];
    NSString *s = [hms objectAtIndex:2];
    NSString *end = @"minutes";
    if (![h isEqualToString:@"00"]) end = @"hours";
    else if ([h isEqualToString:@"00"] && ![m isEqualToString:@"00"]) end = @"minutes";
    else if ([h isEqualToString:@"00"] &&  [m isEqualToString:@"00"] &&![s isEqualToString:@"00"]) end = @"seconds";
    
    NSString *time = @"00:00";
    if (hms) {
        time = [NSString stringWithFormat:@"%@:%@",
                [hms objectAtIndex:1],
                [hms objectAtIndex:2]];
    }
    NSString *totalTime = @"";
    if (![[hms objectAtIndex:0] isEqualToString:@"0"]){
        totalTime = [NSString stringWithFormat:@"%@:%@", [hms objectAtIndex:0], time];
    }else totalTime = time;
    
    return @[time, end];//  [NSString stringWithFormat:@"%@ %@", time, end];
    
}

#pragma mark - Delegates

- (void)settingsTableViewController:(SettingsTableViewController *)sender updateValues:(BOOL)isUpdate
{
    
    if (isUpdate) {
        self.overviewView.subtitleText = [NSString stringWithFormat:@"Relaxing goal of %d min per day", (int)self.relaxMinutesGoal];
        [self addStatistics];
    }
}

#pragma mark - Initialization

- (void)addStyle
{
    BackgroundColorView *backgroundView = [[BackgroundColorView alloc] init];
    [backgroundView setFrame:self.view.bounds];
    [self.view insertSubview:backgroundView atIndex:0];
    backgroundView.backgroundStyle = BackgroundStyleGreenBall;
    
    //    self.navigationItem.rightBarButtonItem.tintColor = self.navigationItem.leftBarButtonItem.tintColor = UIColorFromRGB([Data getInstance].ballColor);
    self.navigationItem.rightBarButtonItem.tintColor = self.navigationItem.leftBarButtonItem.tintColor = UIColorFromRGB(TABBAR_DARK_GREEN_TINT_COLOR);
    
    //Adding extra blur effect
    self.view.backgroundColor = [UIColor clearColor];
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = self.view.bounds;
    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:blurEffectView];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addStyle];
    
    [StartViewController styleNavigationBar:[self navigationController].navigationBar];    
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];

    self.overviewView.rtype = ButtonStyleInfo;
    [self.overviewView.rTabBtn addTarget:self action:@selector(showInfoView:) forControlEvents:UIControlEventTouchDown];
    
    self.overviewView.titleText = @"Daily progress";
    self.overviewView.subtitleText = [NSString stringWithFormat:@"Goal for relaxation time of %d min per day", (int)self.relaxMinutesGoal];
    
    [self.view addSubview:self.overviewView];
    
    [self addStatistics];
    
    [self.view addSubview:self.continueVCBtn];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:SEGUE_ABOUT]) {
        [segue destinationViewController].navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                                                  style:UIBarButtonItemStylePlain
                                                                                                 target:nil action:nil];
        [[segue destinationViewController] setTitle:@"Info"];
        [[segue destinationViewController].navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
    
    }else if ([segue.identifier isEqualToString:SEGUE_RELAXVIEW]){
        RelaxViewController *rvc = [segue destinationViewController];
        
        Data *data = [[Data alloc] init];
        rvc.upText = [[[data getRandomQuote] allValues] objectAtIndex:0];
        rvc.downText = [NSString stringWithFormat:@"— %@", [[[data getRandomQuote] allKeys] objectAtIndex:0]];
        rvc.buttonStyle = ButtonStyleCalmoff;
    
    }else if ([segue.identifier isEqualToString:SEGUE_SETTINGS]){
        SettingsTableViewController *settings = [segue destinationViewController];
        settings.title = @"Settings";
        settings.delegate = self;
        
    }
}


@end
