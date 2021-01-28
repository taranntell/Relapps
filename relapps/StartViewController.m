//
//  StartViewController.m
//  relapps
//
//  Created by Diego Loop on 15/06/16.
//  Copyright © 2016 Herzly. All rights reserved.
//

#import "StartViewController.h"
#import "OverviewViewController.h"
#import "GenericButton.h"
#import "IllustrationView.h"
#import "Data.h"

@interface StartViewController ()

@property (strong, nonatomic) GenericButton *continueVCBtn;
@property (strong, nonatomic) IllustrationView *illustration;

@property (strong, nonatomic) UILabel *bottomMessage;

@end

@implementation StartViewController

#pragma mark - Properties

- (IllustrationView *)illustration
{
    if (!_illustration) {
        _illustration = [[IllustrationView alloc] initWithFrame:CGRectMake(CGPointZero.x,
                                                                           CGPointZero.y,
                                                                           [Data scaleFactor:self.view.bounds.size.height*2.5],
                                                                           [Data scaleFactor:self.view.bounds.size.height*2.5])];
        [_illustration setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/3)];
    }
    return _illustration;

}

- (UILabel *)bottomMessage
{
    if (!_bottomMessage) {
        static int numberOfLines = 1;
        _bottomMessage = [[UILabel alloc] init];
        CGFloat originY = self.illustration.frame.origin.y + self.illustration.frame.size.height + MIN_MARGIN/2;
        [_bottomMessage setFrame:CGRectMake(self.view.frame.origin.x + MIN_MARGIN_2X,
                                            originY,
                                            self.view.frame.size.width - MIN_MARGIN_2X*2,
                                            MIN_MARGIN*1.5) ];
//                                            self.continueVCBtn.frame.origin.y - originY - [Data scaleFactor:self.view.frame.size.height/4])];
        _bottomMessage.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        _bottomMessage.textAlignment = NSTextAlignmentCenter;
        _bottomMessage.textColor = UIColorFromRGB(TEXT_COLOR);
        _bottomMessage.numberOfLines = numberOfLines;
        _bottomMessage.adjustsFontSizeToFitWidth = YES;
        
    }
    return _bottomMessage;
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
    }
    return _continueVCBtn;
}

- (void)showRelaxView:(UIButton*)sender
{
    [self performSegueWithIdentifier:SEGUE_FINDPLACEVIEW sender:self];
}

+ (void)styleNavigationBar:(UINavigationBar *)navbar
{
    //Hide NavigationController. ! Just in this view
    //[[self navigationController] setNavigationBarHidden:YES];
    
    // Making NavigationBar transparent
    [navbar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    navbar.shadowImage = [UIImage new];
    navbar.tintColor = UIColorFromRGB([Data getInstance].ballColor);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    /* increasing size (height) of navigation controller
    UINavigationBar *navigationBar = [[self navigationController] navigationBar];
    CGRect frame = [navigationBar frame];
    frame.size.height = frame.size.height*2;
    [navigationBar setFrame:frame];
     */
}

#define BUTTON_TITEL_TEXT @"Start improving"

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    
    self.title = @"Good to see you here!";
    
    [[self class] styleNavigationBar:[self navigationController].navigationBar];
    
    // Overrides the text in back button item
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil action:nil];
    
    [self.continueVCBtn setTitle:BUTTON_TITEL_TEXT forState:UIControlStateNormal];
    [self.view addSubview:self.continueVCBtn];
    
    self.illustration.image = [UIImage imageNamed:@"meditationlight.png"];
    [self.view addSubview:self.illustration];
    
    self.bottomMessage.text = [NSString stringWithFormat:@"This is what it’s all about:"]; //\n\n✓ Reduce your daily stress\n✓ Take only a few minutes\n✓ Use hearing, sight & touch\n\n→ Improve your day"];
    
    UILabel *midMessage = [[UILabel alloc] initWithFrame:CGRectMake(self.bottomMessage.frame.origin.x,
                                                                    self.bottomMessage.frame.origin.y + self.bottomMessage.frame.size.height,
                                                                    self.bottomMessage.frame.size.width, MIN_MARGIN_2X*2)];
    midMessage.text = @"✓ Reduce your daily stress\n✓ Take only a few minutes\n✓ Use hearing, sight & touch";
    midMessage.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    midMessage.adjustsFontSizeToFitWidth = YES;
    midMessage.numberOfLines = 4;
    midMessage.textColor = UIColorFromRGB(TEXT_COLOR);
    
    UILabel *deepMessage = [[UILabel alloc] initWithFrame:CGRectMake(midMessage.frame.origin.x,
                                                              midMessage.frame.origin.y + midMessage.frame.size.height,
                                                              self.bottomMessage.frame.size.width,
                                                              self.bottomMessage.frame.size.height)];
    deepMessage.text = @"→ Improve your day";
    deepMessage.textAlignment = NSTextAlignmentCenter;
    deepMessage.numberOfLines = self.bottomMessage.numberOfLines;
    deepMessage.adjustsFontSizeToFitWidth = YES;
    deepMessage.textColor = UIColorFromRGB(TEXT_COLOR);
    
    [self.view addSubview:self.bottomMessage];
    [self.view addSubview:midMessage];
    [self.view addSubview:deepMessage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
