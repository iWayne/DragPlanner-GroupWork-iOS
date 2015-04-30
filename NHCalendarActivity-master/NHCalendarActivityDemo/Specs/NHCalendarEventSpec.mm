#import "NHCalendarEvent.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(NHCalendarEventSpec)

describe(@"NHCalendarEvent", ^{
    __block NHCalendarEvent *event;
    __block NSDate *fakeNow;
    __block NSDate *fakeNotNow;
    __block NSTimeZone *fakeTimeZone;
    __block NSURL *fakeURL;
    __block NSArray *fakeAlarms;
    
    beforeEach(^{
        event = [[NHCalendarEvent alloc] init];
        fakeNow = nice_fake_for([NSDate class]);
        fakeNotNow = nice_fake_for([NSDate class]);
        fakeTimeZone = nice_fake_for([NSTimeZone class]);
        fakeURL = nice_fake_for([NSURL class]);
        fakeAlarms = nice_fake_for([NSArray class]);
        
        event.title = @"Title";
        event.location = @"Location";
        event.notes = @"Notes";
        
        event.startDate = fakeNow;
        event.endDate = fakeNotNow;
        event.timeZone = fakeTimeZone;
        event.URL = fakeURL;
        event.alarms = fakeAlarms;
        
        event.allDay = NO;
    });
    
    it(@"has title", ^{
        event.title should equal(@"Title");
    });
    
    it(@"has location", ^{
        event.location should equal(@"Location");
    });
    
    it(@"has notes", ^{
        event.notes should equal(@"Notes");
    });
    
    it(@"has start date", ^{
        event.startDate should equal(fakeNow);
    });
    
    it(@"has end date", ^{
        event.endDate should equal(fakeNotNow);
    });
    
    it(@"has time zone", ^{
        event.timeZone should equal(fakeTimeZone);
    });
    
    it(@"has URL", ^{
        event.URL should equal(fakeURL);
    });
    
    it(@"has an array of alarms", ^{
        event.alarms should equal(fakeAlarms);
    });
    
    it(@"has a flag for all day event", ^{
        event.allDay should equal(NO);
    });
});

SPEC_END
