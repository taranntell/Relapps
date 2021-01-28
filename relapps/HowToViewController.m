//
//  HowToViewController.m
//  relapps
//
//  Created by Diego Loop on 18/06/16.
//  Copyright © 2016 Herzly. All rights reserved.
//

#import "HowToViewController.h"
#import "GenericButton.h"
#import "RelaxViewController.h"
#import "IllustrationView.h"
#import "RelaxView.h"
#import "Data.h"
#import "GenericTabBarButton.h"

@interface HowToViewController ()

@property (nonatomic, strong) GenericButton *continueVCBtn;
@property (strong, nonatomic) IllustrationView *illustration;

@property (strong, nonatomic) UILabel *bottomMessage;

@end

@implementation HowToViewController

#pragma mark - Properties

- (UILabel *)bottomMessage
{
    if (!_bottomMessage) {
        static int numberOfLines = 1;
        _bottomMessage = [[UILabel alloc] init];
        CGFloat originY = self.illustration.frame.origin.y + self.illustration.frame.size.height + MIN_MARGIN/2;
        [_bottomMessage setFrame:CGRectMake(self.view.frame.origin.x + MIN_MARGIN_2X,
                                            originY,
                                            self.view.frame.size.width - MIN_MARGIN_2X*2,
                                            MIN_MARGIN*1.5)];
//                                            self.continueVCBtn.frame.origin.y - originY - [Data scaleFactor:self.view.frame.size.height/4])];
        _bottomMessage.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        _bottomMessage.textAlignment = NSTextAlignmentCenter;
        _bottomMessage.textColor = UIColorFromRGB(TEXT_COLOR);
        _bottomMessage.numberOfLines = numberOfLines;
        _bottomMessage.adjustsFontSizeToFitWidth = YES;
        
    }
    return _bottomMessage;
}

- (IllustrationView *)illustration{
    if (!_illustration) {
        _illustration = [[IllustrationView alloc] initWithFrame:CGRectMake(CGPointZero.x,
                                                                           CGPointZero.y,
                                                                           [Data scaleFactor:self.view.bounds.size.height*2.5],
                                                                           [Data scaleFactor:self.view.bounds.size.height*2.5])];
        [_illustration setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/3)];
    }
    return _illustration;
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
    [self performSegueWithIdentifier:SEGUE_RELAXVIEW sender:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.continueVCBtn setTitle:@"Let’s go!" forState:UIControlStateNormal];
    [self.view addSubview:self.continueVCBtn];
    
    self.illustration.image = [UIImage imageNamed:@"headphones.png"];
    [self.view addSubview:self.illustration];
    

    self.bottomMessage.text = @"One last thing - we promise!";//\n\n✓ Plug in your headphones\n✓ Get ready to relax";

    UILabel *midMessage = [[UILabel alloc] initWithFrame:CGRectMake(self.bottomMessage.frame.origin.x,
                                                                    self.bottomMessage.frame.origin.y + self.bottomMessage.frame.size.height,
                                                                    self.bottomMessage.frame.size.width, MIN_MARGIN_2X*2)];
    midMessage.text = @"✓ Plug in your headphones\n✓ Get ready to relax";
    midMessage.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    midMessage.adjustsFontSizeToFitWidth = YES;
    midMessage.numberOfLines = 4;
    midMessage.textColor = UIColorFromRGB(TEXT_COLOR);
    
    UILabel *deepMessage = [[UILabel alloc] initWithFrame:CGRectMake(midMessage.frame.origin.x,
                                                                     midMessage.frame.origin.y + midMessage.frame.size.height,
                                                                     self.bottomMessage.frame.size.width,
                                                                     self.bottomMessage.frame.size.height)];
    deepMessage.text = @"";
    deepMessage.textAlignment = NSTextAlignmentCenter;
    deepMessage.numberOfLines = self.bottomMessage.numberOfLines;
    deepMessage.adjustsFontSizeToFitWidth = YES;
    deepMessage.textColor = UIColorFromRGB(TEXT_COLOR);
    
    [self.view addSubview:self.bottomMessage];
    [self.view addSubview:midMessage];
    [self.view addSubview:deepMessage];

}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    RelaxViewController *rvc =  [segue destinationViewController];
    rvc.upText = @"Inhale... Exhale... Take a deep breath.";
    rvc.downText = @"When ready hold and follow the floating ball.";
    rvc.isFirstTimeLaunch = YES;
    rvc.buttonStyle = ButtonStyleClose;
}

@end
