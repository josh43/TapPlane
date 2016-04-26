//
//  Collideable.h
//  TapMyPlane
//
//  Created by joshua on 2/18/16.
//  Copyright © 2016 joshua. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreGraphics;

@interface Collideable : NSObject

@property(nonatomic) CGRect myLocation;
-(id)init;
-(id)init:(CGRect) withRect;
+(BOOL)did:(Collideable *) thisObject
       hit:(Collideable *) thatObject;
-(CGRect) getRect;
-(CGPoint) getMidPoint:(int) forScreenHeight;
@end
