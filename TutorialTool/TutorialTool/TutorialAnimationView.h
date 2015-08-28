//
//  TutorialAnimationView.h
//  TutorialTool
//
//  Created by k3 on 11/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class TutorialAnimationTimeLine;

@interface TutorialAnimationView : NSView{
//    NSMutableArray *listSequenceView;
    TutorialAnimationTimeLine *mainScrollView;
    
    // Current selection
    NSPoint startSelectTimePoint;
    NSPoint endSelectTimePoint;
    BOOL drag;
    NSRect selectionRect;
}
@property (nonatomic,retain) TutorialAnimationTimeLine *mainScrollView;
@property (nonatomic) NSRect selectionRect;

@end
