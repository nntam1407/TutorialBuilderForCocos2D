//
//  ReferenceWindowWindowController.h
//  TutorialTool
//
//  Created by User on 11/19/12.
//
//

#import <Cocoa/Cocoa.h>

@class MainWindow;

@interface ReferenceWindowController : NSWindowController {
    MainWindow *mainWindow;
    
    IBOutlet NSTextField *textFieldAutosaveTime;
}

- (id)initWithMainWindow:(MainWindow *)_mainWindow;

#pragma mark IBOutlet

- (IBAction)closeWindow:(id)sender;
- (IBAction)applySetting:(id)sender;

#pragma mark refernce window's functions

-(void) setGUIValue;

@end
