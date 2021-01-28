//
//  DataClass.m
//  relapps
//
//  Created by Diego Loop on 23/04/16.
//  Copyright © 2016 Herzly. All rights reserved.
//

#import "Data.h"

@implementation Data : NSObject

#pragma mark - Properties

- (NSMutableDictionary *)quotes{
    if (!_quotes) {
        _quotes = [[NSMutableDictionary alloc] init];
        [_quotes addEntriesFromDictionary: @{
         @"Maureen Killoran" : @"Relax your hand. Relax your heart. Relax into a slower space, where stakes are by definition lower.",
         @"Henry Ward Beecher":@"Flowers . . . have a mysterious and subtle influence upon the feelings, not unlike some strains of music. They relax the tenseness of the mind. They dissolve its rigor.",
         @"Norman Vincent Peale":@"Learn to relax. Your body is precious, as it houses your mind and spirit. Inner peace begins with a relaxed body.",
         @"Captain J. A. Hadfield ":@"This art of resting the mind and the power of dismissing from it all care and worry is probably one of the secrets of energy in our great men.",
         @"Dalgit, from Avoid The Pressure":@"Avoid the pressure, just calm down, wear a smile instead of a frown, let life go on in a relaxed way; for tomorrow is another day.",
         @"Etty Hillesum":@"Sometimes the most important thing in a whole day is the rest we take between two deep breaths.",
         @"Jacquie McTaggart ":@"Kids are happier, more relaxed, more creative and less stressed when scheduled activities are limited.",
         @"Mohandas K. Gandhi":@"There is more to life than increasing its speed.",
         @"Chinese Proverb ":@"Tension is who you think you should be. Relaxation is who you are.",
         @"Yasmeen Abdur-Rahman":@"Get your rest. Slow down.",
         @"Seneca":@"The mind should be allowed some relaxation, that it may return to its work all the better for the rest.",
         @"Francois de La Rochefoucauld ":@"When we are unable to find tranquility within ourselves, it is useless to seek it elsewhere.",
         @"Donald Curtis":@"Relaxation means releasing all concern and tension and letting the natural order of life flow through one's being.",
         @"William S. Burroughs ":@"Your mind will answer most questions if you learn to relax and wait for the answer.",
         @"Natalie Goldberg":@"Stress is an amazing. It believes that everything is an emergency. Nothing is that important.",
         @"Aesop":@"A crust eaten in peace is better than a banquet partaken in anxiety.",
         @"Ashleigh Brilliant ":@"Try to relax and enjoy the crisis.",
         @"Dianne Hales ":@"Put duties aside at least an hour before bed and perform soothing, quiet activities that will help you relax.",
         @"Paulo Coelho, The Pilgrimage":@"It's a good idea always to do something relaxing prior to making an important decision in your life.",
         @"Laini Taylor, Dreams of Gods & Monsters":@"If only it were that easy to let go of hate. Just relax your face.",
         @"Lailah Gifty Akita":@"Take time to relax, renew and be revived.",
         @"Mokokoma Mokhonoana":@"A deep breath is a technique with which we minimize the number of instances where we say what we do not mean … or what we really think.",
         @"Bill Phillips":@"Stress should be a powerful driving force, not an obstacle.",
         @"Richard Carlson":@"Stress is nothing more than a socially acceptable form of mental illness.",
         @"Jim Goodwin":@"The time to relax is when you don't have time for it.",
         @"Ovid":@"Take rest; a field that has rested gives a bountiful crop.",
         @"Lily Tomlin":@"For fast-acting relief, try slowing down.",
         @"Harry Emerson Fosdick":@"No one can get inner peace by pouncing on it.",
         @"Terri Guillemets":@"Give your stress wings and let it fly away.",
         @"William James":@"The greatest weapon against stress is our ability to choose one thought over another. ",
         @"Terri Guillemets":@"Stress is the trash of modern life — we all generate it but if you don't dispose of it properly, it will pile up and overtake your life.",
         @"Judith Hanson Lasater":@"Taking time out each day to relax and renew is essential to living well. ",
         @"John De Paola":@"Slow down and everything you are chasing will come around and catch you. ",
         @"Jeb Dickerson":@"Releasing the pressure, it's good for the teapot and the water. Try it sometime. ",
         @"Agavé Powers":@"Stress is poison.",
         @"Robert Brault":@"There are times in life when there's absolutely nothing you can do, also known as a chance to relax.",
         @"Terri Guillemets":@"Stress flails itself down trying to block every path of happiness. ",
         @"Terri Guillemets":@"Don't let your mind bully your body into believing it must carry the burden of its worries. ",
         @"Chinese Proverb":@"Tension is who you think you should be.  Relaxation is who you are.  ",
         @"Mark Black":@"Sometimes the most productive thing you can do is relax.",
         @"Catherine Pulsifer":@"To help have less stress, take time to relax.  ",
         @"Louise Hay":@"The ability to relax and be mindfully present in the moment comes naturally when we are grateful. ",
         @"Richard Bach":@"I relax my body completely, relax my mind completely, and then imagine myself at a level where anything can happen.",
         @"Alan Cohen":@"There is virtue in work and there is virtue in rest. Use both and overlook neither.",
         @"Mark Twain":@"Whenever you find yourself on the side of the majority, it is time to pause and reflect.",
         @"William Wadsworth":@"Rest and be thankful.",
         @"Cynthia Wright":@"Quietness with thoughtful reflection and relaxation can be empowering.",
         @"Horatius":@"It is sweet to relax at the proper time."
         }];
    }
    return _quotes;
}

