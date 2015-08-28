//
//  LineRuler.h
//  TutorialTool
//
//  Created by User on 11/1/12.
//
//

#import <Cocoa/Cocoa.h>

@interface LineRuler : NSView {
    NSImage* imgScrubHandle;
    NSImage* imgScrubLine;
    
    CGPoint oldMousePos;
}

-(void)loadView;

@end
