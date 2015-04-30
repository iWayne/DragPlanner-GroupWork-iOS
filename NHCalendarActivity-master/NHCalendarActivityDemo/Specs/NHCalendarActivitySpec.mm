#import <Swizzlean/Swizzlean.h>
#import "NHCalendarActivity.h"
#import "NHCalendarEventFixture.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

@interface NHCalendarActivity (Specs)
@property (strong) NSMutableArray *events;
@end

SPEC_BEGIN(NHCalendarActivitySpec)

describe(@"NHCalendarActivity", ^{
    __block NHCalendarActivity *activity;

    beforeEach(^{
        activity = [[NHCalendarActivity alloc] init];
    });
    
    it(@"should not blow up", ^{
        activity should_not be_nil;
    });
    
    it(@"has an event arrary", ^{
        activity.events should_not be_nil;
    });
    
    describe(@"#activityType", ^{
        it(@"returns proper activity type", ^{
            NSString *type = [activity activityType];
            type should equal(@"NHCalendarActivity");
        });
    });
    
    describe(@"#activityTitle", ^{
        it(@"returns proper activity title", ^{
            NSString *title = [activity activityTitle];
            title should equal(NSLocalizedString(@"Save to Calendar", nil));
        });
    });
    
    describe(@"#activityImage", ^{
        __block UIImage *image;

        context(@"user defined image", ^{
            beforeEach(^{
                activity.activityImage = nil;
            });
            
            it(@"returns proper activity image", ^{
                activity.activityImage should be_nil;
            });
        });
        
        context(@"default image", ^{
            beforeEach(^{
                image = [UIImage imageNamed:@"NHCalendarActivity.bundle/NHCalendarActivityIcon"];
            });

            it(@"returns proper activity image", ^{
                UIImage *expectedImage = [UIImage imageNamed:@"NHCalendarActivity.bundle/NHCalendarActivityIcon"];
                UIImage *image = activity.activityImage;
                image should equal(expectedImage);
            });
        });
    });
    
    describe(@"#canPerformWithActivityItems", ^{
        __block NSArray *items;
        __block NHCalendarEvent *fakeEvent;
        __block Swizzlean *eventStoreSwizz;
        __block BOOL retValue;
        
        beforeEach(^{
            fakeEvent = nice_fake_for([NHCalendarEvent class]);
            items = @[fakeEvent];
        });
        
        context(@"EKAuthorizationStatusDenied", ^{
            beforeEach(^{
                eventStoreSwizz = [[Swizzlean alloc] initWithClassToSwizzle:[EKEventStore class]];
                [eventStoreSwizz swizzleClassMethod:@selector(authorizationStatusForEntityType:) withReplacementImplementation:^(id _self, EKEntityType type) {
                    return EKAuthorizationStatusDenied;
                }];
                
                retValue = [activity canPerformWithActivityItems:items];
            });
            
            afterEach(^{
                [eventStoreSwizz resetSwizzledClassMethod];
            });
            
            it(@"should NOT display the 'Save to Calendar' icon", ^{
                retValue should_not be_truthy;
            });
        });
        
        context(@"EKAuthorizationStatusNotDetermined", ^{
            beforeEach(^{
                eventStoreSwizz = [[Swizzlean alloc] initWithClassToSwizzle:[EKEventStore class]];
                [eventStoreSwizz swizzleClassMethod:@selector(authorizationStatusForEntityType:) withReplacementImplementation:^(id _self, EKEntityType type) {
                    return EKAuthorizationStatusNotDetermined;
                }];
                
                retValue = [activity canPerformWithActivityItems:items];
            });
            
            afterEach(^{
                [eventStoreSwizz resetSwizzledClassMethod];
            });
            
            it(@"should display the 'Save to Calendar' icon", ^{
                retValue should be_truthy;
            });
        });
        
        context(@"EKAuthorizationStatusAuthorized", ^{
            beforeEach(^{
                eventStoreSwizz = [[Swizzlean alloc] initWithClassToSwizzle:[EKEventStore class]];
                [eventStoreSwizz swizzleClassMethod:@selector(authorizationStatusForEntityType:) withReplacementImplementation:^(id _self, EKEntityType type) {
                    return EKAuthorizationStatusAuthorized;
                }];
                
                retValue = [activity canPerformWithActivityItems:items];
            });
            
            afterEach(^{
                [eventStoreSwizz resetSwizzledClassMethod];
            });
            
            it(@"should display the 'Save to Calendar' icon", ^{
                retValue should be_truthy;
            });
        });
    });

    describe(@"#prepareWithActivityItems", ^{
        __block NHCalendarEvent *fakeEvent;
        __block NSObject *fakeObject;
        __block NSArray *items;
        
        beforeEach(^{
            fakeEvent = nice_fake_for([NHCalendarEvent class]);
            fakeObject = nice_fake_for([NSObject class]);
            
            items = @[fakeEvent, fakeObject];
            
            [activity prepareWithActivityItems:items];
        });
        
        it(@"has added a single item to the array of events", ^{
            activity.events.count should equal(1);
        });
        
        it(@"has a NHCalendarEvent in the array of events", ^{
            activity.events[0] should be_instance_of([NHCalendarEvent class]);
        });
    });
    
    describe(@"#performActivity", ^{
        __block id<NHCalendarActivityDelegate> fakeDelegate;
        __block Swizzlean *requestAccessSwizz;
        __block EKEntityType typePassed;
        __block EKEventStoreRequestAccessCompletionHandler completionPassed;
        
        beforeEach(^{
            fakeDelegate = nice_fake_for(@protocol(NHCalendarActivityDelegate));
            activity.delegate = fakeDelegate;
            
            requestAccessSwizz = [[Swizzlean alloc] initWithClassToSwizzle:[EKEventStore class]];
            [requestAccessSwizz swizzleInstanceMethod:@selector(requestAccessToEntityType:completion:) withReplacementImplementation:^(id _self, EKEntityType type, EKEventStoreRequestAccessCompletionHandler completion) {
                typePassed = type;
                completionPassed = [completion copy];
            }];
            
            [activity performActivity];
        });
        
        afterEach(^{
            [requestAccessSwizz resetSwizzledInstanceMethod];
        });
        
        context(@"request access NOT granted", ^{
            __block NSError *fakeError;
            
            beforeEach(^{
                fakeError = nice_fake_for([NSError class]);
                completionPassed(NO, fakeError);
            });
            
            it(@"has called delegate selector calendarActivityDidFailWithError:", ^{
                activity.delegate should have_received(@selector(calendarActivityDidFailWithError:)).with(fakeError);
            });
        });
        
        context(@"request access granted", ^{
            __block NHCalendarEvent *event;
            __block NSArray *items;
            __block Swizzlean *saveEventSwizz;
            
            __block EKEvent *passedEvent;
            __block EKSpan passedSpan;
            __block NSError *fakeError;
            
            __block Swizzlean *setCalendarSwizz;
            __block EKCalendar *passedCalendar;
            __block EKEventStore *eventStore;
            
            __block Swizzlean *defaultCalendarSwizz;
            __block EKCalendar *fakeCalendar;
            
            beforeEach(^{
                event = [NHCalendarEventFixture event];
                items = @[event];
                [activity prepareWithActivityItems:items];
                
                fakeError = nil;
                saveEventSwizz = [[Swizzlean alloc] initWithClassToSwizzle:[EKEventStore class]];
                [saveEventSwizz swizzleInstanceMethod:@selector(saveEvent:span:error:)
                        withReplacementImplementation:^(id _self, EKEvent *event, EKSpan span, NSError **error) {
                            passedEvent = event;
                            passedSpan = span;
                            *error = fakeError;
                }];
                
                eventStore = [[EKEventStore alloc] init];
                setCalendarSwizz = [[Swizzlean alloc] initWithClassToSwizzle:[EKEvent class]];
                [setCalendarSwizz swizzleInstanceMethod:@selector(setCalendar:) withReplacementImplementation:^(id _self, EKCalendar *calendar) {
                    passedCalendar = calendar;
                }];
                
                fakeCalendar = nice_fake_for([EKCalendar class]);
                defaultCalendarSwizz = [[Swizzlean alloc] initWithClassToSwizzle:[EKEventStore class]];
                [defaultCalendarSwizz swizzleInstanceMethod:@selector(defaultCalendarForNewEvents) withReplacementImplementation:^(id _self) {
                    return fakeCalendar;
                }];
            });

            afterEach(^{
                [saveEventSwizz resetSwizzledInstanceMethod];
                [setCalendarSwizz resetSwizzledInstanceMethod];
                [defaultCalendarSwizz resetSwizzledInstanceMethod];
            });
            
            context(@"doesn't have error while saving", ^{
                beforeEach(^{
                    fakeError = nil;
                    completionPassed(YES, nil);
                });

                it(@"has proper EKSpan", ^{
                    passedSpan should equal(EKSpanThisEvent);
                });
                
                it(@"has called delegate selector calendarActivityDidFinish:", ^{
                    activity.delegate should have_received(@selector(calendarActivityDidFinish:)).with(event);
                });
                
                it(@"uses the default calendar for events", ^{
                    passedCalendar should equal(fakeCalendar);
                });
                
                describe(@"EKEvent", ^{
                    __block NSDateFormatter *formatter;
                    
                    beforeEach(^{
                        [formatter setDateFormat:@"HH:mm:ss"];
                        formatter = [[NSDateFormatter alloc] init];
                    });
                    
                    it(@"has proper title", ^{
                        passedEvent.title should equal(event.title);
                    });
                    
                    it(@"has proper location", ^{
                        passedEvent.location should equal(event.location);
                    });

                    it(@"has proper notes", ^{
                        passedEvent.notes should equal(event.notes);
                    });
                    
                    it(@"has proper start date", ^{
                        NSString *expectedDateString = [formatter stringFromDate:event.startDate];
                        NSString *realDateString = [formatter stringFromDate:passedEvent.startDate];
                        
                        realDateString should equal(expectedDateString);
                    });
                    
                    it(@"has proper end date", ^{
                        NSString *expectedDateString = [formatter stringFromDate:event.endDate];
                        NSString *realDateString = [formatter stringFromDate:passedEvent.endDate];
                        
                        realDateString should equal(expectedDateString);
                    });
                    
                    it(@"has proper all day flag", ^{
                        passedEvent.allDay should equal(event.allDay);
                    });
                    
                    it(@"has proper time zone", ^{
                        passedEvent.timeZone should equal(event.timeZone);
                    });
                    
                    it(@"has proper URL", ^{
                        passedEvent.URL should equal(event.URL);
                    });
                    
                    describe(@"alarms", ^{
                        it(@"has two alarms", ^{
                            passedEvent.alarms.count should equal(2);
                        });
                    });
                });
            });
            
            context(@"does have error while saving", ^{
                beforeEach(^{
                    fakeError = nice_fake_for([NSError class]);
                    completionPassed(YES, nil);
                });
                
                it(@"has called delegate selector calendarActivityDidFinish:", ^{
                    activity.delegate should have_received(@selector(calendarActivityDidFail:withError:));
                });
            });
        });
    });
});

SPEC_END
