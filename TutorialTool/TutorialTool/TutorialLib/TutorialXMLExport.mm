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
    NSDictionary *standardObjectDictionary = [_dictionaryData objectForKey:@"ListStandardObjects"];
    NSXMLElement *listStandardObjects = [self writeObjectsIntoNodeWithData:standardObjectDictionary];
    
    //create Resource Node in Tutorial XML using tutorial data
    NSDictionary *resourceDictionary = [_dictionaryData objectForKey:TUTORIAL_RESOURCES];
    NSXMLElement *listResources = [self writeResourcesIntoNodeWithData:resourceDictionary];
    
    //create Storyboard Node in Tutorial XML using tutorial data
    NSArray *storyboardArray = [_dictionaryData objectForKey:TUTORIAL_STORYBOARD];
    NSXMLElement *listStoryboard = [self writeStoryboardIntoNodeWithData:storyboardArray];
    
    //Add 3 nodes into the root "TutorialData"
    [root addChild:listStandardObjects];
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
        
//        [object addAttribute:[NSXMLNode attributeWithName:@"Name" stringValue:objectName]];
//                
//        NSString *objectType=[objectProperties objectForKey:TUTORIAL_OBJECT_TYPE_KEY];
//        
//        [object addAttribute:[NSXMLNode attributeWithName:TUTORIAL_OBJECT_TYPE_KEY stringValue:[objectProperties objectForKey:TUTORIAL_OBJECT_TYPE_KEY]]];
//        
//        if([objectType isEqualToString:TUTORIAL_OBJECT_TYPE_SPRITE]){
//            
//            NSArray *spriteAttributes=[self getSpritePropertiesAttributesFromData:objectProperties];
//            
//            for (NSXMLNode* attribute in spriteAttributes){
//                [object addAttribute:attribute];
//            }
//        } else if([objectType isEqualToString:TUTORIAL_OBJECT_TYPE_TEXT]){
//            
//            NSArray *textAttributes=[self getTextPropertiesAttributesFromData:objectProperties];
//            
//            for (NSXMLNode* attribute in textAttributes){
//                [object addAttribute:attribute];
//            }
//        } else if([objectType isEqualToString:TUTORIAL_OBJECT_TYPE_BUTTON]){
//            
//            NSArray *buttonAttributes=[self getButtonPropertiesAttributesFromData:objectProperties];
//            
//            for (NSXMLNode* attribute in buttonAttributes){
//                [object addAttribute:attribute];
//            }
//        } else if([objectType isEqualToString:TUTORIAL_OBJECT_TYPE_PARTICLE]){
//            
//            NSArray *particleAttributes=[self getParticlePropertiesAttributesFromData:objectProperties];
//            
//            for (NSXMLNode* attribute in particleAttributes){
//                [object addAttribute:attribute];
//            }
//        } 
        
        
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
//        [object addAttribute:[NSXMLNode attributeWithName:@"Name" stringValue:objectName]];
        
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
            NSXMLElement *sequenceNode = [self writeActionSequenceIntoNodeWithData:actionSequence];
            [action addChild:sequenceNode];
        }

        [listActions addChild:action];

    }

    return listActions;
}

+(NSXMLElement*)writeActionSequenceIntoNodeWithData:(NSArray*)_data{
    NSXMLElement *listActions = (NSXMLElement *)[NSXMLNode elementWithName:TUTORIAL_STORYBOARD_ACTION_SEQUENCE_ITEM_KEY];
    
    //Write attributes
    for(NSDictionary* actionAttribute in _data){
        
        NSXMLElement *action = (NSXMLElement *)[NSXMLNode elementWithName:TUTORIAL_STORYBOARD_ACTION_KEY]; 
        
        
        NSArray *attributes=[self getAllPropertiesAttributesFromData:actionAttribute];
        
        for (NSXMLNode* attribute in attributes){
            [action addAttribute:attribute];
        }
        
        [listActions addChild:action];
    }
    
    return listActions;
}

