//
//  Plane.h
//  TapMyPlane
//
//  Created by joshua on 2/18/16.
//  Copyright © 2016 joshua. All rights reserved.
//

#import "Collideable.h"

@interface Plane : Collideable
@property(nonatomic)float velocity;
-(id)init:(CGRect)withRect;
-(void) applyGravity:(float)dt
           withForce:(float)gravitationalForce;
-(void) jump:(float)dt;
-(void)applyFoce:(float)theForce
          forTime:(float)dt;
@end
