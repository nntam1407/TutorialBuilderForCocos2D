//
//  TutorialXMLExport.h
//  TutorialTool
//
//  Created by k3 on 9/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TutorialXMLExport : NSObject{
    
}
+(void)exportData:(NSDictionary*)_dictionaryData toFile:(NSString*)_fileName;

+(NSXMLElement*)writeObjectsIntoNodeWithData:(NSDictionary*)_data;

+(NSXMLElement*)writeResourcesIntoNodeWithData:(NSDictionary*)_data;

+(NSXMLElement*)writeStoryboardIntoNodeWithData:(NSArray*)_data;

+(NSXMLElement*)writeStoryIntoNodeWithData:(NSDictionary*)_data;

+(NSXMLElement*)writeListPlistIntoNodeWithData:(NSArray*)_data;

+(NSXMLElement*)writeObjectsInStoryboardIntoNodeWithData:(NSDictionary*)_data;

+(NSXMLElement*)writeActionsIntoNodeWithData:(NSArray*)_data;

+(NSXMLElement*)writeActionSequenceIntoNodeWithData:(NSArray*)_data;
+(NSXMLElement*)writeListPointsIntoNodeWithData:(NSArray*)_data;

+(NSXMLElement*)writeListAnimationFramesIntoNodeWithData:(NSArray*)_data;

+(NSMutableArray*)getAllPropertiesAttributesFromData:(NSDictionary*)_data;

@end
