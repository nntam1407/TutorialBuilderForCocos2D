//
//  Helpers.h
//  LibGame
//
//  Created by Truong NAM on 8/29/12.
//
//

#define PTM_RATIO 32
#include "cocos2d.h"

@interface Helpers : NSObject{
    
}

+(float)vectorToRadians:(CGPoint)vector;
+(CGPoint)radiansToVector:(float)radians;
+(float)radiansToDegrees:(float)r;
+(float)degreesToRadians:(float)d;
+(CGPoint)roundPoint:(CGPoint)_point;
+(BOOL)isPoint:(CGPoint)_point inCircleWithCenter:(CGPoint)_center andRadius:(float)_radius;
+(float) angleDifferenceBetween:(float)_angleA and:(float)_angleB;
+(BOOL)isPoint:(CGPoint)_point inSpriteRect:(CCSprite *)_sprite;
+ (float) findRadiansBetweenPoint: (CGPoint)point1 andPoint: (CGPoint)point2;
+(BOOL)isPoint:(NSPoint)_point inRect:(NSRect)rect;
+(BOOL)isPoint:(NSPoint)_point insideNode:(CCNode *)_node;

@end