#pragma mark - Utilities

- (NSDictionary *)getRandomQuote{
    
    NSArray *items = [self.quotes allKeys];
    int ran = arc4random()%[items count];
    
    
    NSDictionary *quote = @{[items objectAtIndex:ran] : [self.quotes objectForKey:[items objectAtIndex:ran]] };
    return quote;
}

+ (float)scaleFactor:(float)height
{
    return (height * SCALE_FACTOR) / BALLSIZE;
}

+ (float)convertDaysInSec:(int)days
{
    return days * 24.0f * 60.0f * 60.0f; // d * h * m * s
}

+ (float)convertMinInSec:(int)min
{
    return min * 60.0;
}

#pragma mark - Relaxing Time

+ (NSString *)formatDate:(NSDate *)date format:(NSString *)format
{
    NSString *datetext = @"";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    
    //Optionally for time zone conversions
    //[formatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]]
    
    datetext = [formatter stringFromDate:date];
    return datetext;
}


// TODO: Update 01.00.01 03.Oct.2016 Should check if day is over.
// Previous functionality, checking 24 hours for a completed day
// New functionality, check if a day is over!
+ (BOOL) isRelaxingTimeOverOnDays:(float)days oldDate:(NSDate *)oldDate newDate:(NSDate *)newDate
{
    BOOL isPeriodOver = NO;
    /*
    // Previous functionality, checking 24 hours for a completed day
    NSTimeInterval diff = [newDate timeIntervalSinceDate:oldDate];
    float daysInSec = [[Data class] convertDaysInSec:days];
    if (diff > daysInSec)
        isPeriodOver = true;
     */
    
//    NSDate *today = [NSDate new];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    BOOL isToday = [calendar isDateInToday:oldDate];
    BOOL isYesterday = [calendar isDateInYesterday:oldDate];
    if (!isToday && !isYesterday){
        isPeriodOver = YES;
    }
    
    return isPeriodOver;
}

+ (float)findRelaxingPercentUsageGoal:(int)goal currentTimeInMin:(float)currentTime
{
    // Format 0.33%
    float percent = 0.0f;
    float goalInSec = [[Data class] convertMinInSec:goal];
    float currentTimeInSec = currentTime;
    percent = currentTimeInSec / goalInSec;
    percent = (percent > 1.0) ? 1 : percent;
    
    return percent;
}

+ (NSArray *) relaxingTimePerDays:(int)days{
    
    NSArray *time = [NSArray arrayWithObject:[NSString stringWithFormat:@"%d", days]];
    
    return time;
}

+ (NSString *)sumOfDates:(float)firstDate :(float)secondDate
{
    float sum = firstDate + secondDate;
    return [[Data class] stringFromTimeInterval:sum];
}

+ (NSString *)stringFromTimeInterval:(NSTimeInterval)interval
{
    NSInteger ti = (NSInteger)interval;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    return [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)hours, (long)minutes, (long)seconds];
}

+ (NSArray *)hourMinSecFromTimeInterval:(NSTimeInterval)interval
{
    NSString *time = [[Data class] stringFromTimeInterval:interval];
    return [time componentsSeparatedByString:@":"];
}

#pragma mark - Colors

- (int)ballColor
{
    if (!_ballColor) {
        _ballColor = 0xB6E1C2;
//        _ballColor = 0xBAE1CE; // Original
//        _ballColor = 0xCBE59F; //balls1 main color?
//        _ballColor = 0x7CBB52; // Butterfly1
        
//        _ballColor =  0x8FC9AD; //orignal darker0 // 0xBAE1CE; //original10 // 0xCBE59F; //balls1 //0x66D548; //Shopbag0 // 0x75D16C; // Paint1 // 0x85CA78; //Flower0 //0x7CBB52; // Butterfly1 // 0xA9F022; //Palette0 //0x8EE361 keynote;1
    }
    return _ballColor;
}

- (int)titleColor
{
    if (!_titleColor){
        _titleColor = 0xFFFFFF;
    }
    return _titleColor;
}

- (int)titleFontSize
{
    if (!_titleFontSize) {
        _titleFontSize = 12;
    }
    return _titleFontSize;
}

static Data *instance = nil;

+ (Data *)getInstance
{
    @synchronized (self) {
        if (instance == nil) {
            instance = [Data new];
        }
    }
    return instance;
}


@end
