//
//  GuideView.m
//  relapps
//
//  Created by Diego Loop on 11/08/16.
//  Copyright © 2016 Herzly. All rights reserved.
//

#import "GuideView.h"
#import "Data.h"

@interface GuideView ()

@property (nonatomic) CGFloat scaleBallHeight;
@property (nonatomic) CGFloat scaleBallRadius;

@property (strong, nonatomic) UIImageView *guideImgView;
@property (strong, nonatomic) UILabel *textIndicator;

@end

@implementation GuideView

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

- (UIImageView *)guideImgView
{
    if (!_guideImgView) {
        _guideImgView = [[UIImageView alloc] initWithFrame:CGRectMake(CGPointZero.x, CGPointZero.x, self.bounds.size.width/1.5, self.bounds.size.width/1.5)];
        [_guideImgView setCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/1.7)];
        _guideImgView.image = self.guideImage;
        
    }
    return _guideImgView;
}

- (UILabel *)textIndicator
{
    if (!_textIndicator) {
        _textIndicator = [[UILabel alloc] initWithFrame:CGRectMake(CGPointZero.x + (MIN_MARGIN/2),
                                                                   self.frame.size.height - MIN_MARGIN_2X*2,
                                                                   self.frame.size.width - MIN_MARGIN,
                                                                   MIN_MARGIN_2X)];
        _textIndicator.text = self.text;
        _textIndicator.textAlignment = NSTextAlignmentCenter;
        _textIndicator.textColor = UIColorFromRGB(TEXT_COLOR);
        _textIndicator.adjustsFontSizeToFitWidth = YES;
    }
    return _textIndicator;
}

- (void)setRtype:(ButtonStyleType)rtype
{
    _rtype = rtype;
    [self addSubview:self.rTabBtn];
    [self setNeedsDisplay];
}

- (void)setGuideImage:(UIImage *)guideImage
{
    _guideImage = guideImage;
    [self setNeedsDisplay];
    [self addSubview:self.guideImgView];
}

- (void)setText:(NSString *)text
{
    _text = text;
    [self setNeedsDisplay];
    [self addSubview:self.textIndicator];
}

#pragma mark - Drawing

- (void)startMovingAnimation
{
    [UIView animateWithDuration:8.f delay:1 options:UIViewAnimationOptionRepeat animations:^{
        [self.guideImgView setFrame:CGRectMake(self.guideImgView.frame.origin.x,
                                               self.bounds.origin.y + MIN_MARGIN_2X,
                                               self.guideImgView.frame.size.width,
                                               self.guideImgView.frame.size.height)];
    } completion:^(BOOL finished) { }];
}


- (void)drawRect:(CGRect)rect
{
    
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:CORNERN_RADIUS];
    [roundedRect addClip];
    [UIColorFromRGB(MODALVIEW_BACKCOLOR) setFill];
    UIRectFill(self.bounds);
    [UIColorFromRGB(MODALVIEW_STROKECOLOR) setStroke];
    [roundedRect stroke];
}

#pragma mark - Initialization

- (void)setup
{
    self.contentMode = UIViewContentModeRedraw;
    self.backgroundColor = [UIColor clearColor];
    self.opaque = NO;
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
