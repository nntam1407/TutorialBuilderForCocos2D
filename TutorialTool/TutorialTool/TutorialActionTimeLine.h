//
//  TutorialActionTimeLine.h
//  TutorialTool
//
//  Created by k3 on 10/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class TutorialAnimationTimeLine;

enum{
    NORMAL_MODE = 0,
    DRAG_MODE_CHANGE_DURATION_END,
    DRAG_MODE_CHANGE_START_AFTER_TIME
};

@interface TutorialActionTimeLine : NSView {
    NSImage *startImage;
    NSImage *endImage;
    NSImage *durationImage;
    CALayer *borderLayer;
    int actionIndex;
    int sequenceIndex;
    int rowGUIIndex;
    int selectState;
    BOOL resizeable;
    
    NSPoint oldMousePosition;
    int mode;
    TutorialAnimationTimeLine *handler;
    
    NSTrackingArea* trackingArea;
}

@property (nonatomic) int actionIndex;
@property (nonatomic) int sequenceIndex;
@property (nonatomic) int rowGUIIndex;
@property (nonatomic) int selectState;
@property (nonatomic, retain) TutorialAnimationTimeLine *handler;

- (id)initWithFrame:(NSRect)frame withActionData:(NSMutableDictionary *)_actionData withSequenceTimeLine:(TutorialAnimationTimeLine *)_handler;

- (id)initWithActionData:(NSMutableDictionary *)_actionData;

-(void)changeDurationWithDeltaX:(float)_deltaX;

-(void)moveTimeLineBy:(float)_deltaX;

-(BOOL)isAtEndNodeWithPoint:(NSPoint)_point;



@end
