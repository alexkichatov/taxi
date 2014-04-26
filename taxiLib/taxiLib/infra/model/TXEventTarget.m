//
//  TXEventTarget.m
//  Taxi
//
//  Created by Irakli Vashakidze on 1/19/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import "TXEventTarget.h"
#import "StrConsts.h"

@implementation TXEvent

-(id) init {
	self = [super init];
	if ( self ) {
        self.propageteEvent = YES;
	}
	return self;
}

+(TXEvent*) createEvent:(NSString*)evName eventSource:(id)eventSource eventProps:(NSDictionary*)eventProps {
    
    TXEvent* event = [[TXEvent alloc] init];
    event.name = [evName copy];
    event.source = eventSource;
    event.cancelAction = NO;
    event.propageteEvent = YES;
    
    if ( eventProps != nil )
        [event setEventProperties:eventProps];
    
    return event;
}

-(id) getEventProperty:(NSString*)propName {
    if ( self->eventPropMap != nil )
        return [self->eventPropMap objectForKey:propName];
    return nil;
}

-(void) setEventProperty:(NSString*)propName value:(id)value {
    if ( [propName length] > 0 && value != nil ) {
        
        if ( self->eventPropMap == nil )
            self->eventPropMap = [NSMutableDictionary dictionaryWithCapacity:5];
        
        [self->eventPropMap setObject:value forKey:propName];
    }
}

-(NSDictionary *)getEventProperties {
    return self->eventPropMap;
}

-(void) setEventProperties:(NSDictionary*)eventProps {
    if ( self->eventPropMap == nil )
        self->eventPropMap = [NSMutableDictionary dictionaryWithCapacity:[eventProps count]];
    
    [self->eventPropMap addEntriesFromDictionary:eventProps];
}


-(NSString *) description {
    return [NSString stringWithFormat:@"Event code : %d, name : %@", self.code, self.name];
}

@end

@implementation TXEventSubscription

+(TXEventSubscription*) createSubscription:(id<TXEventListener>)listener
                      withSubscriptionParams:(id)subscriptionParams {
    
    TXEventSubscription* subscription = [[TXEventSubscription alloc] init];
    subscription.listener = listener;
    subscription.eventParams = subscriptionParams;
    
    return subscription;
}

@end

@interface TXEventTarget()

-(BOOL)dispatchEvent:(TXEvent*)event;

@end

@implementation TXEventTarget

@dynamic targetParent;


-(id) init {
	self = [super init];
	if ( self ) {
        self->listenerMap = [NSMutableDictionary dictionaryWithCapacity:64];
        self->targetParent = nil;
	}
	return self;
}

/** creates the single instance within the application
 
 @return TXEventTarget
 */
+(TXEventTarget *) instance {
    static dispatch_once_t pred;
    static TXEventTarget* _instance;
    dispatch_once(&pred, ^{ _instance = [[self alloc] init]; });
    return _instance;
}

-(bool) addEventListener:(id<TXEventListener>)listener forEvent:(NSString*)eventName
             eventParams:(id)subscriptionParams {
    
    if ( listener != nil && [eventName length] > 0 ) {
        
        NSMutableArray* eventSubscriptions = [listenerMap objectForKey:eventName];
        
        if ( eventSubscriptions == nil ) {
            eventSubscriptions = [NSMutableArray arrayWithCapacity:5];
        }
        
        TXEventSubscription* subscription = [TXEventSubscription createSubscription:listener
                                                                 withSubscriptionParams:subscriptionParams];
        
        /*
         * Find if we have the same listener already registered on this object, and remove it.
         */
        for ( int i = 0; i < [eventSubscriptions count]; i++ ) {
            TXEventSubscription* cs = [eventSubscriptions objectAtIndex:i];
            if ( cs.listener == listener ) {
                [eventSubscriptions removeObjectAtIndex:i];
                break;
            }
        }
        
        [eventSubscriptions addObject:subscription];
        [listenerMap setObject:eventSubscriptions forKey:eventName];
        
        return YES;
    }
    
    return NO;
}

-(bool) removeEventListener:(id<TXEventListener>)listener forEvent:(NSString*)eventName {
    
    if ( listener != nil && [eventName length] > 0 ) {
        
        NSMutableArray* eventSubscriptions = [listenerMap objectForKey:eventName];
        
        if ( eventSubscriptions != nil ) {
            for ( int i = 0; i < [eventSubscriptions count]; i++ ) {
                TXEventSubscription* cs = [eventSubscriptions objectAtIndex:i];
                if ( cs.listener == listener ) {
                    [eventSubscriptions removeObjectAtIndex:i];
                    return YES;
                }
            }
        }
    }
    
    return NO;
}

-(bool) removeEventListener:(id<TXEventListener>)listener {
    
    if ( listener != nil ) {
        
        for (NSString *eventName in [listenerMap keyEnumerator]) {
            
            NSMutableArray* eventSubscriptions = [listenerMap objectForKey:eventName];
            
            if ( eventSubscriptions != nil ) {
                for ( int i = 0; i < [eventSubscriptions count]; i++ ) {
                    TXEventSubscription* cs = [eventSubscriptions objectAtIndex:i];
                    if ( cs.listener == listener ) {
                        [eventSubscriptions removeObjectAtIndex:i];
                        break;
                    }
                }
            }
        }
        return YES;
    }
    
    return NO;
}

-(void) fireEvent:(TXEvent *)event {
    /* do event preprocessing here and then dispatch it. If necessary prevent firing before calling dispatch */
    if ( event != nil && [event.name length] > 0 ) {
        [self dispatchEvent:event];
    }
}

-(TXEventTarget*) getTargetParent {
    return self->targetParent;
}

-(void) setTargetParent:(TXEventTarget*)parentTarget {
    
    self->targetParent = parentTarget;
}

-(BOOL)dispatchEvent:(TXEvent*)event {
    
    if ( [event.name length] > 0 ) {
        
        NSMutableArray* eventSubscriptions = [listenerMap objectForKey:event.name];
        
        /* 
         * First call all the listeners registered on the current object
         */
        for ( int i = 0; i < [eventSubscriptions count]; i++ ) {
            
            TXEventSubscription* cs = [eventSubscriptions objectAtIndex:i];
            if ( cs.listener != nil ) {
                
                @try {
                    [cs.listener onEvent:event eventParams:cs.eventParams];
                    
                    /* 
                     * If current listener cancelled this action, bail out, none else needs ot see this event.
                     */
                    if ( event.cancelAction == YES )
                        return NO;
                }@catch (NSException *exception) {
                    
                    TXEvent *crashEvent = [TXEvent createEvent:TXEvents.EVENT_FIRE_CRASHED eventSource:self eventProps:@{ Events.NAME : event.name, Events.LISTENER_CLASS_NAME : cs.listener }];
                    [self fireEvent:crashEvent];
                    
                }@finally {
                    
                }
            }
        }
        
        /* 
         * If event propagation is still true bubble event up in the parent tree
         */
        if ( event.propageteEvent ) {
            TXEventTarget* evTarget = [self getTargetParent];
            if ( evTarget != nil ) {
                [evTarget fireEvent:event];
            }
        }
        return YES;
    }
    
    return NO;
}


@end
