//
//  TutorialParticleLib.h
//  LibGame
//
//  Created by User on 9/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "TutorialLibDefine.h"

@interface TutorialParticleLib : NSObject

+(CCParticleSystem *)getParticleWithName:(NSString*)_particleName;
+(CCParticleSystem *)particleCustomWithFileName:(NSString*)_particleFileName;

@end
