//
//  CustomRuler.m
//  TutorialTool
//
//  Created by User on 11/13/12.
//
//

#import "CustomRuler.h"
#import "MainWindow.h"
#import "TutorialToolDefine.h"
#import "TutorialAnimationTimeLine.h"

@implementation CustomRuler

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        // Background
        imgBg = [[NSImage imageNamed:@"seq-tl-bg.png"] retain];
        [imgBg setFlipped:YES];
        
        // Markers
        imgMarkMajor = [[NSImage imageNamed:@"seq-tl-mark-major.png"] retain];
        imgMarkMinor = [[NSImage imageNamed:@"seq-tl-mark-minor.png"] retain];
        
        [imgMarkMajor setFlipped:YES];
        [imgMarkMinor setFlipped:YES];
        
        imgEndmarker = [[NSImage imageNamed:@"seq-endmarker.png"] retain];
        
        // Numbers
        imgNumbers = [[NSImage imageNamed:@"ruler-numbers.png"] retain];
        
        // Rects for the individual numbers
        for (int i = 0; i < 10; i++)
        {
            numberRects[i] = NSMakeRect(18+6*i, 0, 6, 8);
        }
    }
    
    return self;
}

-(id)initWithFrame:(NSRect)frameRect withTimeLineHandler:(TutorialAnimationTimeLine *)_handler {
    self = [self initWithFrame:frameRect];
    
    handler = _handler;
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
    // Get current sequence
    
    // Draw background
    [imgBg drawInRect:[self bounds] fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
    
    NSRect scrollViewTimeLineVisibleRect = [handler documentVisibleRect];

    float scaleValue = roundf(TIMELINE_PIXEL_PER_UNIT * handler.timeLineScaleSlider.doubleValue);
    //NSLog(@"scale value = %f", scaleValue);
    
    float timeLineScrollViewOffSet = scrollViewTimeLineVisibleRect.origin.x / scaleValue;
    int secondMarker = timeLineScrollViewOffSet;
    float xPos = -roundf((timeLineScrollViewOffSet - secondMarker) * scaleValue);
    int divisions = TIMELINE_DIVISION_COUNT_PER_UINIT;
    float width = [self bounds].size.width;
    float stepSize = scaleValue/divisions;
    int step = 0;
    
    while (xPos < width)
    {
        if (step % divisions == 0)
        {
            // Major marker
            [imgMarkMajor drawAtPoint:NSMakePoint(xPos, 0) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
            
            [self drawNumber:secondMarker at:NSMakePoint(xPos+3, 1)];
            
            secondMarker++;
        }
        else
        {
            // Minor marker
            [imgMarkMinor drawAtPoint:NSMakePoint(xPos, 0) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
        }
        
        step++;
        xPos += stepSize;
    }
    
    //[imgEndmarker drawAtPoint:NSMakePoint(100, 0) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
}

- (void) drawNumber:(int)num at:(NSPoint)pt
{
    NSString* str = [NSString stringWithFormat:@"%d",num*1000];
    for (int i = 0; i < [str length]; i++)
    {
        int ch = [str characterAtIndex:i] - '0';
        
        [imgNumbers drawAtPoint:NSMakePoint(pt.x+i*6, pt.y) fromRect:numberRects[ch] operation:NSCompositeSourceOver fraction:1];
    }
}

//////////////////////////////////////////////////////////
// Mouse events

-(void)mouseDown:(NSEvent *)theEvent {
    NSLog(@"Ruler clicked");
    
    NSPoint mousePoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    [handler updateLineRulerPosition:mousePoint];
}

@end
