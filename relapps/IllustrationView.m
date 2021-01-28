//
//  IllustrationView.m
//  relapps
//
//  Created by Diego Loop on 10/07/16.
//  Copyright © 2016 Herzly. All rights reserved.
//

#import "IllustrationView.h"
#import "Data.h"

@interface IllustrationView ()

@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation IllustrationView

#pragma mark - Properties

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        [_imageView setFrame:self.bounds];
        [_imageView setCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
        [_imageView setImage:self.image];
    }
    return _imageView;
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    [self addSubview:self.imageView];
    [self setNeedsDisplay];
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *circle = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.frame.size.width/2];
    [circle addClip];
    [UIColorFromRGB(ILLUSTRATION_CIRCLE_COLOR) setFill];
    UIRectFill(self.bounds);
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
