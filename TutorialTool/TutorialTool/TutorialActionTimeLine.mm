//
//  TutorialActionTimeLine.m
//  TutorialTool
//
//  Created by k3 on 10/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TutorialActionTimeLine.h"
#import "TutorialAnimationTimeLine.h"
#import "TutorialLibDefine.h"
#import "ToolUtil.h"

@implementation TutorialActionTimeLine
@synthesize actionIndex;
@synthesize sequenceIndex;
@synthesize rowGUIIndex;
@synthesize selectState;
@synthesize handler;

- (id)initWithFrame:(NSRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (id)initWithFrame:(NSRect)frame withActionData:(NSMutableDictionary *)_actionData withSequenceTimeLine:(TutorialAnimationTimeLine *)_handler{
    self = [self initWithFrame:frame];
    if (self) {
        
        handler = _handler;
        // Initialization code here.
        NSString *actionType = [_actionData objectForKey:TUTORIAL_ACTION_DATA_KEY_ACTION_TYPE];

        resizeable = YES;

        if ([actionType isEqualToString:TUTORIAL_ACTION_SHOW] ||            
            [actionType isEqualToString:TUTORIAL_ACTION_HIDE] || [actionType isEqualToString:TUTORIAL_ACTION_CALL_FUNCTION_IN_GAME]){

            resizeable = NO;
        }
    }
    return self;
}


- (id)initWithActionData:(NSMutableDictionary *)_actionData{
    
    self = [self initWithFrame:NSMakeRect(0, 0, 0, 10)];
    
    if (self) {
        // Initialization code here.

    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect{
    // Drawing code here.
    // Drawing border depend on view's state
    
    
    // Draw duration bar
    //if this bar is choosing, draw it with diffrence image

    if (selectState == ACTION_TIMELINE_SAME_TARGET_SELECT_STATE){
        durationImage = [NSImage imageNamed:@"seq-keyframe-interpol-selected-2.png"];
    } else if(selectState == ACTION_TIMELINE_SELECT_STATE){
        durationImage = [NSImage imageNamed:@"seq-keyframe-interpol-selected-1.png"];
    }
    else{
        durationImage = [NSImage imageNamed:@"seq-keyframe-interpol.png"];
    }
    

    
    [durationImage setSize:NSMakeSize(self.frame.size.width, self.frame.size.height)];

    [durationImage drawAtPoint:NSMakePoint(0, 0) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];

    // Draw start key 
    startImage = [NSImage imageNamed:@"seq-keyframe-l.png"];

    //[startImage setSize:NSMakeSize(20, 20)];

    [startImage drawAtPoint:NSMakePoint(0, 0) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];

    // Draw end key
    endImage = [NSImage imageNamed:@"seq-keyframe-l.png"];

    //[endImage setSize:NSMakeSize(20, 20)];

    [endImage drawAtPoint:NSMakePoint(self.frame.size.width - endImage.size.width, 0) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
    
    if(trackingArea) {
        [self removeTrackingArea:trackingArea];
        [trackingArea release];
        trackingArea = nil;
    }
    
    trackingArea = [[NSTrackingArea alloc] initWithRect:NSMakeRect(0, 0, self.frame.size.width, self.frame.size.height) options:NSTrackingMouseMoved | NSTrackingMouseEnteredAndExited | NSTrackingCursorUpdate | NSTrackingActiveInKeyWindow  owner:self userInfo:NULL];
    
    [self addTrackingArea:trackingArea];
}

-(void)mouseDown:(NSEvent *)theEvent{
    NSLog(@"mouse clicked");
    
    oldMousePosition = [theEvent locationInWindow];
    
    NSPoint mousePoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    [handler unselectAllActionTimeline];
    if (handler.selectingObjectName && ![handler.selectingObjectName isEqualTo:@""]){
        [handler selectActionTimelineWithTargetName:handler.selectingObjectName];
    }
    selectState = ACTION_TIMELINE_SELECT_STATE;
    
    if ([self isAtEndNodeWithPoint:mousePoint]){
        mode = DRAG_MODE_CHANGE_DURATION_END;
    }    
    [handler select:actionIndex inSequence:sequenceIndex];
}

-(void)rightMouseDown:(NSEvent *)theEvent {
    NSLog(@"right mouse down on action index = %d", actionIndex);
    
    [handler select:actionIndex inSequence:sequenceIndex];
    
    [super rightMouseDown:theEvent];
}

-(void)mouseDragged:(NSEvent *)theEvent{
    NSPoint mousePoint = [self convertPoint:[theEvent locationInWindow] toView:self];
    
    oldMousePosition = [self convertPoint:oldMousePosition toView:self];
    
    float deltaX = mousePoint.x - oldMousePosition.x;
    
    float deltaY = mousePoint.y - oldMousePosition.y;
    
    float newXPosition = self.frame.origin.x + deltaX;
    float newYPosition = self.frame.origin.y + deltaY;
    
    
    if (self.frame.origin.x + deltaX < 0){
        
        newXPosition = 0;
        
    }
    if (self.frame.origin.y + deltaY < 0){
        
        newYPosition = 0;
    }
    
    
    if (mode == DRAG_MODE_CHANGE_DURATION_END && resizeable ){
        
        //if clicked at the end key then change its lenght and move all actions after this action by delta X

        
        if (self.frame.size.width + deltaX >= 0){
            
            [self changeDurationWithDeltaX:deltaX];
            
            //[handler moveAllActionsAfterAction:actionIndex by:deltaX];
            
            [handler updateSelectActionDurationTimeWith:self.frame.size.width /roundf(TIMELINE_PIXEL_PER_UNIT * handler.timeLineScaleSlider.doubleValue)];
        }
        oldMousePosition = mousePoint;
        
    }else {
        float actionViewTotalWidth = self.frame.origin.x + self.frame.size.width;
        float actionViewTotalHeight = 0;
//        float actionViewTotalHeight = self.frame.origin.y + self.frame.size.height;
        
        NSPoint newPosition = NSMakePoint(newXPosition, newYPosition);
        [self setFrameOrigin:newPosition];
        [ToolUtil expandView:handler.animationView withWidh:actionViewTotalWidth andHeight:actionViewTotalHeight];
        
        //move the whole sequence by delta X
        //[handler moveSequenceTimeLineBy:deltaX];

        //update value for this sequence
        //[handler changeSelectSequenceStartAfterTimeBy:deltaX /roundf(TIMELINE_PIXEL_PER_UNIT * handler.timeLineScaleSlider.doubleValue)];
        
        [handler updateSequenceStartAfterTimeWith:self.frame.origin.x / roundf(TIMELINE_PIXEL_PER_UNIT * handler.timeLineScaleSlider.doubleValue)];
        
        oldMousePosition = mousePoint;
    }
    
    //when mouse move to close border, scroll content view of TutorialAnimationTimeLine
    /*
    if(handler.handler.frame.size.width - mousePoint.x < 100){
        [handler moveScrollBarBy:deltaX];
    }*/
    [handler setNeedsDisplay:YES];
    
    //[handler hidePopupInfoOfAction:self];
    [handler showPopupInfoOfAction:self withMouseEvent:theEvent];
}

-(void)mouseMoved:(NSEvent *)theEvent {
    [handler showPopupInfoOfAction:self withMouseEvent:theEvent];
}

-(void)mouseExited:(NSEvent *)theEvent {
    [handler hidePopupInfoOfAction:self];
}

//change the lenght of the action view by deltaX
-(void)changeDurationWithDeltaX:(float)_deltaX{
    float newWidth = self.frame.size.width + _deltaX;
    if (newWidth <= 0)
        newWidth = 10;
    [self setFrameSize:NSMakeSize(newWidth, self.frame.size.height)];
    TutorialActionTimeLine *actionView = [handler actionTimeLineViewCollideWith:self];
    if (actionView){
        [self setFrameSize:NSMakeSize(actionView.frame.origin.x - self.frame.origin.x, self.frame.size.height)];
    }

}

//move the action view by deltaX
-(void)moveTimeLineBy:(float)_deltaX{
    
    [self setFrameOrigin:NSMakePoint(self.frame.origin.x + _deltaX, self.frame.origin.y)];
    
}

-(void)mouseUp:(NSEvent *)theEvent{
    //return to normal mode
    mode = NORMAL_MODE;
    
    [handler doneEditAction:self];

    [handler updateSequenceStartAfterTimeWith:self.frame.origin.x / roundf(TIMELINE_PIXEL_PER_UNIT * handler.timeLineScaleSlider.doubleValue)];
    [ToolUtil expandView:handler.animationView withWidh:self.frame.origin.x + self.frame.size.width andHeight:0];
    
    [handler hidePopupInfoOfAction:self];
    [handler setNeedsDisplay:YES];
}

//check if mouse clicked at the end key
-(BOOL)isAtEndNodeWithPoint:(NSPoint)_point{
    
    _point = NSMakePoint(_point.x + self.frame.origin.x, _point.y + self.frame.origin.y);

    NSPoint endFrameOrigin = NSMakePoint(self.frame.origin.x + self.frame.size.width, self.frame.origin.y);
    
    NSRect endImageRect = NSMakeRect(endFrameOrigin.x -endImage.size.width, endFrameOrigin.y, endImage.size.width, endImage.size.height);
    
    return [Helpers isPoint:_point inRect:endImageRect];
}



@end
