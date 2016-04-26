//
//  Collideable.m
//  TapMyPlane
//
//  Created by joshua on 2/18/16.
//  Copyright © 2016 joshua. All rights reserved.
//

#import "Collideable.h"

@implementation Collideable
-(id)init{
    self = [self init:CGRectMake(0, 0, 0, 0)];
    return self;
}
-(id)init:(CGRect)withRect{
    self = [super init];
    _myLocation = withRect;
    return self;
}
-(CGRect) getRect{
    return _myLocation;
}
-(CGPoint)getMidPoint:(int) forScreenHeight{
    // Convert the coordinated
    CGPoint toReturn = CGPointMake(_myLocation.origin.x+_myLocation.size.width/2,_myLocation.origin.y+_myLocation.size.height/2);
    return toReturn;
}


#pragma mark - STATIC Methods
+(BOOL)did:(Collideable *)thisObject hit:(Collideable *)thatObject{
    int thisX = thisObject.myLocation.origin.x;
    int thisY = thisObject.myLocation.origin.y;
    int thisWidth = thisObject.myLocation.size.width;
    int thisHeight = thisObject.myLocation.size.height;
    
    int thatX = thatObject.myLocation.origin.x;
    int thatY = thatObject.myLocation.origin.y;
    int thatWidth = thatObject.myLocation.size.width;
    int thatHeight = thatObject.myLocation.size.height;
    
    /*NSLog(@"You need to fix this function for collision\n thisObject is at (%i,%i",thisX,thisY);
    NSLog(@"thisObject  Location : (%i,%i) Dim : (%i,%i) ",thisX,thisY,thisWidth,thisHeight);
    NSLog(@"That object Location : (%i,%i) Dim : (%i,%i) ",thatX,thatY,thatWidth,thatHeight);
    */
    if(thisObject.myLocation.origin.x+ thisWidth < thatX ){
        return false;
    }
    if(thisY+ thisHeight < thatY){
        return false;
    }
    if(thatY + thatHeight < thisY){
        return false;
    }
    if(thatX + thatWidth < thisX){
        return false;
    }
    
    return true;
}
@end
