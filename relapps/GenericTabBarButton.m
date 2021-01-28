//
//  GenericTabBarButton.m
//  relapps
//
//  Created by Diego Loop on 18/06/16.
//  Copyright © 2016 Herzly. All rights reserved.
//

#import "GenericTabBarButton.h"

@implementation GenericTabBarButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setButtonType:(NSInteger ) ButtonStyleType{
    NSString *imgName = @"back";
    switch (ButtonStyleType) {
        case ButtonStyleBack:
            // Default image name
            break;
        case ButtonStyleClose:
            imgName = @"close.png";
            break;
        case ButtonStyleCalm:
            imgName = @"calm.png";
            break;
        case ButtonStyleCalmoff:
            imgName = @"calmoff.png";
            break;
        case ButtonStyleLevitation:
            imgName = @"levitation.png";
            break;
        case ButtonStyleWarning:
            imgName = @"warning.png";
            break;
        case ButtonStyleInfo:
            imgName = @"info.png";
            break;
        case ButtonStyleBurger:
            imgName = @"burger.png";
            break;
        default:
            break;
    }
    
    [self setImage:[UIImage imageNamed:imgName]
          forState:UIControlStateNormal];
}


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

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

@end
