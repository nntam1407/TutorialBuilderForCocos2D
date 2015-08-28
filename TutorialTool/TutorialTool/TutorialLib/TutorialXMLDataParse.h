//
//  TutorialXMLDataParse.h
//  LibGame
//
//  Created by User on 9/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TutorialLibDefine.h"

@interface TutorialXMLDataParse : NSObject <NSXMLParserDelegate> {
    NSMutableString *currentElementValue;
    NSMutableDictionary *tutorialData;
    
    NSString *currentParentElementName;
}

-(id)initTutorialXMLDataParse;

-(NSMutableDictionary *)getTutorialLibDataWithXmlFile:(NSString *)_fileName;
-(NSMutableDictionary *)getTutorialLibDataWithXmlFilePathAbsolute:(NSString *)_fileName;

@end