+(NSMutableArray*)getAllPropertiesAttributesFromData:(NSDictionary*)_data{
    
    NSMutableArray *attributesArray=[NSMutableArray array];
    
    NSArray *keyValues =
    [[_data allKeys]
     sortedArrayUsingSelector:
     @selector(caseInsensitiveCompare:)];
    
    for (NSString* keyValue in keyValues){
        NSLog(@"Key:%@", keyValue);
        if (![keyValue isEqualToString:TUTORIAL_ACTION_DATA_ACTION_SEQUENCE]){
            NSString *value =[_data objectForKey:keyValue];
            [attributesArray addObject:[NSXMLNode attributeWithName:keyValue stringValue:value]];
        }
    }
    return attributesArray;
}

+(NSMutableArray*)getPropertiesAttributesFromData:(NSDictionary*)_data{
    
    NSMutableArray *attributesArray=[NSMutableArray array];
    
    [attributesArray addObject:[NSXMLNode attributeWithName:TUTORIAL_OBJECT_TYPE_KEY stringValue:[_data objectForKey:TUTORIAL_OBJECT_TYPE_KEY]]];
    
    [attributesArray addObject:[NSXMLNode attributeWithName:TUTORIAL_OBJECT_PARAMETER_POS_X_KEY stringValue:[_data objectForKey:TUTORIAL_OBJECT_PARAMETER_POS_X_KEY]]];
    
    [attributesArray addObject:[NSXMLNode attributeWithName:TUTORIAL_OBJECT_PARAMETER_POS_Y_KEY stringValue:[_data objectForKey:TUTORIAL_OBJECT_PARAMETER_POS_Y_KEY]]];
    
    [attributesArray addObject:[NSXMLNode attributeWithName:TUTORIAL_OBJECT_PARAMETER_ANCHOR_POINT_X stringValue:[_data objectForKey:TUTORIAL_OBJECT_PARAMETER_ANCHOR_POINT_X]]];
    
    [attributesArray addObject:[NSXMLNode attributeWithName:TUTORIAL_OBJECT_PARAMETER_ANCHOR_POINT_Y stringValue:[_data objectForKey:TUTORIAL_OBJECT_PARAMETER_ANCHOR_POINT_Y]]];
    
    [attributesArray addObject:[NSXMLNode attributeWithName:TUTORIAL_OBJECT_PARAMETER_SCALE_X_KEY stringValue:[_data objectForKey:TUTORIAL_OBJECT_PARAMETER_SCALE_X_KEY]]];
    
    [attributesArray addObject:[NSXMLNode attributeWithName:TUTORIAL_OBJECT_PARAMETER_SCALE_Y_KEY stringValue:[_data objectForKey:TUTORIAL_OBJECT_PARAMETER_SCALE_Y_KEY]]];
    
    [attributesArray addObject:[NSXMLNode attributeWithName:TUTORIAL_OBJECT_PARAMETER_ROTATION_KEY stringValue:[_data objectForKey:TUTORIAL_OBJECT_PARAMETER_ROTATION_KEY]]];
    
    [attributesArray addObject:[NSXMLNode attributeWithName:TUTORIAL_OBJECT_PARAMETER_VISIBLE stringValue:[_data objectForKey:TUTORIAL_OBJECT_PARAMETER_VISIBLE]]];
    
    [attributesArray addObject:[NSXMLNode attributeWithName:TUTORIAL_OBJECT_PARAMETER_Z_INDEX stringValue:[_data objectForKey:TUTORIAL_OBJECT_PARAMETER_Z_INDEX]]];
    
    [attributesArray addObject:[NSXMLNode attributeWithName:TUTORIAL_OBJECT_PARAMETER_OPACITY stringValue:[_data objectForKey:TUTORIAL_OBJECT_PARAMETER_OPACITY]]];
    
    [attributesArray addObject:[NSXMLNode attributeWithName:TUTORIAL_OBJECT_PARAMETER_COLOR_R stringValue:[_data objectForKey:TUTORIAL_OBJECT_PARAMETER_COLOR_R]]];
    
    [attributesArray addObject:[NSXMLNode attributeWithName:TUTORIAL_OBJECT_PARAMETER_COLOR_G stringValue:[_data objectForKey:TUTORIAL_OBJECT_PARAMETER_COLOR_G]]];
    
    [attributesArray addObject:[NSXMLNode attributeWithName:TUTORIAL_OBJECT_PARAMETER_COLOR_B stringValue:[_data objectForKey:TUTORIAL_OBJECT_PARAMETER_COLOR_B]]];
    
    return attributesArray;
}

