//
//  StatisticsView.m
//  relapps
//
//  Created by Diego Loop on 10/07/16.
//  Copyright © 2016 Herzly. All rights reserved.
//

#import "StatisticsView.h"
#import "Data.h"

@interface StatisticsView ()

@property (strong, nonatomic) UIView *resultView;

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *title;
@property (strong, nonatomic) UILabel *subtitle;
@property (strong, nonatomic) UILabel *result;
@property (strong, nonatomic) UILabel *subresult;
@property (strong, nonatomic) UIFont *bigFont;
@property (strong, nonatomic) UIView *separationLine;

@end

@implementation StatisticsView

#pragma mark - Properties

- (UIView *)separationLine
{
    if (!_separationLine) {
        const int lineSize = 1;
        _separationLine = [[UIView alloc] init];
        [_separationLine setFrame:CGRectMake(MIN_MARGIN, self.frame.size.height - lineSize, self.frame.size.width - MIN_MARGIN_2X, lineSize)];
        _separationLine.backgroundColor = UIColorFromRGB(LIGHT_LINE_SEPARATION_COLOR);
    }
    return _separationLine;
}

- (UIView *)resultView
{
    if (!_resultView) {
        _resultView = [[UIView alloc] init];
        [_resultView setFrame:CGRectMake(CGPointZero.x,CGPointZero.y,
                                        self.title.frame.size.width,
                                        self.frame.size.height/1.25)];
        
        _resultView.center = CGPointMake(self.bounds.size.width - (self.title.bounds.size.width/2),
                                         self.bounds.size.height/2);
    
    }
    return _resultView;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        
        CGRect rect = CGRectMake(MIN_MARGIN/3,MIN_MARGIN/3,
                                 [Data scaleFactor:self.bounds.size.height*4.3],
                                 [Data scaleFactor:self.bounds.size.height*4.3]);
        [_imageView sizeToFit];
        [_imageView setFrame:rect];
        _imageView.center = CGPointMake(self.title.frame.origin.x/2, self.bounds.size.height/2);
        [_imageView setImage:self.image];
    }
    return _imageView;
}

- (UILabel *)title
{
    if (!_title) {
        _title = [[UILabel alloc] init];
        [_title setFrame:CGRectMake(CGPointZero.x,CGPointZero.y,
                                    ((self.frame.size.width*3)/8),
                                    [Data scaleFactor:self.bounds.size.height*4.3])];
        
        _title.center = CGPointMake(self.frame.size.width/2-([Data scaleFactor:self.bounds.size.height*4.3])/2, self.bounds.size.height/2);
        _title.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        
        _title.textColor = UIColorFromRGB(TEXT_COLOR);
        _title.text = self.titleText;
        _title.adjustsFontSizeToFitWidth = YES;
        _title.numberOfLines = 2;
    }
    return _title;
}

- (UILabel *)subtitle
{
    if (!_subtitle) {
        _subtitle = [[UILabel alloc] init];
        [_subtitle setFrame:CGRectMake(self.title.frame.origin.x,
                                      self.title.frame.origin.y + self.title.frame.size.height,
                                      self.title.frame.size.width,
                                       self.frame.size.height - self.title.frame.size.height - (MIN_MARGIN))];
        _subtitle.backgroundColor = [UIColor blueColor];
        _subtitle.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
        _subtitle.textColor = UIColorFromRGB(TEXT_COLOR);
        _subtitle.text = self.subtitleText;
        _subtitle.adjustsFontSizeToFitWidth = YES;
        _subtitle.numberOfLines = 1;
        _subtitle.backgroundColor = [UIColor greenColor];
    }
    return _subtitle;

}

- (UILabel *)result
{
    if (!_result) {
        _result = [[UILabel alloc] init];
        [_result setFrame:CGRectMake(0,0,
                                    self.resultView.frame.size.width,
                                     self.resultView.frame.size.height/1.7)];
        
        _result.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle3];
        _result.textColor = UIColorFromRGB(TEXT_COLOR);
        _result.text = self.resultText;
        _result.adjustsFontSizeToFitWidth = YES;
        _result.textAlignment = NSTextAlignmentCenter;
        _result.numberOfLines = 1;
        
        
        
    }
    return _result;
}

- (UILabel *)subresult
{
    if (!_subresult) {
        _subresult = [[UILabel alloc] init];
        [_subresult setFrame:CGRectMake(self.result.frame.origin.x,
                                       self.result.frame.origin.y + self.result.frame.size.height,
                                       self.result.frame.size.width,
                                        self.resultView.frame.size.height - self.result.frame.size.height)];
//                                        [UIFont smallSystemFontSize]*1.5)];
        
        _subresult.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
        _subresult.textColor = UIColorFromRGB(TEXT_COLOR);
        _subresult.text = self.subresultText;
        _subresult.textAlignment = NSTextAlignmentCenter;
        _subresult.adjustsFontSizeToFitWidth = YES;
        _subresult.numberOfLines = 1;
        
    }
    return _subresult;

}

- (void)setShowSeparationLine:(BOOL)showSeparationLine
{
    _showSeparationLine = showSeparationLine;
    
    if (_showSeparationLine) {
        [self addSubview:self.separationLine];
    }
    
    [self setNeedsDisplay];
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    [self addSubview:self.imageView];
    [self setNeedsDisplay];
}

- (void)setTitleText:(NSString *)titleText
{
    _titleText = titleText;
    [self addSubview:self.title];
    [self setNeedsDisplay];
}

- (void)setSubtitleText:(NSString *)subtitleText
{
    _subtitleText = subtitleText;
    [self addSubview:self.subtitle];
    [self setNeedsDisplay];
}

- (void)setResultText:(NSString *)resultText
{
    _resultText = resultText;
    [self.resultView addSubview:self.result];
    [self setNeedsDisplay];
}

- (void)setSubresultText:(NSString *)subresultText
{
    _subresultText = subresultText;
    [self.resultView addSubview:self.subresult];
    [self setNeedsDisplay];
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{
    [self addSubview:self.resultView];
}

#pragma mark - Initialization


- (void)setup
{
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
