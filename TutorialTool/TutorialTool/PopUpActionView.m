//
//  PopUpActionView.m
//  TutorialTool
//
//  Created by k3 on 11/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PopUpActionView.h"
#import "Helpers.h"

@implementation PopUpActionView
@synthesize controller;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
    
//    CGContextRef context = (CGContextRef) [[NSGraphicsContext currentContext] graphicsPort];
//    CGContextSetRGBFillColor(context, 0.227,0.251,0.337,0.8);
//    CGContextFillRect(context, NSRectToCGRect(dirtyRect));
    
}

-(void)mouseDown:(NSEvent *)theEvent{
    oldMousePosition = [theEvent locationInWindow];
     
    [controller.sequenceHandle.handler select:controller.actionIndex inSequence:controller.sequenceHandle.sequenceIndex];
}

-(void)mouseDragged:(NSEvent *)theEvent{
    
    NSPoint mousePoint = [self convertPoint:[theEvent locationInWindow] toView:self];
        
    oldMousePosition = [self convertPoint:oldMousePosition toView:self];
    
    float deltaX = mousePoint.x - oldMousePosition.x;
    
  
        
        
    //move the whole sequence by delta X
    [controller.sequenceHandle moveSequenceTimeLineBy:deltaX];
        
    if (controller.sequenceHandle.frame.origin.x + deltaX >= 0){
            [controller.sequenceHandle.handler changeSelectSequenceStartAfterTimeBy:deltaX /TIMELINE_PIXEL_PER_UNIT];
    }
    oldMousePosition = mousePoint;
    
    
    //when mouse move to close border, scroll content view of TutorialAnimationTimeLine
    /*
    if(controller.sequenceHandle.handler.frame.size.width - mousePoint.x < 100){
        [controller.sequenceHandle moveScrollBarBy:deltaX];
    }*/
    [controller.sequenceHandle.handler setNeedsDisplay:YES];
    oldMousePosition = mousePoint;
}


@end
