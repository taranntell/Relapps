//
//  GenericButton.m
//  relapps
//
//  Created by Diego Loop on 16/06/16.
//  Copyright © 2016 Herzly. All rights reserved.
//

#import "GenericButton.h"
#import "Data.h"

@implementation GenericButton

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:CORNERN_RADIUS];
    [roundedRect addClip];
    /*
     * RQ 9: No selecting effect on some buttons
     */
    if (!self.backcolor) { [UIColorFromRGB([Data getInstance].ballColor) setFill]; }
    else { [self.backcolor setFill];}
    
    UIRectFill(self.bounds);
}

#pragma mark - Initialization

- (void)setup
{
    self.contentMode = UIViewContentModeRedraw;
    self.frame = self.superview.frame;
    self.backgroundColor = nil;
    
    [self setTitleColor:UIColorFromRGB(GREEN_ACCENT_COLOR) forState:UIControlStateHighlighted];
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
