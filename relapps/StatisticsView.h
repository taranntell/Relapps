//
//  StatisticsView.h
//  relapps
//
//  Created by Diego Loop on 10/07/16.
//  Copyright © 2016 Herzly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatisticsView : UIView

@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSString *titleText;
@property (strong, nonatomic) NSString *subtitleText;
@property (strong, nonatomic) NSString *resultText;
@property (strong, nonatomic) NSString *subresultText;
@property (nonatomic) BOOL showSeparationLine;

@end
