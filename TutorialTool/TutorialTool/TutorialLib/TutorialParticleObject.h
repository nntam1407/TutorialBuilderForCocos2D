//
//  TutorialParticleObject.h
//  LibGame
//
//  Created by k3 on 9/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TutorialObject.h"
#import "TutorialParticleLib.h"

@interface TutorialParticleObject : TutorialObject {
    
}

-(id)initTutorialParticleObjectWith:(TutorialStoryboard *)_tutorialStorboardHandler withData:(NSMutableDictionary *)_objectData;
-(void)loadParticle;
-(CCParticleSystem *)getParticleWithName:(NSString*)_particleName;

-(CCParticleSystem *)particleCustomWithFileName:(NSString*)_particleFileName;
@end
