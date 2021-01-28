//
//  GenericModalView.m
//  relapps
//
//  Created by Diego Loop on 18/06/16.
//  Copyright © 2016 Herzly. All rights reserved.
//

#import "GenericModalView.h"
#import "RelaxView.h"
#import "Data.h"

@interface GenericModalView ()

@property (nonatomic) CGFloat scaleBallHeight;
@property (nonatomic) CGFloat scaleBallRadius;

@end

@implementation GenericModalView

#pragma mark - Properties

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

- (UIView *)totalTimeOverview
{
    if (!_totalTimeOverview) {
        int height = 40; // TODO: scale it depending the display
        _totalTimeOverview = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - (self.breathBall.frame.size.width/2),
                                                             self.frame.size.height/2 - (height/1.5), // 1.5 is for the "current peace" title
                                                             self.breathBall.frame.size.width,
                                                             height)];
        _totalTimeOverview.backgroundColor = [UIColor clearColor];
        
    }
    return _totalTimeOverview;
}

- (UILabel *)title
{
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.frame = CGRectMake(self.lTabBtn.frame.origin.x + self.lTabBtn.frame.size.width,
                                  MIN_MARGIN_2X,
                                  self.frame.size.width - self.lTabBtn.frame.origin.x - (self.lTabBtn.frame.size.width*2) - MIN_MARGIN,
                                  MIN_MARGIN_2X);
        
        _title.textColor = [UIColor darkGrayColor];
        _title.textAlignment = NSTextAlignmentCenter;
        _title.backgroundColor = [UIColor clearColor];
    }
    return _title;
}

- (UILabel *)subtitle
{
    if (!_subtitle) {
        _subtitle = [[UILabel alloc] init];
        
        CGRect frame = self.title.frame;
        frame.origin = CGPointMake(frame.origin.x, self.title.frame.origin.y + self.title.frame.size.height);
        _subtitle.frame = frame;
        _subtitle.textColor = [UIColor darkGrayColor];
        _subtitle.textAlignment = NSTextAlignmentCenter;
        _subtitle.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
        _subtitle.backgroundColor = [UIColor clearColor];
    }
    return _subtitle;
}

- (GenericTabBarButton *)lTabBtn
{
    if (!_lTabBtn) {
        _lTabBtn = [[GenericTabBarButton alloc] init];
        _lTabBtn.frame = CGRectMake(MIN_MARGIN_2X, MIN_MARGIN_2X, TAB_BUTTON_SIZE, TAB_BUTTON_SIZE);
    }
    return _lTabBtn;
}

- (GenericTabBarButton *)rTabBtn
{
    if (!_rTabBtn) {
        _rTabBtn = [[GenericTabBarButton alloc] init];
        _rTabBtn.frame = CGRectMake(self.frame.size.width - TAB_BUTTON_SIZE - MIN_MARGIN,
                                    MIN_MARGIN,
                                    TAB_BUTTON_SIZE, TAB_BUTTON_SIZE);
    }
    return _rTabBtn;
}

- (CAShapeLayer *)breathBall
{
    if (!_breathBall) {
        _breathBall = [CAShapeLayer layer];
        _breathBall.fillColor = UIColorFromRGB([Data getInstance].ballColor).CGColor;
//        _breathBall.delegate = self;
        
        CGRect surface = CGRectMake(self.frame.size.width/2  -(self.scaleBallRadius*2),
                                    self.frame.size.height/2 -(self.scaleBallRadius*2), self.scaleBallRadius*4.0f, self.scaleBallRadius*4.0f);
        CGPathRef path = [UIBezierPath bezierPathWithRoundedRect:surface cornerRadius:surface.size.width].CGPath;
        
        _breathBall.path = path;
        _breathBall.frame  = _breathBall.bounds = CGPathGetPathBoundingBox(path);
        _breathBall.cornerRadius = surface.size.width;
    }
    return _breathBall;
}

- (GenericButton *)continueBtn
{
    
    if (!_continueBtn) {
        _continueBtn = [[GenericButton alloc] init];
        
        _continueBtn.frame = CGRectMake(MIN_MARGIN_2X,
                                        self.frame.size.height-MIN_MARGIN_2X-BTNSIZE,
                                        self.bounds.size.width-(MIN_MARGIN_2X*2),
                                        BTNSIZE);
    }
    return _continueBtn;
}

- (UIView *)bottomSeparationLine
{
    if (!_bottomSeparationLine) {
        _bottomSeparationLine = [[UIView alloc] init];
        _bottomSeparationLine.backgroundColor = UIColorFromRGB(LINE_SEPARATION_COLOR); // TODO: Magic Number
        
        if (self.continueBtn) {
            [_bottomSeparationLine setFrame:CGRectMake(self.bounds.origin.x,
                                      self.continueBtn.frame.origin.y - MIN_MARGIN_2X,
                                      self.frame.size.width,
                                      LINE_SEPARATION_SIZE)];
        }
    }
    return _bottomSeparationLine;
}

