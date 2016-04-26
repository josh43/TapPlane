//
//  CollidableDrawer.m
//  TapMyPlane
//
//  Created by joshua on 2/19/16.
//  Copyright © 2016 joshua. All rights reserved.
//

#import "CollidableDrawer.h"

@interface CollidableDrawer()

+(NSMutableArray *) getDrawables;


@end
BOOL linkedUpYet = NO;
int maxSprites = 25;
int lastUsedIndex = 0;
 NSMutableArray * skSpritePool;
@implementation CollidableDrawer

+(NSMutableArray *)getDrawables{
    if(skSpritePool == nil){
        skSpritePool = [[NSMutableArray alloc]init];
        for(int i = 0; i < maxSprites; i ++){

            SKSpriteNode * toAdd = [[SKSpriteNode alloc]initWithColor:[UIColor redColor] size:CGSizeMake(50,50)];
            toAdd.alpha = 0.2f;
            [skSpritePool addObject:toAdd];
            
        }
    }
    return skSpritePool;
}
+(BOOL) isLinked{
    return linkedUpYet;
}
+(void) linkSpriteNodesWith:(SKScene *)theScene{
    if(linkedUpYet == NO){
        NSMutableArray * spritePool = [CollidableDrawer getDrawables];
        if(!spritePool){
            NSLog(@"Error getting the sprite Pool  in Colllideable draw");
            return;
        }else{
            for(SKSpriteNode * toAdd in spritePool){
                [theScene addChild:toAdd];
            }
            linkedUpYet = YES;
        }
        // link up
    }else{
        NSLog(@"Error you have already linked the scene");
    }
    
}
+(void) unlinkSpriteNodesWith:(SKScene *)theScene{
    if(linkedUpYet == YES){
        NSMutableArray * spritePool = [CollidableDrawer getDrawables];
        if(!spritePool){
            NSLog(@"Error getting the sprite Pool  in Colllideable draw");
            return;
        }else{
            for(SKSpriteNode * toAdd in spritePool){
                [toAdd removeFromParent];
            }
            linkedUpYet = NO;
        }
        // link up
    }else{
        NSLog(@"Error you have already linked the scene");
    }

}
+(void)drawRectsPerFrame:(NSMutableArray *)usingThisList
                    with:(int)screenHeight{
    NSMutableArray * spriteNodes = [CollidableDrawer getDrawables];
    int mountainPosition = 0;
    int spriteNodePosition = lastUsedIndex;
    while( spriteNodePosition < maxSprites && mountainPosition < [usingThisList count]){
        SKSpriteNode * nodeToEdit = [spriteNodes objectAtIndex:spriteNodePosition];
        nodeToEdit.position = [[usingThisList objectAtIndex:mountainPosition] getMidPoint:screenHeight];
        CGRect sz = [[usingThisList objectAtIndex:mountainPosition]getRect];
        nodeToEdit.size = CGSizeMake(sz.size.width,sz.size.height);
        spriteNodePosition++;
        mountainPosition++;
        
    }
    
}
+(void)drawRectPerFrame:(Collideable *) usingThisCollidable
                   with:(int)screenHeight{
    if(lastUsedIndex < maxSprites){
        SKSpriteNode * spriteNodes = [[CollidableDrawer getDrawables]objectAtIndex:lastUsedIndex++];
        spriteNodes.position = [usingThisCollidable getMidPoint:screenHeight];
        CGRect size = [usingThisCollidable getRect];
        spriteNodes.size = CGSizeMake(size.size.width, size.size.height);
        
        if(linkedUpYet == NO){
            NSLog(@"Error link up first");
            return;
        }
        
    }else{
        NSLog(@"Error you are drawing more collideables than the max is allocated for!!");
    }
    
    
}
+(void) restartFrameDrawLocations{
    lastUsedIndex = 0;
}
@end
