//
//  NoiteHojeViewController.m
//  NHCalendarActivityDemo
//
//  Created by Otavio Cordeiro on 11/25/12.
//  Copyright (c) 2012 Noite Hoje. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining
//  a copy of this software and associated documentation files (the
//  "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish,
//  distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to
//  the following conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
//  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
//  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "DemoViewController.h"

@interface DemoViewController ()
@property (strong, nonatomic) UIActivityViewController *activity;
@end

@implementation DemoViewController

- (IBAction)openBtnTouched:(id)sender
{
    NSString *msg = NSLocalizedString(@"NHCalendarActivity", nil);
    NSURL* url = [NSURL URLWithString:@"http://github.com/otaviocc/NHCalendarActivity"];
    NHCalendarEvent *calendarEvent = [self createCalendarEvent];
    
    NHCalendarActivity *calendarActivity = [[NHCalendarActivity alloc] init];
    calendarActivity.delegate = self;
    
    NSArray *activities = @[calendarActivity];
    
    self.activity = [[UIActivityViewController alloc] initWithActivityItems:@[msg, url, calendarEvent]
                                                      applicationActivities:activities];
    
    self.activity.excludedActivityTypes = @[
                                            UIActivityTypePostToWeibo,
                                            UIActivityTypePrint,
                                            UIActivityTypeSaveToCameraRoll,
                                            UIActivityTypeAssignToContact
                                            ];
    
    [self presentViewController:self.activity
                       animated:YES
                     completion:NULL];    
}

-(NHCalendarEvent *)createCalendarEvent
{
    NHCalendarEvent *calendarEvent = [[NHCalendarEvent alloc] init];
    
    calendarEvent.title = @"Long-expected Party";
    calendarEvent.location = @"The Shire";
    calendarEvent.notes = @"Bilbo's eleventy-first birthday.";
    calendarEvent.startDate = [NSDate dateWithTimeIntervalSinceNow:3600];
    calendarEvent.endDate = [NSDate dateWithTimeInterval:3600 sinceDate:calendarEvent.startDate];
    calendarEvent.allDay = NO;
    calendarEvent.URL = [NSURL URLWithString:@"http://github.com/otaviocc/NHCalendarActivity"];
    
    // Add alarm
    NSArray *alarms = @[
        [EKAlarm alarmWithRelativeOffset:- 60.0f * 60.0f * 24],  // 1 day before
        [EKAlarm alarmWithRelativeOffset:- 60.0f * 15.0f]        // 15 minutes before
    ];
    calendarEvent.alarms = alarms;
    
    return calendarEvent;
}

#pragma mark - NHCalendarActivityDelegate

-(void)calendarActivityDidFinish:(NHCalendarEvent *)event
{
    NSLog(@"Event created from %@ to %@", event.startDate, event.endDate);
}

-(void)calendarActivityDidFail:(NHCalendarEvent *)event
                     withError:(NSError *)error
{
    NSLog(@"Ops!");
}

@end
