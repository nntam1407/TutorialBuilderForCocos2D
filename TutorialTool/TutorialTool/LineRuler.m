//
//  LineRuler.m
//  TutorialTool
//
//  Created by User on 11/1/12.
//
//

#import "LineRuler.h"
#import "Helpers.h"

@implementation LineRuler

-(id)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    
    if (self) {
        // Initialization code here.        
        [self loadView];
    }
    
    return self;
}

-(void)loadView {
    imgScrubHandle = [[NSImage imageNamed:@"seq-scrub-handle.png"] retain];
    imgScrubLine = [[NSImage imageNamed:@"seq-scrub-line.png"] retain];
}

-(void)drawRect:(NSRect)dirtyRect {    
    // Draw scrubber    
    // Handle
    [imgScrubHandle drawAtPoint:NSMakePoint(0, self.frame.size.height - 28) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
    
    // Line
    [imgScrubLine drawInRect:NSMakeRect(3, 0, 2, self.frame.size.height - 28) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
}

-(void)mouseDown:(NSEvent *)theEvent {
    NSPoint mousePoint = [self convertPoint:[theEvent locationInWindow] toView:self];

    oldMousePos = mousePoint;
}

-(void)mouseDragged:(NSEvent *)theEvent {
    NSPoint mousePoint = [self convertPoint:[theEvent locationInWindow] toView:self];
        
    float deltaX = mousePoint.x - oldMousePos.x;
    [self setFrameOrigin:CGPointMake(self.frame.origin.x + deltaX, self.frame.origin.y)];
    
    oldMousePos = mousePoint;
}

@end
