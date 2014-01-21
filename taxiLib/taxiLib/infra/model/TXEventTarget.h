//
//  TXEventTarget.h
//  Taxi
//
//  Created by Irakli Vashakidze on 1/19/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TXEvents.h"

@class TXEventTarget;

/*!
 @interface TXEvent
 @discussion Event object fired form any source.
 
 */

@interface TXEvent : NSObject {
    NSMutableDictionary* eventPropMap;
}

/*!
 @property code integer code of the event.
 */
@property (nonatomic, assign) int code;

/*!
 @property nam event name, string.
 */
@property (nonatomic, strong) NSString* name;

/*!
 @property source TXEventTarget object instance associated with the event.
 */
@property (nonatomic, strong) TXEventTarget* source;

/*!
 @property propageteEvent
 Event propagation flag, when set to true allows event bubbling up in the object tree,
 set to false to prevent propagation. Default value is true.
 */
@property (nonatomic, assign) bool propageteEvent;

/*!
 @property cancelAction
 If set to true cancels an action before which the event was fired
 */
@property (nonatomic, assign) bool cancelAction;

/*!
 @function createEvent Convenience function to create event object
 @param evName Name of the event
 @param eventSource The object which fired the event.
 @param eventProps Event properties, disctionary with property names as keys and vlaues.
 @return TXEvent object
 */
+(TXEvent*) createEvent:(NSString*)evName eventSource:(id)eventSource eventProps:(NSDictionary*)eventProps;


-(id) getEventProperty:(NSString*)propName;
-(void) setEventProperty:(NSString*)propName value:(id)value;
-(void) setEventProperties:(NSDictionary*)eventProps;

@end


/*!
 @protocol TXEventListener
 @discussion Protocol for the event handler objects
 */
@protocol TXEventListener

-(void) onEvent:(TXEvent*)event eventParams:(id)subscriptionParams;

@end


/*!
 @interface TXEventSubscription
 @discussion helper object to store event registration parameters including the listener and asosciated subscription
 object.
 */

@interface TXEventSubscription : NSObject {
    
}

/*!
 @property listener
 listener which will be invoked when the registered event is fired for ghe given object.
 */
@property(nonatomic, strong) id<TXEventListener> listener;

/*!
 @property eventParams
 additional parameters passed to the object when registering for event listening.
 */
@property(nonatomic, strong) id eventParams;


/*!
 @function createSubscription Convenience function to create subscription object
 @param listener Event listener reference
 @param subscriptionParams Additional parameters for the event listener registration
 */
+(TXEventSubscription*) createSubscription:(id<TXEventListener>) listener withSubscriptionParams:(id)subscriptionParams;

@end


/*!
 @interface TXEventTarget
 @discussion Base class for all event firing capable classes. In general, when performing certain action
 event target fires TXEvent object instance with relevant event information. Event target accepts multiple
 event listeners per event and supports event bubbling, where events fired on the object propagate to its parents
 after all registered listeners are called on the object. TO prevent event propagation set the bPropageteEvent to false.
 */

@interface TXEventTarget : NSObject {
    NSMutableDictionary* listenerMap;
    TXEventTarget* targetParent;
}

/*!
 @property targetParent
 parent object reference for event hierarchy.
 */

@property (readwrite, nonatomic, strong) TXEventTarget* targetParent;



/*! @function instance creates the single instance within the application
 @return TXEventTarget
 */
+(TXEventTarget *) instance;

/*!
 @function fireEvent fires an event which will be processed as described in discussion section
 @param event Event object to send to the registered listeners
 */
-(void) fireEvent:(TXEvent*) event;

/*!
 @function addEventListener add event listener to the target. Listener must implement TXEventListener protocol
 @param listener Reference of the event listener object, not null
 @param eventName The name of the event for which the listener is subscribing
 @param subscriptionParams Additional parameters for subscribing to the event, e.g. changefieldvalue event may take field name list for which it would like to receive events, vs. all of the fields.
 */
-(bool) addEventListener:(id<TXEventListener>)listener forEvent:(NSString*)eventName eventParams:(id)subscriptionParams;

/*!
 @function removeEventListener remove event listener from the target for a specific event
 @param listener Reference of the event listener object, not null
 @param eventName The name of the event for which the listener is subscribing
 */
-(bool) removeEventListener:(id<TXEventListener>)listener forEvent:(NSString*)eventName;

/*!
 @function removeEventListener remove event listener from the target for all events
 @param listener Reference of the event listener object, not null
 */
-(bool) removeEventListener:(id<TXEventListener>)listener;

-(TXEventTarget*) getTargetParent;
-(void)setTargetParent:(TXEventTarget*)parentTarget;

@end
