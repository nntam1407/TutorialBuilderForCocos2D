//
//  AppDelegate.h
//  TutorialTool
//
//  Created by User on 9/27/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import "cocos2d.h"
#import "MainWindow.h"

@interface TutorialToolAppDelegate : NSObject <NSApplicationDelegate>
{
    MainWindow  *mainWindow;
	NSWindow	*window_;
	CCGLView	*glView_;
}

@property (assign) IBOutlet NSWindow	*window;
@property (assign) IBOutlet CCGLView	*glView;
@property (assign) IBOutlet MainWindow  *mainWindow;
- (IBAction)toggleFullScreen:(id)sender;

-(void)openFiles:(NSArray *)_fileNames;

@end
