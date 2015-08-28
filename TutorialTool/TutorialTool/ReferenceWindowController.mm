//
//  ReferenceWindowWindowController.m
//  TutorialTool
//
//  Created by User on 11/19/12.
//
//

#import "ReferenceWindowController.h"
#import "MainWindow.h"

@interface ReferenceWindowController ()

@end

@implementation ReferenceWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (id)initWithMainWindow:(MainWindow *)_mainWindow {
    self = [super initWithWindowNibName:@"ReferenceWindowController"];
    
    if(self) {
        mainWindow = _mainWindow;
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (void)awakeFromNib {
    [self setGUIValue];
}

#pragma mark IBOutlet

- (IBAction)closeWindow:(id)sender {
    [mainWindow closeReferenceWindow];
}

- (IBAction)applySetting:(id)sender {
    int autoSaveDelayTime = [textFieldAutosaveTime.stringValue intValue];
    
    if(autoSaveDelayTime <= 0) {
        autoSaveDelayTime = 60;
    }
    
    mainWindow.autoSaveProjectDelayTime = autoSaveDelayTime;
    
    //reload to right value on GUI
    [self setGUIValue];
    
    [mainWindow closeReferenceWindow];
}

#pragma mark refernce window's functions

-(void) setGUIValue {
    textFieldAutosaveTime.stringValue = [NSString stringWithFormat:@"%d", mainWindow.autoSaveProjectDelayTime];
}

@end
