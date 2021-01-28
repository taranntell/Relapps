//
//  GenericOverviewView.m
//  relapps
//
//  Created by Diego Loop on 18/06/16.
//  Copyright © 2016 Herzly. All rights reserved.
//

#import "GenericOverviewView.h"
#import "CircularProgressView.h"
#import "RelaxView.h"
#import "Data.h"

@interface GenericOverviewView ()

@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *bTitle;
@property (nonatomic, strong) UILabel *bText1;
@property (nonatomic, strong) UILabel *bText2;
@property (nonatomic, strong) UILabel *bText3;

@property (nonatomic, strong) CircularProgressView *circularProgressView;

@end

@implementation GenericOverviewView

#pragma mark - Getters

- (UILabel *)title
{
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.frame = CGRectMake(self.lTabBtn.frame.origin.x + self.lTabBtn.frame.size.width,
                                  MIN_MARGIN,
                                  self.frame.size.width - self.lTabBtn.frame.origin.x - (self.lTabBtn.frame.size.width*2) - MIN_MARGIN,
                                  MIN_MARGIN);
        
        _title.textColor = UIColorFromRGB(TEXT_COLOR);
        _title.textAlignment = NSTextAlignmentCenter;
        _title.backgroundColor = [UIColor clearColor];
        _title.text = self.titleText;
        
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
        _subtitle.textColor = UIColorFromRGB(TEXT_COLOR);
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
        _lTabBtn.frame = CGRectMake(MIN_MARGIN, MIN_MARGIN, TAB_BUTTON_SIZE, TAB_BUTTON_SIZE);
        [_lTabBtn setButtonType:self.ltypeb];
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
        [_rTabBtn setButtonType:self.rtype];
    }
    return _rTabBtn;
    
}

- (UILabel *)bTitle
{
    if (!_bTitle) {
        _bTitle = [[UILabel alloc] initWithFrame:CGRectMake(MIN_MARGIN, self.frame.size.height - self.frame.size.height/5, self.frame.size.width - MIN_MARGIN_2X, MIN_MARGIN)];
        _bTitle.textColor = UIColorFromRGB(TEXT_COLOR);
        _bTitle.font = [UIFont boldSystemFontOfSize:[UIFont smallSystemFontSize]];
        _bTitle.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
        _bTitle.text = self.bottomTitle;
    }
    return _bTitle;
}

- (UILabel *)bText1
{
    if (!_bText1) {
        _bText1 = [[UILabel alloc] init];
        CGRect rect = self.bTitle.frame;
        [_bText1 setFrame:CGRectMake(rect.origin.x,
                                     rect.origin.y + rect.size.height,
                                     rect.size.width,
                                     rect.size.height)];
        _bText1.textColor = UIColorFromRGB(TEXT_COLOR);
        _bText1.text = self.bottomText1;
        _bText1.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
    }
    return _bText1;
}

- (UILabel *)bText2
{
    if (!_bText2) {
        _bText2 = [[UILabel alloc] init];
        CGRect rect = self.bText1.frame;
        [_bText2 setFrame:CGRectMake(rect.origin.x,
                                     rect.origin.y + rect.size.height,
                                     rect.size.width,
                                     rect.size.height)];
        _bText2.textColor = UIColorFromRGB(TEXT_COLOR);
        _bText2.text = self.bottomText2;
        _bText2.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
    }
    return _bText2;
}

- (UILabel *)bText3
{
    if (!_bText3) {
        _bText3 = [[UILabel alloc] init];
        CGRect rect = self.bText2.frame;
        [_bText3 setFrame:CGRectMake(rect.origin.x,
                                     rect.origin.y + rect.size.height,
                                     rect.size.width,
                                     rect.size.height)];
        _bText3.textColor = UIColorFromRGB(TEXT_COLOR);
        _bText3.text = self.bottomText3;
        _bText3.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
    }
    return _bText3;
}

#pragma mark - Setters

- (void)setTitleText:(NSString *)titleText
{
    _titleText = titleText;
    [self addSubview:self.title];
    [self setNeedsDisplay];
}

- (void)setSubtitleText:(NSString *)subtitleText
{
    _subtitleText = subtitleText;
    
    self.subtitle.text = _subtitleText;
    
    [self setNeedsDisplay];
}

- (void)setLtypeb:(ButtonStyleType)ltypeb
{
    _ltypeb = ltypeb;
    [self setNeedsDisplay];
    [self addSubview:self.lTabBtn];
    
}

- (void)setRtype:(ButtonStyleType)rtype
{
    _rtype = rtype;
    [self addSubview:self.rTabBtn];
    [self setNeedsDisplay];
}

- (void)setBottomTitle:(NSString *)bottomTitle
{
    _bottomTitle = bottomTitle;
    [self addSubview:self.bTitle];
    [self setNeedsDisplay];
}

- (void)setBottomText1:(NSString *)bottomText1
{
    _bottomText1 = bottomText1;
    [self addSubview:self.bText1];
    [self setNeedsDisplay];
}

- (void)setBottomText2:(NSString *)bottomText2
{
    _bottomText2 = bottomText2;
    [self addSubview:self.bText2];
    [self setNeedsDisplay];
}

- (void)setBottomText3:(NSString *)bottomText3
{
    _bottomText3 = bottomText3;
    [self addSubview:self.bText3];
    [self setNeedsDisplay];
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:BIG_CORNER_RADIUS];
    [roundedRect addClip];
    [UIColorFromRGB(MODALVIEW_BACKCOLOR) setFill];
    UIRectFill(self.bounds);
    [UIColorFromRGB(MODALVIEW_STROKECOLOR) setStroke];
    [roundedRect stroke];
    
    [self addSubview:self.subtitle];
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
