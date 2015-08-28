//
//  CustomRuler.h
//  TutorialTool
//
//  Created by User on 11/13/12.
//
//

#import <Cocoa/Cocoa.h>

#define kCCBDefaultTimelineScale 128

@class TutorialAnimationTimeLine;

@interface CustomRuler : NSView {
    NSImage* imgBg;
    NSImage* imgMarkMajor;
    NSImage* imgMarkMinor;
    NSImage* imgNumbers;
    NSImage* imgEndmarker;
    NSRect numberRects[10];
    
    TutorialAnimationTimeLine *handler;
}

-(id)initWithFrame:(NSRect)frameRect withTimeLineHandler:(TutorialAnimationTimeLine *)_handler;

@end
