//
//  MountainSystem.h
//  TapMyPlane
//
//  Created by joshua on 2/18/16.
//  Copyright © 2016 joshua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Collideable.h"
#import "Plane.h"


@interface MountainSystem : NSObject
-(id) initWithMountainSize:(CGRect )mountainRect
                       andminDistanceBetweenMountains:(int)minDist
                        andMaxDistanceBetween:(int)max
                    andDistanceBetweenHeights:(int) heightDistance;

-(id) init __attribute__((unavailable("dont use init homie")));
-(void) moveMountainsBy:(int)speed;
-(bool) didHitPlane:(Plane *)thePlane;
-(CGRect)getRectAtIndex:(int)i;
-(NSMutableArray *) getMountainList;
-(int) mountainSize;
@end
