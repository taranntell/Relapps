//
//  CircularProgressView.m
//  relapps
//
//  Created by Diego Loop on 05/07/16.
//  Copyright © 2016 Herzly. All rights reserved.
//

#import "CircularProgressView.h"
#import "Data.h"

@interface CircularProgressView ()

@property (nonatomic, strong) UILabel *percent;
@property (nonatomic, strong) UILabel *time;

@end

@implementation CircularProgressView


#pragma mark - Properties

- (UILabel *)percent{
    if (!_percent) {
        _percent = [[UILabel alloc] init];
        [_percent setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height/2)];
        _percent.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle3];
        _percent.text = [NSString stringWithFormat:@"%d%%", (int)self.dailyProgressPercent];
        _percent.font = [UIFont systemFontOfSize:50];
        [_percent sizeToFit];
        [_percent setCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2.25)];
        _percent.textColor = [UIColor lightGrayColor];
        _percent.textAlignment = NSTextAlignmentCenter;
    }
    return _percent;
}

- (UILabel *)time{
    if (!_time) {
        _time = [[UILabel alloc] init];
        [_time setFrame:CGRectMake(self.frame.origin.x,
                                   self.percent.frame.origin.y + self.percent.frame.size.height + 5,
                                   self.frame.size.width, self.frame.size.height/2)];
        _time.text = self.dailyProgressTime;
        _time.textAlignment = NSTextAlignmentCenter;
        _time.font = [UIFont systemFontOfSize:22];
        _time.textColor = [UIColor lightGrayColor];
        [_time sizeToFit];
        [_time setCenter:CGPointMake(self.frame.size.width/2, self.percent.frame.origin.y + self.percent.frame.size.height)];
    }
    return _time;
}

- (void)setDailyProgressPercent:(CGFloat)dailyProgressPercent
{
    _dailyProgressPercent = dailyProgressPercent;
    [self addSubview:self.percent];
    [self setNeedsDisplay];
}

- (void)setDailyProgressTime:(NSString *)dailyProgressTime
{
    _dailyProgressTime = dailyProgressTime;
    [self addSubview:self.time];
    [self setNeedsDisplay];
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{
    [self addSubview:self.time];
    
    const float radiusFac = 2.2f;
    const float startAngle = M_PI * 1.5;
    const float endAngle = startAngle + (M_PI * 2);
    const int barwidth = 4;
    
    
    // This implementation creates a two arcs, the base is highlighted green
    // the bezierprogress overlaps the base with gray color.
    UIBezierPath *bezierBase = [UIBezierPath bezierPath];
    [bezierBase addArcWithCenter:CGPointMake(rect.size.width/2, rect.size.height/2)
                          radius:rect.size.width/radiusFac
                      startAngle: startAngle
                        endAngle: (endAngle - startAngle) + startAngle
                       clockwise:YES];
    // Set the display for the path, and stroke it
    bezierBase.lineWidth = barwidth;
    if (self.dailyProgressPercent <= 0) { [[UIColor lightGrayColor] setStroke]; }
    else { [UIColorFromRGB([Data getInstance].ballColor) setStroke]; }
    
    [bezierBase stroke];
    
    
    
    UIBezierPath *bezierProgress = [UIBezierPath bezierPath];
    [bezierProgress addArcWithCenter:CGPointMake(rect.size.width/2, rect.size.height/2)
                              radius:rect.size.width/radiusFac
                          startAngle:startAngle
                            endAngle:(endAngle - startAngle) * (self.dailyProgressPercent / 100.0) + startAngle
                           clockwise:NO];
    
    bezierProgress.lineWidth = barwidth;
    [[UIColor lightGrayColor] setStroke];
    [bezierProgress stroke];
    
}

#pragma mark - Initialization

- (void)setup
{
    self.contentMode = UIViewContentModeRedraw;
    self.frame = self.superview.frame;
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
    if (self) {
        [self setup];
    }
    return self;
}



@end
