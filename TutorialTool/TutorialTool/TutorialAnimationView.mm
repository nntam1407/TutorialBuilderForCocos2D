//
//  TutorialAnimationView.m
//  TutorialTool
//
//  Created by k3 on 11/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TutorialAnimationView.h"
#import "TutorialAnimationTimeLine.h"
#import "TutorialActionTimeLine.h"
#import "TutorialData.h"
@implementation TutorialAnimationView
@synthesize mainScrollView;
@synthesize selectionRect;

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
    NSMutableArray *listActions = [TutorialData getListActionsWithStoryIndex:mainScrollView.currentStoryIndex ofData:mainScrollView.tutorialData];
    
    
    if (listActions.count > 0){
        
        float sumHeight = 0;
        
        for (int i = 0; i < listActions.count; i++){
            NSMutableDictionary *sequenceData = [listActions objectAtIndex:i];
            sumHeight += [ToolUtil getHeightFromSequenceData:sequenceData];
            
            float startHeight = mainScrollView.animationView.frame.size.height - sumHeight - 28;
            
            NSImage *bgImage = [NSImage imageNamed:@"seq-row-0-bg.png"];
            if (i % 2 == 0){
                bgImage = [NSImage imageNamed:@"seq-row-1-bg.png"];
            }
            
            bgImage.size = NSMakeSize(self.frame.size.width, [ToolUtil getHeightFromSequenceData:sequenceData]);
            
            [bgImage drawAtPoint:NSMakePoint(0, startHeight) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
            

        }
        
    }

    if(mainScrollView.selectingSequenceIndex >= 0){
        TutorialActionTimeLine * actionTimeline = [mainScrollView.listActionSequenceView objectAtIndex:mainScrollView.selectingSequenceIndex];
        //draw line at the head of the sequence
        NSImage *headline = [NSImage imageNamed:@"seq-scrub-line.png"];
        [headline setSize:NSMakeSize(headline.size.width, self.frame.size.height)];
        [headline drawAtPoint:NSMakePoint(actionTimeline.frame.origin.x, 0) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
        
        
        //draw line at the end of the sequence        
        NSImage *endline = [NSImage imageNamed:@"seq-scrub-line.png"];
        [endline setSize:NSMakeSize(endline.size.width, self.frame.size.height)];
        [endline drawAtPoint:NSMakePoint(actionTimeline.frame.origin.x + actionTimeline.frame.size.width, 0) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
    }
    
    if (startSelectTimePoint.x != endSelectTimePoint.x || startSelectTimePoint.y != endSelectTimePoint.y){
        
        float x = MIN(startSelectTimePoint.x,endSelectTimePoint.x);
        
        float y = MIN(startSelectTimePoint.y,endSelectTimePoint.y);
        
        //NSLog(@"Start x = %f, y= %f", x, y);
        
        
        float width =startSelectTimePoint.x - endSelectTimePoint.x;
        if (width < 0){
            width = -width;
        }
        
        float height =startSelectTimePoint.y - endSelectTimePoint.y;
        if (height < 0){
            height = -height;
        }
        
        // Draw selection
        NSGraphicsContext* gc = [NSGraphicsContext currentContext];
        [gc saveGraphicsState];
        
        [NSBezierPath clipRect:NSMakeRect(0, 0, self.frame.size.width, self.frame.size.height)];
        
        // Draw the selection rectangle
        selectionRect = NSMakeRect(x, y, width, height);
        
        [[NSColor colorWithDeviceRed:0.83f green:0.88f blue:1.00f alpha:0.50f] set];
        [NSBezierPath fillRect: selectionRect];
        
        [[NSColor colorWithDeviceRed:0.45f green:0.55f blue:0.82f alpha:1.00f] set];
        NSFrameRect(selectionRect);
        
        [gc restoreGraphicsState];
        
//        NSImage *selectionFrame = [NSImage imageNamed:@"rect.jpg"];
//        
//        selectionFrame.size = NSMakeSize(width, height);
//        
//        [selectionFrame drawAtPoint:NSMakePoint(x, y) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
//        
//        selectionRect = NSMakeRect(x, y, width, height);
    }
    
}

-(void)mouseDown:(NSEvent *)theEvent{
    [super mouseDown:theEvent];
    
    startSelectTimePoint =  [self convertPoint:[theEvent locationInWindow] fromView:nil];
    endSelectTimePoint = startSelectTimePoint;
    drag = YES;
    
//    NSLog(@"Start x = %f, y= %f", startSelectTimePoint.x, startSelectTimePoint.y);
//    
//    NSLog(@"End x = %f, y= %f", endSelectTimePoint.x, endSelectTimePoint.y);
    
}

-(void)mouseDragged:(NSEvent *)theEvent{
    endSelectTimePoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    [self setNeedsDisplay:YES];
//    NSLog(@"Start drag x = %f, y= %f", startSelectTimePoint.x, startSelectTimePoint.y);
//    
//    NSLog(@"End drag x = %f, y= %f", endSelectTimePoint.x, endSelectTimePoint.y);
    
}

-(void)mouseUp:(NSEvent *)theEvent{
    [mainScrollView selectAllActionInRect:selectionRect];
    startSelectTimePoint = NSMakePoint(0, 0);
    endSelectTimePoint = startSelectTimePoint;
    //redraw view if user does not click on sequence or action timeline
    mainScrollView.selectingSequenceIndex = -1;
    mainScrollView.selectingActionIndex = -1;
    [self setNeedsDisplay:YES];
}



@end
