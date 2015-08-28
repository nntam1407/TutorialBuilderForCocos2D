//
//  Helpers.m
//  LibGame
//
//  Created by Truong NAM on 8/29/12.
//
//

#import "Helpers.h"

@implementation Helpers


+(float)vectorToRadians:(CGPoint)vector{
	if(vector.y == 0){ vector.y = 0.000001f; }
	float baseRadians = atan(vector.x/vector.y);
	if(vector.y < 0){ baseRadians += M_PI; }	//Adjust for -Y
	return baseRadians;
}

+(CGPoint)radiansToVector:(float)radians{
	return ccp(sin(radians - M_PI/2), cos(radians - M_PI/2));
}

+(float)radiansToDegrees:(float)r{
	return r * (180/M_PI);
}

+(float)degreesToRadians:(float)d{
	return d * (M_PI/180);
}

+(CGPoint)roundPoint:(CGPoint)_point{
    return CGPointMake(roundf(_point.x),roundf(_point.y));
}

+(BOOL)isPoint:(CGPoint)_point inCircleWithCenter:(CGPoint)_center andRadius:(float)_radius{
	BOOL isInCircle = false;
	if(ccpDistance(_point, _center) <= _radius){
		isInCircle = true;
	}
	return isInCircle;
}

+(float) angleDifferenceBetween:(float)_angleA and:(float)_angleB{
	float diff = fabs(_angleA-_angleB);
	if(fabs((_angleA+360)-_angleB) < diff){
		diff = fabs((_angleA+360)-_angleB);
	}
	if(fabs((_angleA-360)-_angleB) < diff){
		diff = fabs((_angleA-360)-_angleB);
	}
	if(fabs(_angleA-(_angleB+360)) < diff){
		diff = fabs(_angleA-(_angleB+360));
	}
	if(fabs(_angleA-(_angleB-360)) < diff){
		diff = fabs(_angleA-(_angleB-360));
	}
	return diff;
}

+(BOOL)isPoint:(CGPoint)_point inSpriteRect:(CCSprite *)_sprite{
    float scaleMod = 1.0f;
	float w = _sprite.contentSize.width * _sprite.scale * scaleMod;
	float h = _sprite.contentSize.height * _sprite.scale * scaleMod;
	CGPoint point = CGPointMake(_sprite.position.x - (w/2), _sprite.position.y - (h/2));
	
	CGRect rect = CGRectMake(point.x, point.y, w, h); 
    
    if( _point.x < rect.origin.x + rect.size.width && 
	   _point.x > rect.origin.x &&
	   _point.y < rect.origin.y + rect.size.height &&
	   _point.y > rect.origin.y ){
        return YES;
    }
    return NO;
}

+ (float) findRadiansBetweenPoint: (CGPoint)point1 andPoint: (CGPoint)point2{
    if (point1.x == point2.x)
    {
        if (point1.y <= point2.y)
            return 0;
        // greater than
        return 180;
    }
    if (point1.x < point2.x)
    {
        if (point1.y == point2.y) 
            return 90;
        
        if (point1.y < point2.y)
            return [self radiansToDegrees:
                    atanf((point2.x - point1.x) / (point2.y - point1.y))];
        // greater than
        return [self radiansToDegrees:
                atanf((point1.y - point2.y) / (point2.x - point1.x))] + 90;
    }
    // greater than
    if (point1.y == point2.y)
        return 270;
    if (point1.y < point2.y)
        return [self radiansToDegrees:
                atanf((point2.y - point1.y) / (point1.x - point2.x))] + 270;
    //greater than
    return [self radiansToDegrees:
            atanf((point1.x - point2.x) / (point1.y - point2.y))] + 180;
}

+(BOOL)isPoint:(NSPoint)_point inRect:(NSRect)rect{
    
    if( _point.x < rect.origin.x + rect.size.width && 
	   _point.x > rect.origin.x &&
	   _point.y < rect.origin.y + rect.size.height &&
	   _point.y > rect.origin.y ){
        return YES;
    }
    return NO;
}

+(BOOL)isPoint:(NSPoint)_point insideNode:(CCNode *)_node {
    float rotateRadian = [Helpers degreesToRadians:_node.rotation];
    float c = cosf(- rotateRadian);
    float s = sinf(- rotateRadian);
    
    // UNrotate the point depending on the rotation of the rectangle
    float rotatedX = _node.position.x + c * (_point.x - _node.position.x) - s * (_point.y - _node.position.y);
    float rotatedY = _node.position.y + s * (_point.x - _node.position.x) + c * (_point.y - _node.position.y);
    
    //perform a normal check if the new point is inside the
    //bounds of the UNrotated rectangle
    float leftX = _node.position.x - _node.contentSize.width * _node.anchorPoint.x * _node.scaleX;
    
    float rightX = _node.position.x + (_node.contentSize.width - _node.contentSize.width * _node.anchorPoint.x) * _node.scaleX;
    
    float topY = _node.position.y + (_node.contentSize.height - _node.contentSize.height * _node.anchorPoint.y) * _node.scaleY;
    
    float bottomY = _node.position.y - _node.contentSize.height * _node.anchorPoint.y * _node.scaleY;
    
    if(leftX <= rotatedX && rotatedX <= rightX && bottomY <= rotatedY && rotatedY <= topY) {
        return true;
    } else {
        return false;
    }
}

@end
