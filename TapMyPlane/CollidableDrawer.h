//
//  CollidableDrawer.h
//  TapMyPlane
//
//  Created by joshua on 2/19/16.
//  Copyright © 2016 joshua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "Collideable.h"

@interface CollidableDrawer : NSObject

+(void) linkSpriteNodesWith:(SKScene *)theScene;
+(void)drawRectPerFrame:(Collideable *) usingThisCollidable
                   with:(int)screenHeight;
+(void)drawRectsPerFrame:(NSMutableArray *) usingThisList
                   with:(int)screenHeight;
+(void) restartFrameDrawLocations;
+(void) unlinkSpriteNodesWith:(SKScene *)theScene;
+(BOOL) isLinked;

@end
