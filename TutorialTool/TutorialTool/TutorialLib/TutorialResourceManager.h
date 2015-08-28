//
//  TutorialResourceManager.h
//  LibGame
//
//  Created by User on 9/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TutorialResourceManager : NSObject

+(void)loadTextureFromFile:(NSString *)_textureFileName;
+(void)loadTextureFromArrayFile:(NSMutableArray *)_listTextureFileName;

+(void)removeTextureFromFile:(NSString *)_textureFileName;
+(void)removeTextureFromArrayFile:(NSMutableArray *)_listTextureFileName;

+(void)loadTextureFromImageFile:(NSString *)_imageFileName;
+(void)loadTextureFromListImageFiles:(NSMutableArray *)_listImageFile;

@end
