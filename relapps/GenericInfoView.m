//
//  GenericInfoView.m
//  relapps
//
//  Created by Diego Loop on 26/06/16.
//  Copyright © 2016 Herzly. All rights reserved.
//

#import "GenericInfoView.h"
#import "Data.h"

@implementation GenericInfoView

- (UIButton *)bottomButton
{
    if (!_bottomButton) {
        _bottomButton = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.origin.x,
                                                                   self.bounds.size.height - (MIN_MARGIN_2X),
                                                                   self.bounds.size.width, MIN_MARGIN_2X)];
        _bottomButton.backgroundColor = UIColorFromRGB([Data getInstance].ballColor);
        _bottomButton.tintColor = UIColorFromRGB([Data getInstance].titleColor);
        
        
    }
    return _bottomButton;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    [self setNeedsDisplay];
}

- (void)setText:(NSString *)text
{
    _text = text;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:CORNERN_RADIUS];
    [roundedRect addClip];
    
    [[UIColor whiteColor] setFill];
    UIRectFill(self.bounds);
    [UIColorFromRGB(MODALVIEW_STROKECOLOR) setStroke];
    [roundedRect stroke];
    
    UILabel *title = [[UILabel alloc] init];
    [title setFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, MIN_MARGIN_2X)];
    title.text = self.title;
    title.textColor = UIColorFromRGB(TEXT_COLOR);
    title.textAlignment = NSTextAlignmentCenter;
    [self addSubview:title];
    
    UIView *lineTop = [[UIView alloc] init];
    [lineTop setFrame:CGRectMake(self.bounds.origin.x, MIN_MARGIN_2X, self.bounds.size.width, LINE_SEPARATION_SIZE)];
    lineTop.backgroundColor = UIColorFromRGB(LINE_SEPARATION_COLOR);
    [self addSubview:lineTop];
    
    UIView *lineBottom = [[UIView alloc] init];
    [lineBottom setFrame:CGRectMake(self.bounds.origin.x, self.bounds.size.height - MIN_MARGIN_2X, self.bounds.size.width, LINE_SEPARATION_SIZE)];
    lineBottom.backgroundColor = UIColorFromRGB(LINE_SEPARATION_COLOR);
    [self addSubview:lineBottom];
    
    CGRect frame = CGRectMake(lineTop.frame.origin.x + MIN_MARGIN/2,
                           lineTop.frame.origin.y + lineTop.frame.size.height + MIN_MARGIN/2,
                           self.bounds.size.width - (MIN_MARGIN),
                           lineBottom.frame.origin.y - MIN_MARGIN - lineTop.frame.origin.y - lineTop.frame.size.height);
    
    UITextView *textview = [[UITextView alloc] init];
    textview.text = self.text;
    textview.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    textview.textColor = UIColorFromRGB(TEXT_COLOR);
    textview.userInteractionEnabled = YES;
    textview.editable = NO;
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [scrollView setFrame:frame];
    [textview setFrame:scrollView.bounds];
    [scrollView setBackgroundColor:[UIColor brownColor]];
    
    [scrollView addSubview:textview];
    [self addSubview:scrollView];
    
    
}

- (void)setup
{
    self.backgroundColor = [UIColor clearColor];
    self.contentMode = UIViewContentModeRedraw;
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