- (UIView *)relaxProgressView
{
    if (!_relaxProgressView) {
        _relaxProgressView = [[UIView alloc] init];
        float height = [UIFont smallSystemFontSize]*3;
        [_relaxProgressView setFrame:CGRectMake(self.bounds.origin.x + MIN_MARGIN_2X,
                                                self.bottomSeparationLine.frame.origin.y - MIN_MARGIN_2X - height,
                                                self.bounds.size.width - (MIN_MARGIN_2X*2),
                                                height)];
    }
    return _relaxProgressView;

}

#pragma mark - Drawing

- (void)addTopTitle:(NSString*)text
{
    self.title.text = text;
    
    [self.title setNeedsDisplayInRect:self.frame];
    [self addSubview:self.title];
}

- (void)addTopSubtitle:(NSString*)text
{
    self.subtitle.text = text;
    
    [self.subtitle setNeedsDisplayInRect:self.frame];
    [self addSubview:self.subtitle];
}

- (void)addLeftTabBtn:(ButtonStyleType)type
{
    [self.lTabBtn setButtonType:type];
    [self.lTabBtn setNeedsDisplayInRect:self.frame];
    [self addSubview:self.lTabBtn];
}

- (void)addRightTabBtn:(ButtonStyleType)type
{
    [self.rTabBtn setButtonType:type];
    [self.rTabBtn setNeedsDisplayInRect:self.frame];
    [self addSubview:self.rTabBtn];
}

#define SCALE_HHMM_FONT_FACTOR 0.37
#define SCALE_SS_FONT_FACTOR 1.6

- (void)addBigTime:(NSTimeInterval)time
{
    [self addSubview:self.totalTimeOverview];
    [self sendSubviewToBack:self.totalTimeOverview];
    
    CGRect timeframe = self.totalTimeOverview.bounds;
    UIColor *textColor = UIColorFromRGB(0xfdfdfd);
    UIColor *backColor = [UIColor clearColor];
    
    NSArray *hms = [Data hourMinSecFromTimeInterval:time];
    NSString *hrs =  @"";
    NSString *min = [hms objectAtIndex:1];
    NSString *sec = [NSString stringWithFormat:@".%@",[hms objectAtIndex:2]];
    
    //TODO: Add adjust for font, depending on the width of the font space reduce it
    
    int extra = 0; // TODO: <- Must be 0, 20 is just for test porpouses
    if (![[hms objectAtIndex:0] isEqualToString:@"00"]){
        // Hours will be added if there are any
        hrs = [NSString stringWithFormat:@"%@:", [hms objectAtIndex:0]];
        extra = 20;
    }
    
    UILabel *hm = [[UILabel alloc] initWithFrame:CGRectMake(timeframe.origin.x,
                                                            timeframe.origin.y,
                                                            timeframe.size.width/2 + extra,
                                                            timeframe.size.height)];
    
    hm.text = [NSString stringWithFormat:@"%@%@",hrs,min];
    hm.textColor = textColor;
    hm.backgroundColor = backColor;
    hm.textAlignment = NSTextAlignmentRight;
    hm.font = [UIFont systemFontOfSize:(self.scaleBallHeight*SCALE_HHMM_FONT_FACTOR)];
    
    [self.totalTimeOverview addSubview:hm];
    
    
    UILabel *s = [[UILabel alloc] initWithFrame:CGRectMake(hm.frame.origin.x + hm.frame.size.width,
                                                           hm.frame.origin.y + 5,
                                                           hm.frame.size.width - (extra*2),
                                                           hm.frame.size.height/2)];
    s.text = sec;
    s.textColor = textColor;
    s.backgroundColor = backColor;
    s.textAlignment = NSTextAlignmentLeft;
    s.font = [UIFont systemFontOfSize:(self.scaleBallHeight*SCALE_HHMM_FONT_FACTOR)/SCALE_SS_FONT_FACTOR];
    [self.totalTimeOverview addSubview:s];
    
    [self bringSubviewToFront:s];
    [self bringSubviewToFront:hm];
    
    UILabel *timetext = [[UILabel alloc] initWithFrame:CGRectMake(timeframe.origin.x, hm.bounds.origin.y + (hm.bounds.size.height/1.8),
                                                                  timeframe.size.width, timeframe.size.height)];
    timetext.text = @"Current Peace";
    timetext.textColor = textColor;
    timetext.backgroundColor = backColor;
    timetext.textAlignment = NSTextAlignmentCenter;
    timetext.font = [UIFont systemFontOfSize:(self.scaleBallHeight*SCALE_HHMM_FONT_FACTOR)/(SCALE_SS_FONT_FACTOR*1.5)];
    [self.totalTimeOverview addSubview:timetext];
    
    
    
    [self.totalTimeOverview setNeedsDisplayInRect:self.frame];
    
}

