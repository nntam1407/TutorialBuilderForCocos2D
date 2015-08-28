//
//  TutorialXMLExport.m
//  TutorialTool
//
//  Created by k3 on 9/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TutorialXMLExport.h"
#import "TutorialLibDefine.h"
@implementation TutorialXMLExport


//  Export tutorial data into XML file
+(void)exportData:(NSDictionary*)_dictionaryData toFile:(NSString*)_fileName{
    
    //Create a root with the name "TutorialData"
    NSXMLElement *root = (NSXMLElement *)[NSXMLNode elementWithName:@"TutorialData"];
    
    //create StandardObject Node in Tutorial XML using tutorial data
    //NSDictionary *standardObjectDictionary = [_dictionaryData objectForKey:@"ListStandardObjects"];
    
    //NSXMLElement *listStandardObjects = [self writeObjectsIntoNodeWithData:standardObjectDictionary];
    
    //create Resource Node in Tutorial XML using tutorial data
    NSDictionary *resourceDictionary = [_dictionaryData objectForKey:TUTORIAL_RESOURCES];
    NSXMLElement *listResources = [self writeResourcesIntoNodeWithData:resourceDictionary];
    
    //create Storyboard Node in Tutorial XML using tutorial data
    NSArray *storyboardArray = [_dictionaryData objectForKey:TUTORIAL_STORYBOARD];
    NSXMLElement *listStoryboard = [self writeStoryboardIntoNodeWithData:storyboardArray];
    
    //Add 3 nodes into the root "TutorialData"
    //[root addChild:listStandardObjects];
    [root addChild:listResources];
    [root addChild:listStoryboard];
    
    //Create XML file (overwrite file if existed)
    NSXMLDocument *xmlDoc = [[NSXMLDocument alloc] initWithRootElement:root];
    NSData *data = [xmlDoc XMLDataWithOptions:NSXMLNodePrettyPrint];
    [data writeToFile:_fileName atomically:YES];
}

+(NSXMLElement*)writeObjectsIntoNodeWithData:(NSDictionary*)_data{
    
    //get list key from Dictionary Data
    NSArray *objectKeyArray=[_data allKeys];
    
    NSXMLElement *listStandardObjects = (NSXMLElement *)[NSXMLNode elementWithName:@"ListStandardObjects"];
    
    //Write attributes
    for(NSString* objectName in objectKeyArray){
        NSXMLElement *object = (NSXMLElement *)[NSXMLNode elementWithName:TUTORIAL_ACTION_DATA_KEY_OBJECT_NAME];
        
        NSDictionary *objectProperties=[_data objectForKey:objectName];
        
        NSArray *attributes=[self getAllPropertiesAttributesFromData:objectProperties];
        
        for (NSXMLNode* attribute in attributes){
            [object addAttribute:attribute];
        }
    
        [listStandardObjects addChild:object];
    }

    return listStandardObjects;
}

+(NSXMLElement*)writeResourcesIntoNodeWithData:(NSDictionary*)_data{
    NSXMLElement *listResources = (NSXMLElement *)[NSXMLNode elementWithName:TUTORIAL_RESOURCES];
    
    NSArray *plistResource = [_data objectForKey:TUTORIAL_RESOURCES_LIST_TEXTURE_PLIST];
    
    NSXMLElement* plistNode = [self writeListPlistIntoNodeWithData:plistResource];
    
    [listResources addChild:plistNode];
    return listResources;
}


+(NSXMLElement*)writeListPlistIntoNodeWithData:(NSArray*)_data{
    NSXMLElement *listPlist = (NSXMLElement *)[NSXMLNode elementWithName:TUTORIAL_RESOURCES_LIST_TEXTURE_PLIST];
    for (NSString* plistFilePath in _data){
        NSXMLElement* texturePath = (NSXMLElement*)[NSXMLNode elementWithName:TUTORIAL_RESOURCES_TEXTURE_FILE_PATH];
        [texturePath setStringValue:plistFilePath];
        [listPlist addChild:texturePath];
    }
    
    return listPlist;
}


+(NSXMLElement*)writeStoryboardIntoNodeWithData:(NSArray*)_data{
    NSXMLElement *storyboard = (NSXMLElement *)[NSXMLNode elementWithName:TUTORIAL_STORYBOARD];
    
    for (NSDictionary *storyDictionary in _data){
        NSXMLElement *story = [self writeStoryIntoNodeWithData:storyDictionary];
        [storyboard addChild:story];
    }
    
    return storyboard;
}

