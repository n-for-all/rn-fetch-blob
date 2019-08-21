//
//  RNFetchBlobEventManager.m
//
//  Created by Naji Amer on 8/20/19.
//

#import "RNFetchBlobEventManager.h"
#import "RNFetchBlobConst.h"

@implementation RNFetchBlobEventManager

RCT_EXPORT_MODULE();

static RNFetchBlobEventManager *sharedInstance = nil;

NSMutableArray<NSString *> * _supportedEvents = nil;

+ (void)initialize {
    _supportedEvents = [NSMutableArray arrayWithArray:@[EVENT_EXPIRE, EVENT_SERVER_PUSH, EVENT_STATE_CHANGE, EVENT_PROGRESS, EVENT_PROGRESS_UPLOAD, MSG_EVENT]];
    [super initialize];
}

- (NSArray<NSString *> *)supportedEvents
{
    return _supportedEvents;
}

- (void)startObserving
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dispatchEventInternal:)
                                                 name:@"rnfb-event"
                                               object:nil];
}

// This will stop listening if we require it
- (void)stopObserving
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dispatchEventInternal:(NSNotification *)notification
{
    NSArray *eventDetails = [notification.userInfo valueForKey:@"detail"];
    NSString *eventName = [eventDetails objectAtIndex:0];
    NSDictionary *eventData = [eventDetails objectAtIndex:1];

    @try {
        [self sendEventWithName:eventName body:eventData];
    } @catch (NSException *error) {
        NSLog(@"An error occurred in RNFetchBlobEventManager:dispatchEvent: %@", [error debugDescription]);
    }
}

+ (void)addSupportedEvent:(NSString *)name {
    [_supportedEvents addObject:name];
}

+ (void)removeSupportedEvent:(NSString *)name {
    [_supportedEvents removeObject:name];
}

+ (void)dispatchEvent:(NSString *)name body:(id)body {
    NSDictionary *eventDetail = @{@"detail":@[name, body]};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"rnfb-event"
                                                        object:self
                                                      userInfo:eventDetail];
}

@end
