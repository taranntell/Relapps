//
//  RemeinderViewController.m
//  relapps
//
//  Created by Diego Loop on 02/08/16.
//  Copyright © 2016 Herzly. All rights reserved.
//

#import "RemeinderViewController.h"
#import "SwitchDayView.h"
#import "Data.h"

@interface RemeinderViewController () <SwitchDayViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *baseDaysView;
@property (strong, nonatomic) NSMutableArray *selectedDays;
@property (weak, nonatomic) IBOutlet UIDatePicker *selectedTime;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;

@end

@implementation RemeinderViewController

- (NSMutableArray *)selectedDays
{
    if (!_selectedDays) {
        _selectedDays = [[NSMutableArray alloc] init];
    }
    return _selectedDays;
}

#pragma mark - Methods

- (NSDate *)findRealTimePickerDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    return [dateFormatter dateFromString:[dateFormatter stringFromDate:self.selectedTime.date]];
}

-(NSDate *) getDateOfSpecificDay:(NSInteger )day /// here day will be 1 or 2.. or 7
{
    NSInteger desiredWeekday = day;
    NSRange weekDateRange = [[NSCalendar currentCalendar] maximumRangeOfUnit:NSCalendarUnitWeekday];
    NSInteger daysInWeek = weekDateRange.length - weekDateRange.location + 1;
    
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:[NSDate date]];
    NSInteger currentWeekday = dateComponents.weekday;
    NSInteger differenceDays = (desiredWeekday - currentWeekday + daysInWeek) % daysInWeek;
    NSDateComponents *daysComponents = [[NSDateComponents alloc] init];
    daysComponents.day = differenceDays;
    NSDate *resultDate = [[NSCalendar currentCalendar] dateByAddingComponents:daysComponents toDate:[NSDate date] options:0];
    return resultDate;
}

- (NSDate *)findFireDateForDay:(NSInteger)day
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:[self findRealTimePickerDate]];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    
    NSDateComponents *componentsForFireDate = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond ) fromDate: [self getDateOfSpecificDay:day]];
    
    [componentsForFireDate setHour:hour];
    [componentsForFireDate setMinute:minute];
    [componentsForFireDate setSecond:0];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld:%ld", (long)[components hour], (long)[components minute]] forKey:REMINDERVIEWCONTROLLER_TIMESELECTED];
    
    return [calendar dateFromComponents:componentsForFireDate];
}

- (UILocalNotification *)addLocalNotificationForDay:(NSInteger)day
{
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    notification.fireDate = [self findFireDateForDay:day];
    notification.timeZone = [NSTimeZone localTimeZone];
    notification.alertBody = [NSString stringWithFormat: @"Inhale... Exhale... It's time to relax"];
    notification.alertAction = @"start";
    notification.repeatInterval= NSCalendarUnitWeekOfYear; //NSCalendarUnitDay;
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.applicationIconBadgeNumber = 0;
    
    return notification;
}

- (void)doneRemeinder:(UIBarButtonItem *)sender
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    for (NSString *dayNumber in self.selectedDays) {
        NSInteger day = [dayNumber integerValue] + 1; // +1 because in NSCalendarUnitWeekday So is 1 and Sa is 7
        [[UIApplication sharedApplication] scheduleLocalNotification:[self addLocalNotificationForDay:day]];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:self.selectedDays forKey:REMINDERVIEWCONTROLLER_DAYSSELECTED];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelReminder:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#define NUMTOPDAYS 4
#define NUMDOWNDAYS 3

- (CGFloat) dayBallSizeWithDaysOnTop:(float)numTopDays
{
    //                       * total                 * margin left and right   * half of margin between spaces
    return (self.view.frame.size.width - (MIN_MARGIN_2X*2) - ((MIN_MARGIN/2)*(numTopDays - 1))) / numTopDays;
}

