//
//  BackgroundColorView.m
//  relapps
//
//  Created by Diego Loop on 30/06/16.
//  Copyright © 2016 Herzly. All rights reserved.
//

#import "BackgroundColorView.h"
#import "OverviewViewController.h"
#import "Data.h"

@implementation BackgroundColorView

- (float)rgb:(float)num{
    return num/255;
}


- (void)drawRect:(CGRect)rect {

    [self addGradientBackground:rect];
}

- (void)addGradientBackground:(CGRect)rect
{    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGGradientRef   gradient  = nil;
    CGColorSpaceRef baseSpace = nil;
    
    size_t num_locations = 3;
    CGFloat locations[3] = { 0.0, 0.5, 1.0 };
    
    baseSpace = CGColorSpaceCreateDeviceRGB(); // Just for iOS
    if ( !self.backgroundStyle || self.backgroundStyle == BackgroundStyleDefault ) {
        CGFloat components[12] = {
            1.0, 1.0, 1.0, 1.0,
            1.0, 1.0, 1.0, 1.0,
            1.0, 1.0, 1.0, 1.0
        };
        gradient = CGGradientCreateWithColorComponents(baseSpace, components, locations, num_locations);
        
    }else if (self.backgroundStyle == BackgroundStyleInvert){
        CGFloat components[12] = {
            [self rgb:239], [self rgb:239], [self rgb:239], 1.0,
            [self rgb:239], [self rgb:239], [self rgb:239], 1.0,
            [self rgb:239], [self rgb:239], [self rgb:239], 1.0
        };
        gradient = CGGradientCreateWithColorComponents(baseSpace, components, locations, num_locations);
        
    }else if (self.backgroundStyle == BackgroundStyleGreenBall){
        CGFloat components[12] = {
//            [self rgb:186], [self rgb:225], [self rgb:206], 1.0, // BAE1CE original 
            [self rgb:182], [self rgb:225], [self rgb:194], 1.0, // B6E1C2 original lighter
            [self rgb:179], [self rgb:225], [self rgb:218], 1.0,
            [self rgb:201], [self rgb:229], [self rgb:217], 1.0
        };
        gradient = CGGradientCreateWithColorComponents(baseSpace, components, locations, num_locations);
        
    }else if (self.backgroundStyle == BackgroundStyleGreenLightBall){
        CGFloat components[12] = {
            [self rgb:214], [self rgb:227], [self rgb:221], 1.0,
            [self rgb:212], [self rgb:227], [self rgb:225], 1.0,
            [self rgb:214], [self rgb:227], [self rgb:223], 1.0
            
            // Dark gradient
//            [self rgb:186], [self rgb:225], [self rgb:206], 1.0,
//            [self rgb:186], [self rgb:225], [self rgb:206], 1.0,
//            [self rgb:179], [self rgb:225], [self rgb:218], 1.0
        };
        gradient = CGGradientCreateWithColorComponents(baseSpace, components, locations, num_locations);
        
    }else if (self.backgroundStyle == BackgroundStyleNight){
        CGFloat components[12] = {
            0.168, 0.192, 0.235, 1.0, // 43, 49, 60 #2B313C
            0.2, 0.6, 0.8, 1.0,       // 51, 153, 208 #3399D0
            0.2, 0.6, 0.8, 1.0
        };
        gradient = CGGradientCreateWithColorComponents(baseSpace, components, locations, num_locations);
        
    }
    else if (self.backgroundStyle == BackgroundStyleWatterSee){
        CGFloat components[12] = {
            [self rgb:134], [self rgb:207], [self rgb:195], 1.0, // #86CFC3
            [self rgb:88], [self rgb:191], [self rgb:208], 1.0, // #56BFD0
            [self rgb:35], [self rgb:173], [self rgb:224], 1.0 // #23ADE0
            // https://dribbble.com/shots/2803839-Nuvola-Logo
            
        };
        gradient = CGGradientCreateWithColorComponents(baseSpace, components, locations, num_locations);
        
    }else if (self.backgroundStyle == BackgroundStyleWatterSeeInvert){
        CGFloat components[12] = {
            [self rgb:35], [self rgb:173], [self rgb:224], 1.0, // #23ADE0
            [self rgb:88], [self rgb:191], [self rgb:208], 1.0, // #56BFD0
            [self rgb:134], [self rgb:207], [self rgb:195], 1.0 // #86CFC3
            // https://dribbble.com/shots/2803839-Nuvola-Logo
            
        };
        gradient = CGGradientCreateWithColorComponents(baseSpace, components, locations, num_locations);
        
    }else if (self.backgroundStyle == BackgroundStyleMexicoLake){
        CGFloat components[12] = {
            //            [self rgb:69], [self rgb:129], [self rgb:163], 1.0, // #4581A3
            [self rgb:70], [self rgb:133], [self rgb:159], 1.0, // #46859F
            [self rgb:74], [self rgb:145], [self rgb:174], 1.0, // #4A91AE
            //            [self rgb:122], [self rgb:173], [self rgb:193], 1.0, // #7AADC1
            [self rgb:172], [self rgb:196], [self rgb:203], 1.0 // #ACC4CB
            // https://dribbble.com/shots/1978495-Cuitzeo-Lake
        };
        gradient = CGGradientCreateWithColorComponents(baseSpace, components, locations, num_locations);
        
    }else if (self.backgroundStyle == BackgroundStyleBlueDemon){
        CGFloat components[12] = {
            [self rgb:42], [self rgb:109], [self rgb:215], 1.0, // #2A6DD7
            [self rgb:47], [self rgb:151], [self rgb:225], 1.0, // #2F97E1
            [self rgb:49], [self rgb:166], [self rgb:225], 1.0 // #31A6E1
            
        };
        gradient = CGGradientCreateWithColorComponents(baseSpace, components, locations, num_locations);
        
    }else if (self.backgroundStyle == BackgroundStyleGreenDemon){
        CGFloat components[12] = {
            [self rgb:17], [self rgb:120], [self rgb:110], 1.0, // #11786E
            [self rgb:80], [self rgb:173], [self rgb:149], 1.0, // #50AD95
            [self rgb:128], [self rgb:205], [self rgb:171], 1.0 // #80CDAB
            
        };
        gradient = CGGradientCreateWithColorComponents(baseSpace, components, locations, num_locations);
        
    }else if (self.backgroundStyle == BackgroundStylePastelDream){
        CGFloat components[12] = {
//            [self rgb:251], [self rgb:243], [self rgb:222], 1.0, // #FBF3DE
            [self rgb:117], [self rgb:177], [self rgb:147], 1.0, // #75B193
//            [self rgb:162], [self rgb:232], [self rgb:193], 1.0, // #A2E8C1
            [self rgb:215], [self rgb:255], [self rgb:235], 1.0, // #D7FFEB
            [self rgb:96], [self rgb:162], [self rgb:177], 1.0 // #60A2B1
            
        };
        gradient = CGGradientCreateWithColorComponents(baseSpace, components, locations, num_locations);
        
    }
    
    
    
    CGContextSaveGState(context);
    CGContextAddRect(context, rect);
    CGContextClip(context);
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGGradientRelease(gradient), gradient = NULL;
    CGContextRestoreGState(context);
    CGContextSetLineWidth(context, 0.05);
    
    
}

- (void)setup
{
    [self setAlpha:BACKGROUNDSTYLEOPACITY];
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
