//
//  TutorialTextObject.m
//  LibGame
//
//  Created by User on 9/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TutorialTextObject.h"

@implementation TutorialTextObject

-(id)initTutorialTextObjectWith:(TutorialStoryboard *)_tutorialStorboardHandler withData:(NSMutableDictionary *)_objectData {
    
    self = [super initTutorialObjectWith:_tutorialStorboardHandler withData:_objectData];
    
    [self drawText];
    return self;
}

-(void)drawText {
    NSString *textContent = [objectData objectForKey:TUTORIAL_OBJECT_PARAMETER_TEXT_CONTENT];
    NSString *fontName = [objectData objectForKey:TUTORIAL_OBJECT_PARAMETER_FONT_NAME];
    float fontSize = [[objectData objectForKey:TUTORIAL_OBJECT_PARAMETER_FONT_SIZE] floatValue];
    float width = [[objectData objectForKey:TUTORIAL_OBJECT_PARAMETER_WIDTH_KEY] floatValue];
    float height = [[objectData objectForKey:TUTORIAL_OBJECT_PARAMETER_HEIGHT_KEY] floatValue];
    
    spriteBody = [[CCLabelTTF alloc] initWithString:textContent dimensions:CGSizeMake(width, height) hAlignment:kCCTextAlignmentCenter fontName:fontName fontSize:fontSize];
    ((CCLabelTTF *)spriteBody).color = ccc3(0, 0, 0);
    
    [self applyObjectBodyProperties];
}

-(void)applyObjectBodyProperties {
    [super applyObjectBodyProperties];
    
    //get properties value from data for text type
    
    float rotation = [[objectData objectForKey:TUTORIAL_OBJECT_PARAMETER_ROTATION_KEY] floatValue];
    spriteBody.rotation = rotation;
    
    NSString *textContent = [objectData objectForKey:TUTORIAL_OBJECT_PARAMETER_TEXT_CONTENT];
    NSString *fontName = [objectData objectForKey:TUTORIAL_OBJECT_PARAMETER_FONT_NAME];
    float fontSize = [[objectData objectForKey:TUTORIAL_OBJECT_PARAMETER_FONT_SIZE] floatValue];
    float width = [[objectData objectForKey:TUTORIAL_OBJECT_PARAMETER_WIDTH_KEY] floatValue];
    float height = [[objectData objectForKey:TUTORIAL_OBJECT_PARAMETER_HEIGHT_KEY] floatValue];
    float opacity = [[objectData objectForKey:TUTORIAL_OBJECT_PARAMETER_OPACITY] floatValue];
    float color_R = [[objectData objectForKey:TUTORIAL_OBJECT_PARAMETER_COLOR_R] floatValue];
    float color_G = [[objectData objectForKey:TUTORIAL_OBJECT_PARAMETER_COLOR_G] floatValue];
    float color_B = [[objectData objectForKey:TUTORIAL_OBJECT_PARAMETER_COLOR_B] floatValue];
    
    [((CCLabelTTF *)spriteBody) setString:textContent];
    [((CCLabelTTF *)spriteBody) setFontName:fontName];
    [((CCLabelTTF *)spriteBody) setFontSize:fontSize];
    [((CCLabelTTF *)spriteBody) setDimensions:CGSizeMake(width, height)];
    [((CCLabelTTF *)spriteBody) setColor:ccc3(color_R, color_G, color_B)];
    [((CCLabelTTF *)spriteBody) setOpacity:opacity];
}

@end