- (void)addBreathingBall
{
    
    // TODO: to implement or delete
    // Adding breathing ball! This is not an option, it has to be implemented
    RelaxView *relaxView = [[RelaxView alloc] init];
    [relaxView setFrame:self.frame];
    if (self.totalTimeOverview) {
        // Since totalTimeOverview is optional, it will added below it just when it exists
        [self.layer insertSublayer:self.breathBall below:self.totalTimeOverview.layer];
    }else{
        [self.layer addSublayer:self.breathBall];
    }
    
    // TODO: Remove Magic Number
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [relaxView startBreathing:self.breathBall duration:RELAX_BREATHE_DURATION_DEFAULT layersize:self.scaleBallHeight*1.5];
    });
    
    
}

- (void)addBottomSeparationLine
{
    [self addSubview:self.bottomSeparationLine];
}

- (void)addRelaxViewWithProgress:(float)progress totaltime:(float)totaltime
{
    float smallsysfontHeight = [UIFont smallSystemFontSize] * 1.3; // TODO: Magic number
    
    UILabel *topleft = [[UILabel alloc] init];
    topleft.text = @"Daily progress"; // TODO: Magic Number - Title
    [topleft setFrame:CGRectMake(self.relaxProgressView.bounds.origin.x,
                                 self.relaxProgressView.bounds.origin.y,
                                 self.relaxProgressView.bounds.size.width/2,
                                 smallsysfontHeight)];
    
    UILabel *topright = [[UILabel alloc] init];
    [topright setFrame:CGRectMake(self.relaxProgressView.bounds.origin.x + self.relaxProgressView.bounds.size.width/2,
                                  self.relaxProgressView.bounds.origin.y,
                                  self.relaxProgressView.bounds.size.width/2,
                                  smallsysfontHeight)];
    topright.text = [NSString stringWithFormat:@"%d%%", (int)(progress * 100)];
    topright.textAlignment = NSTextAlignmentRight;
    
    UIProgressView *bar = [[UIProgressView alloc] init];
    [bar setFrame:CGRectMake(self.relaxProgressView.bounds.origin.x,
                            topleft.bounds.size.height* 1.2,
                            self.relaxProgressView.bounds.size.width,
                             0)];
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 3.0f); // TODO: Magic Number
    bar.transform = transform;
    bar.progress = progress; // TODO: Magic Number
    bar.progressTintColor = UIColorFromRGB([Data getInstance].ballColor);
    
    UILabel *left = [[UILabel alloc] init];
    left.text = @""; // Not used at the time
    [left setFrame:CGRectMake(self.relaxProgressView.bounds.origin.x,
                              (topleft.bounds.size.height + bar.transform.d + bar.bounds.size.height)*1.2,
                              self.relaxProgressView.bounds.size.width/2,
                              topleft.bounds.size.height)];
    
    UILabel *right = [[UILabel alloc] init];
    NSArray *hms = [Data hourMinSecFromTimeInterval:totaltime];
    right.text = @"0:00:00";
    if (hms) {
        right.text = [NSString stringWithFormat:@"%@:%@:%@",
                     [hms objectAtIndex:0],
                     [hms objectAtIndex:1],
                     [hms objectAtIndex:2]];
    }
    
    right.textAlignment = NSTextAlignmentRight;
    [right setFrame:CGRectMake(self.relaxProgressView.bounds.origin.x + self.relaxProgressView.bounds.size.width/2,
                               (topleft.bounds.size.height + bar.transform.d + bar.bounds.size.height)*1.2,
                               self.relaxProgressView.bounds.size.width/2,
                               topleft.bounds.size.height)];
    
    right.textColor = left.textColor = topleft.textColor = topright.textColor = [UIColor darkGrayColor];
    right.font = left.font = topleft.font = topright.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
    
    
    [self addSubview:self.relaxProgressView];
    
    [self.relaxProgressView addSubview:topleft];
    [self.relaxProgressView addSubview:topright];
    [self.relaxProgressView addSubview:bar];
    [self.relaxProgressView addSubview:left];
    [self.relaxProgressView addSubview:right];
}

- (void)addContinueBtn:(NSString*)title forState:(UIControlState)state
{    
    [self.continueBtn setTitle:title forState:state];
    [self addSubview:self.continueBtn];
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
//    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:BIG_CORNER_RADIUS];
    [roundedRect addClip];
    [UIColorFromRGB(MODALVIEW_BACKCOLOR) setFill];
    UIRectFill(self.bounds);
    [UIColorFromRGB(MODALVIEW_STROKECOLOR) setStroke];
    [roundedRect stroke];
    
    
    [self addBreathingBall];
    

}

#pragma mark - Initialization

- (void)setup
{
    self.contentMode = UIViewContentModeRedraw;
    self.frame = self.superview.frame;
    self.backgroundColor = [UIColor clearColor];
    
    
    // TODO: Add design curves
    
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