+(NSXMLElement*)writeStoryIntoNodeWithData:(NSDictionary*)_data{
    NSXMLElement *listStory = (NSXMLElement *)[NSXMLNode elementWithName:TUTORIAL_STORYBOARD_STORY_KEY];
    
    NSDictionary *listObjectsDictionary=[_data objectForKey:TUTORIAL_STORYBOARD_OBJECTS_KEY];
    
    NSXMLElement *listObjects=[self writeObjectsInStoryboardIntoNodeWithData:listObjectsDictionary];
    
    [listStory addChild:listObjects];
    
    NSArray *listActionsArray=[_data objectForKey:TUTORIAL_STORYBOARD_ACTIONS_KEY];
    
    NSXMLElement *listActions=[self writeActionsIntoNodeWithData:listActionsArray];
    
    [listStory addChild:listActions];
    
    return listStory;
}

+(NSXMLElement*)writeObjectsInStoryboardIntoNodeWithData:(NSDictionary*)_data{
    
    NSXMLElement *listObjects = (NSXMLElement *)[NSXMLNode elementWithName:TUTORIAL_STORYBOARD_OBJECTS_KEY];
    
    NSArray *objectKeyArray=[_data allKeys];

    for(NSString* objectName in objectKeyArray){
        NSXMLElement *object = (NSXMLElement *)[NSXMLNode elementWithName:TUTORIAL_ACTION_DATA_KEY_OBJECT_NAME];        
        
        NSDictionary *objectProperties=[_data objectForKey:objectName];
        
        NSArray *attributes=[self getAllPropertiesAttributesFromData:objectProperties];
        
        for (NSXMLNode* attribute in attributes){
            [object addAttribute:attribute];
        }
        
        
        [listObjects addChild:object];
    }
    
    return listObjects;
}

+(NSXMLElement*)writeActionsIntoNodeWithData:(NSArray*)_data{
    NSXMLElement *listActions = (NSXMLElement *)[NSXMLNode elementWithName:TUTORIAL_STORYBOARD_ACTIONS_KEY];
        
    //Write attributes
    for(NSDictionary* actionAttribute in _data){
        
        NSXMLElement *action = (NSXMLElement *)[NSXMLNode elementWithName:TUTORIAL_STORYBOARD_ACTION_KEY]; 
        
        
        NSArray *attributes=[self getAllPropertiesAttributesFromData:actionAttribute];
        
        for (NSXMLNode* attribute in attributes){
            [action addAttribute:attribute];
        }
                
        NSArray *actionSequence = [actionAttribute objectForKey:TUTORIAL_ACTION_DATA_ACTION_SEQUENCE];
        if (actionSequence){
            NSDictionary* actionItemAttribute = [actionSequence objectAtIndex:0];
//            NSXMLElement *sequenceNode = [self writeActionSequenceIntoNodeWithData:actionSequence];
//            [action addChild:sequenceNode];
            
            NSArray *itemAttributes=[self getAllPropertiesAttributesFromData:actionItemAttribute];
            
            for (NSXMLNode* attribute in itemAttributes){
                [action addAttribute:attribute];
            }
            
            NSArray *listPoints = [actionItemAttribute objectForKey:TUTORIAL_ACTION_ON_POINT_MOVING_LIST_POINT];
            
            if (listPoints){
                NSXMLElement *listPointNode = [self writeListPointsIntoNodeWithData:listPoints];
                [action addChild:listPointNode];
            }
            
            NSArray *listAnimations = [actionItemAttribute objectForKey:TUTORIAL_ACTION_LIST_ANIMATION_FRAMES];
            
            if (listAnimations){
                NSXMLElement *listAnimationNode = [self writeListAnimationFramesIntoNodeWithData:listAnimations];
                [action addChild:listAnimationNode];
            }
            
            [listActions addChild:action];
            
        }
        
//        NSArray *listPoints = [actionAttribute objectForKey:TUTORIAL_ACTION_ON_POINT_MOVING_LIST_POINT];
//        
//        if (listPoints){
//            NSXMLElement *listPointNode = [self writeListPointsIntoNodeWithData:listPoints];
//            [action addChild:listPointNode];
//        }
//        
//        NSArray *listAnimations = [actionAttribute objectForKey:TUTORIAL_ACTION_LIST_ANIMATION_FRAMES];
//        
//        if (listAnimations){
//            NSXMLElement *listAnimationNode = [self writeListAnimationFramesIntoNodeWithData:listAnimations];
//            [action addChild:listAnimationNode];
//        }
//
//        [listActions addChild:action];

    }

    return listActions;
}

