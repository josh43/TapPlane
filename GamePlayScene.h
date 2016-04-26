//
//  TestScene.h
//  TapMyPlane
//
//  Created by joshua on 2/16/16.
//  Copyright © 2016 joshua. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Plane.h"
#import "MountainSystem.h"

@interface GamePlayScene : SKScene
@property(nonatomic,strong) SKSpriteNode * plane;

@property(nonatomic,strong) SKSpriteNode * background;
@property(nonatomic,strong) SKSpriteNode * backgroundNext;
@property(nonatomic,strong) SKSpriteNode * backgroundGrass;
@property(nonatomic,strong) SKSpriteNode * backgroundGrassNext;

@property(nonatomic,strong) SKSpriteNode * mountainUp;
@property(nonatomic,strong) SKSpriteNode * mountainDown;

@property(nonatomic,strong) Plane * modelPlane;
@property(nonatomic,strong) Collideable * groundFloor;
@property(nonatomic,strong) MountainSystem * mountSystem;
@property(nonatomic)BOOL debugMode;
-(void) screenFlash;
-(void) moveSkyBy:(int)speed;
-(void) moveAndUpdateMountains:(int)speed;
-(void) drawCollidables;
-(void) resetViews;
-(void) stopMountainSystem;
@end
