//
//  Plane.m
//  TapMyPlane
//
//  Created by joshua on 2/18/16.
//  Copyright © 2016 joshua. All rights reserved.
//

#import "Plane.h"

@implementation Plane
-(id)init:(CGRect)withRect{
    self = [super init:withRect];
    _velocity = -9.8;
    
    return self;
}
-(void)applyGravity:(float)dt
          withForce:(float)gravitationalForce{
    // max fall speed = 15 px
    const float maxSpeed = 15.0f;
    if(dt > .5)
        dt = .5;
    CGPoint newLoc = self.myLocation.origin;
    
    
    float newVel = _velocity + gravitationalForce *dt;
    if(newVel >=3){
        newVel =3;
    }
    if(newVel <= -maxSpeed){
        newVel = -maxSpeed;
        // this limits to -15 + dt * gravitation
    }
   
    
    newLoc.y += newVel;
    _velocity = newVel;
   
    if(newLoc.y < 0){
        newLoc.y = 0;
    }
    if(newLoc.y > 900){
        newLoc.y = 900;
    }
    self.myLocation = CGRectMake(newLoc.x, newLoc.y, self.myLocation.size.width, self.myLocation.size.height);
    

}
-(void)applyFoce:(float)theForce
          forTime:(float)dt{
    // i am going to change the force
    if(theForce <=0)
        return;
    if(dt <= 0)
        return;
    
    // take a little from it
    if(dt >= .5)
        dt = .5;
    [self applyGravity:dt withForce:theForce];

}
-(void)jump:(float)dt{
    // fall in the opposite direction!!
    [self applyGravity:dt withForce:1200];
}
@end