+(NSXMLElement*)writeActionSequenceIntoNodeWithData:(NSArray*)_data{
    NSXMLElement *listActions = (NSXMLElement *)[NSXMLNode elementWithName:TUTORIAL_ACTION_DATA_ACTION_SEQUENCE];
    
    //Write attributes
    for(NSDictionary* actionAttribute in _data){
        
        NSXMLElement *action = (NSXMLElement *)[NSXMLNode elementWithName:TUTORIAL_STORYBOARD_ACTION_SEQUENCE_ITEM_KEY]; 
        
        
        NSArray *attributes=[self getAllPropertiesAttributesFromData:actionAttribute];
        
        for (NSXMLNode* attribute in attributes){
            [action addAttribute:attribute];
        }
        
        NSArray *listPoints = [actionAttribute objectForKey:TUTORIAL_ACTION_ON_POINT_MOVING_LIST_POINT];
        
        if (listPoints){
            NSXMLElement *listPointNode = [self writeListPointsIntoNodeWithData:listPoints];
            [action addChild:listPointNode];
        }
        
        NSArray *listAnimations = [actionAttribute objectForKey:TUTORIAL_ACTION_LIST_ANIMATION_FRAMES];
        
        if (listAnimations){
            NSXMLElement *listAnimationNode = [self writeListAnimationFramesIntoNodeWithData:listAnimations];
            [action addChild:listAnimationNode];
        }
        
        [listActions addChild:action];
    }
    
    return listActions;
}

+(NSXMLElement*)writeListPointsIntoNodeWithData:(NSArray*)_data{
    NSXMLElement *listPoints = (NSXMLElement *)[NSXMLNode elementWithName:TUTORIAL_ACTION_ON_POINT_MOVING_LIST_POINT];
    
    //Write attributes
    for(NSDictionary* pointAttribute in _data){
        
        NSXMLElement *point = (NSXMLElement *)[NSXMLNode elementWithName:TUTORIAL_ACTION_ON_POINT_MOVING_LIST_POINT_MEMBER]; 
        
        NSArray *attributes=[self getAllPropertiesAttributesFromData:pointAttribute];
        
        for (NSXMLNode* attribute in attributes){
            [point addAttribute:attribute];
        }
        
        [listPoints addChild:point];
    }
    
    return listPoints;
}

+(NSXMLElement*)writeListAnimationFramesIntoNodeWithData:(NSArray*)_data{
    NSXMLElement *listAnimation = (NSXMLElement *)[NSXMLNode elementWithName:TUTORIAL_ACTION_LIST_ANIMATION_FRAMES];
    
    //Write attributes
    for(NSString* frameName in _data){
        
        NSXMLElement *frame = (NSXMLElement *)[NSXMLNode elementWithName:TUTORIAL_ACTION_LIST_ANIMATION_FRAMES_MEMBER]; 
        
        [frame setStringValue:frameName];
        
        [listAnimation addChild:frame];
    }
    
    return listAnimation;
}

+(NSMutableArray*)getAllPropertiesAttributesFromData:(NSDictionary*)_data{
    
    NSMutableArray *attributesArray=[NSMutableArray array];
    
    NSArray *keyValues =
    [[_data allKeys]
     sortedArrayUsingSelector:
     @selector(caseInsensitiveCompare:)];
    
    for (NSString* keyValue in keyValues){
        //NSLog(@"Key:%@", keyValue);
        if (![keyValue isEqualToString:TUTORIAL_ACTION_DATA_ACTION_SEQUENCE] && 
            ![keyValue isEqualToString:TUTORIAL_ACTION_ON_POINT_MOVING_LIST_POINT] && ![keyValue isEqualToString:TUTORIAL_ACTION_LIST_ANIMATION_FRAMES]){
            NSString *value =[_data objectForKey:keyValue];
            [attributesArray addObject:[NSXMLNode attributeWithName:keyValue stringValue:value]];
        }
    }
    return attributesArray;
}

@end
