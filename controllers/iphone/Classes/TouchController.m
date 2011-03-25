//
//  TouchController.m
//  TrickplayController_v2
//
//  Created by Rex Fenley on 2/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TouchController.h"


@implementation TouchController

@synthesize view;
@synthesize socketManager;

- (id)initWithView:aView socketManager:(SocketManager *)sockman {
    if ((self = [super init])) {
        self.view = aView;
        self.socketManager = sockman;
        touchEventsAllowed = NO;
        clickEventsAllowed = YES;
        swipeSent = NO;
        keySent = NO;
        activeTouches = CFDictionaryCreateMutable(NULL, 10, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
        //activeTouches = [[NSMutableDictionary alloc] initWithCapacity:10];
        openFinger = 1;
        
        [view setMultipleTouchEnabled:YES];
    }
    
    return self;
}

- (void)sendKeyToTrickplay:(NSString *)thekey thecount:(NSInteger)thecount {
	if (socketManager)
	{
	    int index;	
		NSString *sentData = [NSString stringWithFormat:@"KP\t%@\n", thekey];
        
		for (index = 1; index <= thecount; index++) {
			[socketManager sendData:[sentData UTF8String]
                      numberOfBytes:[sentData length]];
		}
		
		keySent = YES;
	}
}

- (void)resetTouches {
    CFDictionaryRemoveAllValues(activeTouches);
    //[activeTouches removeAllObjects];
    swipeSent = NO;
	keySent = NO;
    touchedTime = 0;
}

- (void)setMultipleTouch:(BOOL)val {
    view.multipleTouchEnabled = val;
    [self resetTouches];
}

//*
- (void)addTouch:(UITouch *)touch {
    CFDictionarySetValue(activeTouches, touch, (CFNumberRef)[NSNumber numberWithUnsignedInt:openFinger]);
    //[activeTouches setObject:[NSNumber numberWithInt:openFinger] forKey:touch];
    openFinger++;
}

/**
 * Returns whether or not the touch was sent.
 */
- (BOOL)sendTouch:(UITouch *)touch withCommand:(NSString *)command {
    if (!socketManager || !touchEventsAllowed || !CFDictionaryGetValue(activeTouches, touch)) {//![activeTouches objectForKey:touch]) {
        return NO;
    }
    
    // format: TD/TM/TU <finger> <x> <y>
    CGPoint currentTouchPosition = [touch locationInView:view];
    NSString *sentTouchData = [NSString stringWithFormat:@"%@\t%d\t%f\t%f\n", command, [(NSNumber *)CFDictionaryGetValue(activeTouches, touch) unsignedIntValue], currentTouchPosition.x, currentTouchPosition.y];
    //NSString *sentTouchData = [NSString stringWithFormat:@"%@\t%d\t%f\t%f\n", command, [(NSNumber *)[activeTouches objectForKey:touch] unsignedIntValue], currentTouchPosition.x, currentTouchPosition.y];
    NSLog(@"sent touch data: '%@'", sentTouchData);
    [socketManager sendData:[sentTouchData UTF8String] numberOfBytes:[sentTouchData length]];
    
    return YES;
}
//*/
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touches began");

    keySent = NO;
    
    NSMutableArray *newActiveTouches = [NSMutableArray arrayWithArray:[touches allObjects]];
    int i;
    for (i = 0; i < [newActiveTouches count]; i++) {
        UITouch *touch = [newActiveTouches objectAtIndex:i];
        [self addTouch:touch];
        [self sendTouch:touch withCommand:@"TD"];
    }

    //NSLog(@"multitouch = %d", view.multipleTouchEnabled);
    //NSLog(@"touches = %@", touches);
    if (!view.multipleTouchEnabled) {
        touchedTime = [NSDate timeIntervalSinceReferenceDate];
    } else {
        touchedTime = 0;
    }
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    NSMutableArray *movedTouches = [NSMutableArray arrayWithArray:[touches allObjects]];
    int i;
    BOOL stillActive;
    for (i = 0; i < [movedTouches count]; i++) {
        UITouch *touch = [movedTouches objectAtIndex:i];
        if (![self sendTouch:touch withCommand:@"TM"]) {
            stillActive = NO;
        }
    }
    if (![view isMultipleTouchEnabled] && touchedTime > 0 && stillActive) {
        UITouch *touch = [touches anyObject];
        if (keySent) return;
    
        int numSwipes = 1;
        CGPoint startTouchPosition = [touch previousLocationInView:view];
        CGPoint currentTouchPosition = [touch locationInView:view];
        //Horizontal swipe
        // To be a swipe, direction of touch must be horizontal and long enough.
        //if (fabsf(startTouchPosition.x - currentTouchPosition.x) >= HORIZ_SWIPE_DRAG_MIN &&
        //fabsf(startTouchPosition.y - currentTouchPosition.y) <= VERT_SWIPE_DRAG_MAX)
        if (fabsf(startTouchPosition.x - currentTouchPosition.x) >= HORIZ_SWIPE_DRAG_MIN) {
            if (touchedTime > 0) {
                NSLog(@"swipe speed horiz :%f ", [NSDate timeIntervalSinceReferenceDate] - touchedTime);
                if (touchedTime > 0) {
                    NSLog(@"swipe speed horiz :%f ",[NSDate timeIntervalSinceReferenceDate] - touchedTime);
                    if (([NSDate timeIntervalSinceReferenceDate]  - touchedTime) < 0.05) {
                        //numSwipes = 3;
                    } else if (([NSDate timeIntervalSinceReferenceDate]  - touchedTime) < 0.1) {
                        //numSwipes = 2;
                    }
                }
                // It appears to be a swipe.
                if (startTouchPosition.x < currentTouchPosition.x) {
                    //Send right key -  FF53
                    NSLog(@"swipe right");
                    [self sendKeyToTrickplay:@"FF53" thecount:numSwipes];
                } else {
                    //Send left key  - FF51
                    NSLog(@"Swipe Left");
                    [self sendKeyToTrickplay:@"FF51" thecount:numSwipes];
                }
                swipeSent = YES;
            }
        }
        //Vertical swipe
        //else if (fabsf(startTouchPosition.y - currentTouchPosition.y) >= HORIZ_SWIPE_DRAG_MIN &&
        //		 fabsf(startTouchPosition.x - currentTouchPosition.x) <= VERT_SWIPE_DRAG_MAX)
        else if (fabsf(startTouchPosition.y - currentTouchPosition.y) >= VERT_SWIPE_DRAG_MIN) {
            if (touchedTime > 0) {
                NSLog(@"swipe speed vertical:%f ",[NSDate timeIntervalSinceReferenceDate]  - touchedTime);
                if (([NSDate timeIntervalSinceReferenceDate]  - touchedTime) < 0.05) {
                        //numSwipes = 3;
                } else if (([NSDate timeIntervalSinceReferenceDate]  - touchedTime) < 0.1) {
                    //numSwipes = 2;
                }
            }
            // It appears to be a vertical swipe.
            if (startTouchPosition.y < currentTouchPosition.y) {
                //Send down key -  FF54
                NSLog(@"swipe down");
                [self sendKeyToTrickplay:@"FF54" thecount:numSwipes];
            } else {
                //Send up key  - FF52
                NSLog(@"Swipe up");
                [self sendKeyToTrickplay:@"FF52" thecount:numSwipes];
            }
            swipeSent = YES;            
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSMutableArray *endedTouches = [NSMutableArray arrayWithArray:[touches allObjects]];
    int i;
    BOOL stillActive = YES;
    for (i = 0; i < [endedTouches count]; i++) {
        // send touch command to Trickplay
        UITouch *touch = [endedTouches objectAtIndex:i];
        if (![self sendTouch:touch withCommand:@"TU"]) {
            stillActive = NO;
        }
        // delete touch from active touches
        CFDictionaryRemoveValue(activeTouches, touch);
        //[activeTouches removeObjectForKey:touch];
    }
	
	if (![view isMultipleTouchEnabled] && !swipeSent && stillActive)
	{
		UITouch *touch = [touches anyObject];
        CGPoint startTouchPosition = [touch previousLocationInView:view];
        CGPoint currentTouchPosition = [touch locationInView:view];
		//Send 'Enter' key since no swipe occured but they tapped the screen
		//Don't do this if the start/end points are too far apart
		if (fabsf(startTouchPosition.x - currentTouchPosition.x) <= TAP_DISTANCE_MAX &&
			fabsf(startTouchPosition.y - currentTouchPosition.y) <= TAP_DISTANCE_MAX)
		{
			//Tap occured, send <ENTER> key
			[self sendKeyToTrickplay:@"FF0D" thecount:1];
			//Send click event if click events are enabled
            /**  depricated!
			if (socketManager && clickEventsAllowed)
			{
				NSString *sentClickData = [NSString stringWithFormat:@"CK\t%f\t%f\t%f\n", currentTouchPosition.x,currentTouchPosition.y,[NSDate timeIntervalSinceReferenceDate]];
				[socketManager sendData:[sentClickData UTF8String] numberOfBytes:[sentClickData length]];
			}
            //*/
		}
		else
		{
			NSLog(@"no swipe sent, start.x,.y: (%f, %f)  current.x,.y: (%f, %f)",startTouchPosition.x, startTouchPosition.y, currentTouchPosition.x,currentTouchPosition.y);
		}
		
		
	}

	swipeSent = NO;
	keySent = NO;
    touchedTime = 0;
	NSLog(@"touches ended");
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touches cancelled");
	[self resetTouches];
    // TODO: tell trickplay the touches cancelled
}

/** depricated
- (void)startClicks {
    clickEventsAllowed = YES;
}

- (void)stopClicks {
    clickEventsAllowed = NO;
}
//*/

- (void)startTouches {
    NSLog(@"start touches");
    touchEventsAllowed = YES;
}

- (void)stopTouches {
    NSLog(@"stop touches");
    touchEventsAllowed = NO;
}

- (void)dealloc {
    NSLog(@"TouchController dealloc");
    if (view) {
        [view release];
    }
    if (socketManager) {
        [socketManager release];
    }
    if (activeTouches) {
        CFRelease(activeTouches);
        //[activeTouches release];
    }
    
    [super dealloc];
}

@end