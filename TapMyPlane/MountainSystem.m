//
//  MountainSystem.m
//  TapMyPlane
//
//  Created by joshua on 2/18/16.
//  Copyright © 2016 joshua. All rights reserved.
//

#import "MountainSystem.h"
#include <stdlib.h>
@import CoreGraphics;
@import UIKit;

@interface MountainSystem()
@property(nonatomic,strong) NSMutableArray * mountains;
@property(nonatomic)CGRect mountainDim;
@property(nonatomic)int minDist;
@property(nonatomic)int maxDist;
// why 14? why no 14022?
@property(nonatomic) int maxNumMountain;
@property(nonatomic) int heightDistance;
@property(nonatomic) int xOffset;
@end
@implementation MountainSystem

-(id) initWithMountainSize:(CGRect )mountainRect
andminDistanceBetweenMountains:(int)minDist
     andMaxDistanceBetween:(int)max
 andDistanceBetweenHeights:(int) heightDistance{
    self = [super init];
    _mountains = [[NSMutableArray alloc]init];
    _mountainDim = mountainRect;
    _minDist = minDist;
    _maxDist = max;
    _maxNumMountain  = 24;
    _heightDistance = heightDistance;
    [self setupMountains];

    return self;
}
-(void) setupMountains{
     _xOffset = 300;
    for(int i = 0; i < _maxNumMountain; i+=2){
        Collideable * top;
        Collideable * toAdd;
        int randX = _minDist + arc4random_uniform(_maxDist - _minDist);
        _xOffset += randX;

           // makeBottom^=1;
            int randBot = arc4random_uniform(150);
            // -100 to 100
            randBot -=250;
            toAdd =[[Collideable alloc]init:CGRectMake(_xOffset, randBot, _mountainDim.size.width, _mountainDim.size.height) ];

           //makeBottom^=1;
            int randtop = randBot + _mountainDim.size.height +arc4random_uniform(50) + _heightDistance;
            // 500 to 700
            randtop +=50;
            top =[[Collideable alloc]init:CGRectMake(_xOffset, randtop, _mountainDim.size.width, _mountainDim.size.height)];
            
  
        [_mountains addObject:toAdd];
        [_mountains addObject:top];
        //CGRect getIt = [[array objetAtIndex:0]CGRectValue]
    }
}
-(int)mountainSize{
    return [_mountains count];
}
-(CGRect)getRectAtIndex:(int)i{
    
    return [[_mountains objectAtIndex:i]getRect];
}
-(CGPoint)getMidPointAtIndex:(int) index
             andScreenHeight:(int) screenHeight{
    return [[_mountains objectAtIndex:index] getMidPoint:screenHeight];
    
    
}
/*
-(NSMutableArray *)mountains{
    //CGRect getIt = [[array objetAtIndex:0]CGRectValue]

   // return _mountains;
}
 */
-(NSMutableArray *) getMountainList{
    return self.mountains;
}
-(void)moveMountainsBy:(int)speed{
    for(int i = 0 ; i < [_mountains count];i++){
        // very doubtful this will work
        // i think theObj is not a reference rather a copy
        Collideable *  theObj =  [_mountains objectAtIndex:i];
        CGRect toChange = [theObj getRect];
        toChange.origin.x -=speed;
        
        theObj.myLocation = toChange;
      
                                  
        // This could have some bugs because of where the rectangles are and waat not
        if(theObj.myLocation.origin.x < -140){
            // im not going to every reposition thier heights .... :)))
            // dont change last offset because the screen really isnt moving
            int  diff =  _minDist + arc4random_uniform(_maxDist - _minDist);
            toChange.origin.x = _xOffset + diff;
            theObj.myLocation = toChange;
        }
        [_mountains replaceObjectAtIndex:i withObject:theObj];
        

        
        
    }
}
-(bool)didHitPlane:(Plane *)thePlane{
    if(!thePlane){
        return false;
    }
    for(int i = 0 ; i < [_mountains count];i++){
        // very doubtful this will work
        // i think theObj is not a reference rather a copy
        if([Collideable did:thePlane hit:[_mountains objectAtIndex:i]]){
            return true;
        }
        
        
        
    }
    
    return false;
}
@end
