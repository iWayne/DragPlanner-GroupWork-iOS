#import "NHCalendarEventFixture.h"

@implementation NHCalendarEventFixture

+ (NHCalendarEvent *)event
{
    NHCalendarEvent *calendarEvent = [[NHCalendarEvent alloc] init];
    
    calendarEvent.title = @"Long-expected Party";
    calendarEvent.location = @"The Shire";
    calendarEvent.notes = @"Bilbo's eleventy-first birthday.";
    calendarEvent.URL = [NSURL URLWithString:@"http://shire.middle.earth"];
    
    calendarEvent.startDate = [NSDate dateWithTimeIntervalSinceNow:3600];
    calendarEvent.endDate = [NSDate dateWithTimeInterval:3600
                                               sinceDate:calendarEvent.startDate];
    calendarEvent.allDay = NO;
    calendarEvent.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];

    NSArray *alarms = @[[EKAlarm alarmWithRelativeOffset:- 60.0f * 60.0f * 24],
                        [EKAlarm alarmWithRelativeOffset:- 60.0f * 15.0f]];
    calendarEvent.alarms = alarms;
    
    return calendarEvent;
}

@end