- (void) addDayBalls
{
    NSMutableArray *selectedIndexDays = [[NSUserDefaults standardUserDefaults] objectForKey:REMINDERVIEWCONTROLLER_DAYSSELECTED];
    
    const CGFloat ballSize = [self dayBallSizeWithDaysOnTop:NUMTOPDAYS];
    const NSArray *days = @[@"Su", @"Mo", @"Tu", @"We", @"Th", @"Fr", @"Sa"];
    
    int tagID = 0;
    
    
    for (int i = 0; i < NUMTOPDAYS; i++) {
        SwitchDayView *sd = [[SwitchDayView alloc] init];
        [sd setFrame:CGRectMake(MIN_MARGIN_2X + (ballSize*i + (i * (MIN_MARGIN/2) ) ),
                                CGPointZero.y,
                                ballSize, ballSize)];
        
        tagID = i;
        sd.tag = tagID;
        sd.delegate = self;
        sd.title = [days objectAtIndex:i];
        
        for (NSString *selDay in selectedIndexDays) {
            if ([selDay isEqualToString:[NSString stringWithFormat:@"%d",(int)tagID]]) {
                sd.isDaySelected = sd.isSelected = YES;
            }
        }
        
        [self.baseDaysView addSubview:sd];
    }
    
    
    for (int i = 0; i < NUMDOWNDAYS; i++) {
        SwitchDayView *sd = [[SwitchDayView alloc] init];
        
        CGRect rect =  CGRectMake(MIN_MARGIN_2X + ((ballSize/3) + (MIN_MARGIN/2)) + (ballSize * i + (i * (MIN_MARGIN/2) ) ),
                                  CGPointZero.y + ballSize,
                                  ballSize, ballSize);
        [sd setFrame:rect];
        
        tagID = i + NUMTOPDAYS;
        sd.tag = tagID;
        sd.delegate = self;
        
        sd.title = [days objectAtIndex:tagID];
        
        for (NSString *selDay in selectedIndexDays) {
            if ([selDay isEqualToString:[NSString stringWithFormat:@"%d",(int)tagID]]){
                sd.isDaySelected = sd.isSelected = YES;
            }
        }
        
        [self.baseDaysView addSubview:sd];
    }
}

#pragma mark - Delegate

#define NO_ALARM_TEXT @" - No alarm set at the moment"
#define ALARM_WHAT_TIME @"What time?"

- (void)switchDayView:(SwitchDayView *)sender insertDayWithIndex:(NSInteger)idx
{
    UIUserNotificationType types = (UIUserNotificationType) (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert );
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    [self.selectedDays addObject:[NSString stringWithFormat:@"%d",(int)idx]];
}

- (void)switchDayView:(SwitchDayView *)sender removeDayWithIndex:(NSInteger)idx
{
    [self.selectedDays removeObject:[NSString stringWithFormat:@"%d",(int)idx]];
}

- (void)switchDayView:(SwitchDayView *)sender pressOnDay:(BOOL)isPressed{
    if (isPressed)
        self.timeLabel.text = ALARM_WHAT_TIME;
}

#pragma mark - Initialization

- (NSString *)findCurrentAlarm
{
    
    NSString *time = [[NSUserDefaults standardUserDefaults] objectForKey:REMINDERVIEWCONTROLLER_TIMESELECTED];
    
    NSString *alarm = NO_ALARM_TEXT;
    
    NSArray *days = [[NSUserDefaults standardUserDefaults] objectForKey:REMINDERVIEWCONTROLLER_DAYSSELECTED];
    
    if (time && days.count > 0){
        NSDateFormatter *dateFormatter3 = [[NSDateFormatter alloc] init] ;
        [dateFormatter3 setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter3 setDateFormat:@"HH:mm"];
        NSDate *date1 = [dateFormatter3 dateFromString:time];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"hh:mm a"];
        
        alarm = [NSString stringWithFormat:@" - Current alarm at: %@", [formatter stringFromDate:date1] ];
    }
    
    
    
    return alarm;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dayLabel.adjustsFontSizeToFitWidth = YES;
    self.timeLabel.adjustsFontSizeToFitWidth = YES;
    
    self.timeLabel.text = [NSString stringWithFormat:@"%@ %@ ",ALARM_WHAT_TIME, [self findCurrentAlarm]];
    
    
    [self addDayBalls];
}

@end

