//
//  TutorialXMLDataParse.m
//  LibGame
//
//  Created by User on 9/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TutorialXMLDataParse.h"

@implementation TutorialXMLDataParse

-(id)initTutorialXMLDataParse {
    self = [super init];
    
    return self;
}

-(NSMutableDictionary *)getTutorialLibDataWithXmlFile:(NSString *)_fileName {
    tutorialData = [[NSMutableDictionary alloc] init];
    
    NSString *fullXmlPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:_fileName];
    NSData *tutorialXmlData = [[NSData alloc] initWithContentsOfFile:fullXmlPath];
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:tutorialXmlData];
    [parser setShouldResolveExternalEntities:YES];
    parser.delegate = self;
    
    BOOL success = [parser parse];
    
    [tutorialXmlData release];
    [parser release];
    
    if(success) {
        return tutorialData;
    } else {
        //NSLog(@"Error data access");
        
        return nil;
    }
}

-(NSMutableDictionary *)getTutorialLibDataWithXmlFilePathAbsolute:(NSString *)_fileName {
    tutorialData = [[NSMutableDictionary alloc] init];

    NSData *tutorialXmlData = [[NSData alloc] initWithContentsOfFile:_fileName];
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:tutorialXmlData];
    [parser setShouldResolveExternalEntities:YES];
    parser.delegate = self;
    
    BOOL success = [parser parse];
    
    [tutorialXmlData release];
    [parser release];
    
    if(success) {
        return tutorialData;
    } else {
        //NSLog(@"Error data access");
        
        return nil;
    }
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    //NSLog(@"Element Name %@", elementName);
    
    if([elementName isEqualToString:@"Object"]) {
        [[[[tutorialData objectForKey:@"Storyboard"] lastObject] objectForKey:@"Objects"] setObject:attributeDict forKey:[attributeDict valueForKey:@"Name"]];
        
    } else if([elementName isEqualToString:@"Resources"]) {
        
        currentParentElementName = elementName;
        
        NSMutableDictionary *listResource = [[NSMutableDictionary alloc] init];
        [tutorialData setObject:listResource forKey:@"Resources"];
        
    } else if([elementName isEqualToString:@"TexturePlist"]) {
        
        NSMutableArray *listTexturePlist = [[NSMutableArray alloc] init];
        [[tutorialData objectForKey:@"Resources"] setObject:listTexturePlist forKey:elementName];
        
    } else if([elementName isEqualToString:@"Storyboard"]) {
        
        currentParentElementName = elementName;
        
        NSMutableArray *listStory = [[NSMutableArray alloc] init];
        [tutorialData setObject:listStory forKey:@"Storyboard"];
        
    } else if([elementName isEqualToString:@"Story"]) {
        
        NSMutableDictionary *story = [[NSMutableDictionary alloc] init];
        [[tutorialData objectForKey:@"Storyboard"] addObject:story];
        
    } else if([elementName isEqualToString:@"Objects"]) {
        
        NSMutableDictionary *objectsInStoryboard = [[NSMutableDictionary alloc] init];
        [[[tutorialData objectForKey:@"Storyboard"] lastObject] setObject:objectsInStoryboard forKey:@"Objects"];
        
    } else if([elementName isEqualToString:@"Actions"]) {
        
        NSMutableArray *listActions = [[NSMutableArray alloc] init];
        [[[tutorialData objectForKey:@"Storyboard"] lastObject] setObject:listActions forKey:@"Actions"];
        
    } else if([elementName isEqualToString:@"Action"]) {
        
        [[[[tutorialData objectForKey:@"Storyboard"] lastObject] objectForKey:@"Actions"] addObject:attributeDict];
        
    } else if([elementName isEqualToString:@"ActionSequence"]) {
        currentParentElementName = elementName;
        
        NSMutableArray *actionSequence  = [[NSMutableArray alloc] init];
        [[[[[tutorialData objectForKey:@"Storyboard"] lastObject] objectForKey:@"Actions"] lastObject] setObject:actionSequence forKey:elementName];
        
    } else if([elementName isEqualToString:@"ActionSequenceItem"]) {
        
        [[[[[[tutorialData objectForKey:@"Storyboard"] lastObject] objectForKey:@"Actions"] lastObject] objectForKey:@"ActionSequence"] addObject:attributeDict];
        
    } else if([elementName isEqualToString:@"ListOnPoint"]) { //List point for onPointMoving
        
        NSMutableArray *listOnPoint = [[NSMutableArray alloc] init];
        
        if([currentParentElementName isEqualToString:@"ActionSequence"]) {
            [[[[[[[tutorialData objectForKey:@"Storyboard"] lastObject] objectForKey:@"Actions"] lastObject] objectForKey:@"ActionSequence"] lastObject] setObject:listOnPoint forKey:@"ListOnPoint"];
        } else {
            [[[[[tutorialData objectForKey:@"Storyboard"] lastObject] objectForKey:@"Actions"] lastObject] setObject:listOnPoint forKey:@"ListOnPoint"];
        }
        
    } else if([elementName isEqualToString:@"OnPoint"]) { //List point for onPointMoving

        if([currentParentElementName isEqualToString:@"ActionSequence"]) {
            [[[[[[[[tutorialData objectForKey:@"Storyboard"] lastObject] objectForKey:@"Actions"] lastObject] objectForKey:@"ActionSequence"] lastObject] objectForKey:@"ListOnPoint"] addObject:attributeDict];
        } else {
            [[[[[[tutorialData objectForKey:@"Storyboard"] lastObject] objectForKey:@"Actions"] lastObject] objectForKey:@"ListOnPoint"] addObject:attributeDict];
        }
    } else if([elementName isEqualToString:@"Frames"]) { //Animation List Frame's Names
        
        NSMutableArray *listAnimationFrames = [[NSMutableArray alloc] init];
        
        if([currentParentElementName isEqualToString:@"ActionSequence"]) {
            [[[[[[[tutorialData objectForKey:@"Storyboard"] lastObject] objectForKey:@"Actions"] lastObject] objectForKey:@"ActionSequence"] lastObject] setObject:listAnimationFrames forKey:@"Frames"];
        } else {
            [[[[[tutorialData objectForKey:@"Storyboard"] lastObject] objectForKey:@"Actions"] lastObject] setObject:listAnimationFrames forKey:@"Frames"];
        }
        
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string { 
	
	string = [string stringByReplacingOccurrencesOfString:@"\t" withString:@""];
	string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];	
	if(!currentElementValue) 
		currentElementValue = [[NSMutableString alloc] initWithString:string];
	else
		[currentElementValue appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if([elementName isEqualToString:@"Texture"]) {
        currentElementValue = [[NSMutableString alloc] initWithString:[currentElementValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        
        [[[tutorialData objectForKey:@"Resources"] objectForKey:@"TexturePlist"] addObject:currentElementValue];
    }else if([elementName isEqualToString:@"Frame"]) { //Frame's name
        
        currentElementValue = [[NSMutableString alloc] initWithString:[currentElementValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        
        if([currentParentElementName isEqualToString:@"ActionSequence"]) {
            
            [[[[[[[[tutorialData objectForKey:@"Storyboard"] lastObject] objectForKey:@"Actions"] lastObject] objectForKey:@"ActionSequence"] lastObject] objectForKey:@"Frames"] addObject:currentElementValue];
        } else {
            [[[[[[tutorialData objectForKey:@"Storyboard"] lastObject] objectForKey:@"Actions"] lastObject] objectForKey:@"Frames"] addObject:currentElementValue];
        }
    }
    
    [currentElementValue release];
    currentElementValue = nil;
}

@end
