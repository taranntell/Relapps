//
//  AboutViewController.m
//  relapps
//
//  Created by Diego Loop on 29/06/16.
//  Copyright © 2016 Herzly. All rights reserved.
//

#import "AboutViewController.h"
#import "Data.h"

@interface AboutViewController ()

@end

@implementation AboutViewController


- (void)setText:(NSString *)text{
    _text = text;
}

- (void)drawTextArea
{
    UIScrollView *scroll = [[UIScrollView alloc] init];
    [scroll setFrame:self.view.bounds];
    
    [self.view addSubview:scroll];
    
    UITextView *textview = [[UITextView alloc] init];
    [textview setFrame:CGRectMake(scroll.bounds.origin.x + MIN_MARGIN,
                                 scroll.bounds.origin.y + MIN_MARGIN,
                                 scroll.bounds.size.width - MIN_MARGIN_2X,
                                 scroll.bounds.size.height - MIN_MARGIN)];
    textview.backgroundColor = UIColorFromRGB(BACKGROUND_UICOLOR_DEFAULT);
    
    textview.text = self.text;
    textview.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    textview.textColor = UIColorFromRGB(TEXT_COLOR);
    
    textview.selectable = NO;
    
    [scroll addSubview:textview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self drawTextArea];
}

@end
