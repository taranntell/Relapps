//
//  SwitchDayView.m
//  relapps
//
//  Created by Diego Loop on 02/08/16.
//  Copyright © 2016 Herzly. All rights reserved.
//

#import "SwitchDayView.h"
#import "Data.h"

@interface SwitchDayView ()
@property (strong, nonatomic) CAShapeLayer *breatheball;
@property (strong, nonatomic) UILabel *dayLabel;
@property (strong, nonatomic) UITapGestureRecognizer *tap;



@end

@implementation SwitchDayView

#pragma mark - Properties

- (void)setTitle:(NSString *)title
{
    _title = title;
    [self addSubview:self.dayLabel];
    [self setNeedsDisplay];
}

- (UITapGestureRecognizer *)tap
{
    if (!_tap) {
        _tap = [[UITapGestureRecognizer alloc] init];
        [_tap addTarget:self action:@selector(pressBall)];
    }
    return _tap;
}

- (UILabel *)dayLabel
{
    if (!_dayLabel) {
        _dayLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _dayLabel.text = self.title;
        _dayLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle3];
        
        [_dayLabel sizeToFit];
        [_dayLabel setCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
        _dayLabel.textColor = UIColorFromRGB([Data getInstance].ballColor);
        [_dayLabel adjustsFontSizeToFitWidth];
        _dayLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _dayLabel;
}

-(CAShapeLayer *)breatheball
{
    if (!_breatheball) {
        _breatheball = [CAShapeLayer layer];
        _breatheball.cornerRadius = self.frame.size.width/4;
        _breatheball.fillColor = [UIColor whiteColor].CGColor;//UIColorFromRGB([Data getInstance].ballColor).CGColor;
        _breatheball.strokeColor = UIColorFromRGB([Data getInstance].ballColor).CGColor;
    }
    return _breatheball;
}

- (void)setIsDaySelected:(BOOL)isDaySelected{
    _isDaySelected = isDaySelected;
    if (_isDaySelected) {
        [self makeBallVisibleSelected];
    }
    
    [self setNeedsDisplay];
}

#pragma mark - Methods

- (void) makeBallVisibleSelected
{
    self.dayLabel.textColor = [UIColor whiteColor];
    self.breatheball.fillColor = UIColorFromRGB([Data getInstance].ballColor).CGColor;
    
    [self.delegate switchDayView:self insertDayWithIndex:self.tag];
}

- (void) makeBallVisibleUnselected
{
    self.dayLabel.textColor = UIColorFromRGB([Data getInstance].ballColor);
    self.breatheball.fillColor = [UIColor whiteColor].CGColor;
    
    [self.delegate switchDayView:self removeDayWithIndex:self.tag];
}

- (void) pressBall
{
    [self.delegate switchDayView:self pressOnDay:YES];
    
    if (!self.isSelected) {
        [self makeBallVisibleSelected];
        self.isSelected = YES;
    }else{
        [self makeBallVisibleUnselected];
        self.isSelected = NO;
    }
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{
    CGPoint p = CGPointMake(0, 0);
    CGSize  s = CGSizeMake(self.frame.size.width, self.frame.size.height);
    
    CGPathRef path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(p.x, p.y, s.width, s.height)
                                                cornerRadius:s.width/2].CGPath;
    self.breatheball.path = path;
    self.breatheball.frame = self.breatheball.bounds = CGPathGetBoundingBox(path);
    [self.layer insertSublayer:self.breatheball atIndex:0];
    
    [self addGestureRecognizer:self.tap];
}


#pragma mark - Initialization

- (void)setup
{
    self.backgroundColor = [UIColor clearColor];
    self.isSelected = NO;
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