+(NSMutableArray*)getSpritePropertiesAttributesFromData:(NSDictionary*)_data{
    NSMutableArray* spriteAttributes = [NSMutableArray array];
    
    [spriteAttributes addObject:[NSXMLNode attributeWithName:TUTORIAL_OBJECT_SPRITE_FILE_NAME stringValue:[_data objectForKey:TUTORIAL_OBJECT_SPRITE_FILE_NAME]]];
    
    [spriteAttributes addObject:[NSXMLNode attributeWithName:TUTORIAL_OBJECT_SPRITE_FRAME_NAME stringValue:[_data objectForKey:TUTORIAL_OBJECT_SPRITE_FRAME_NAME]]];
    
    NSArray *commonProperties = [self getPropertiesAttributesFromData:_data];
    
    [spriteAttributes addObjectsFromArray:commonProperties];
    
    return spriteAttributes;
}

+(NSMutableArray*)getParticlePropertiesAttributesFromData:(NSDictionary*)_data{
    NSMutableArray* particleAttributes = [NSMutableArray array];
    
    [particleAttributes addObject:[NSXMLNode attributeWithName:TUTORIAL_OBJECT_PARTICLE_NAME stringValue:[_data objectForKey:TUTORIAL_OBJECT_PARTICLE_NAME]]];
    
    [particleAttributes addObject:[NSXMLNode attributeWithName:TUTORIAL_OBJECT_PARTICLE_CUSTOM_FILE_NAME stringValue:[_data objectForKey:TUTORIAL_OBJECT_PARTICLE_CUSTOM_FILE_NAME]]];
    
    NSArray *commonProperties = [self getPropertiesAttributesFromData:_data];
    
    [particleAttributes addObjectsFromArray:commonProperties];
    
    return particleAttributes;
}

+(NSMutableArray*)getTextPropertiesAttributesFromData:(NSDictionary*)_data{
    NSMutableArray* textAttributes = [NSMutableArray array];
    
    [textAttributes addObject:[NSXMLNode attributeWithName:TUTORIAL_OBJECT_PARAMETER_FONT_NAME stringValue:[_data objectForKey:TUTORIAL_OBJECT_PARAMETER_FONT_NAME]]];
    
    [textAttributes addObject:[NSXMLNode attributeWithName:TUTORIAL_OBJECT_PARAMETER_FONT_SIZE stringValue:[_data objectForKey:TUTORIAL_OBJECT_PARAMETER_FONT_SIZE]]];
    
    [textAttributes addObject:[NSXMLNode attributeWithName:TUTORIAL_OBJECT_PARAMETER_WIDTH_KEY stringValue:[_data objectForKey:TUTORIAL_OBJECT_PARAMETER_WIDTH_KEY]]];
    
    [textAttributes addObject:[NSXMLNode attributeWithName:TUTORIAL_OBJECT_PARAMETER_HEIGHT_KEY stringValue:[_data objectForKey:TUTORIAL_OBJECT_PARAMETER_HEIGHT_KEY]]];
    
    NSArray *commonProperties = [self getPropertiesAttributesFromData:_data];
    
    [textAttributes addObjectsFromArray:commonProperties];
    
    return textAttributes;
}

+(NSMutableArray*)getButtonPropertiesAttributesFromData:(NSDictionary*)_data{
    NSMutableArray* buttonAttributes = [NSMutableArray array];
    
    [buttonAttributes addObject:[NSXMLNode attributeWithName:TUTORIAL_OBJECT_BUTTON_NORMAL_SPRITE_FILE_NAME stringValue:[_data objectForKey:TUTORIAL_OBJECT_BUTTON_NORMAL_SPRITE_FILE_NAME]]];
    
    [buttonAttributes addObject:[NSXMLNode attributeWithName:TUTORIAL_OBJECT_BUTTON_ACTIVE_SPRITE_FILE_NAME stringValue:[_data objectForKey:TUTORIAL_OBJECT_BUTTON_ACTIVE_SPRITE_FILE_NAME]]];
    
    NSArray *commonProperties = [self getPropertiesAttributesFromData:_data];
    
    [buttonAttributes addObjectsFromArray:commonProperties];
    
    return buttonAttributes;
}

@end
