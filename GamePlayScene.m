//
//  TestScene.m
//  TapMyPlane
//
//  Created by joshua on 2/16/16.
//  Copyright © 2016 joshua. All rights reserved.
//

#import "GamePlayScene.h"
#import "GameInfoScene.h"
#import "CollidableDrawer.h"


@interface GamePlayScene()
-(void) createSceneContents;
@property(nonatomic,strong) SKSpriteNode * node;
@property(nonatomic,strong) GameInfoScene * infoScene;

@property(nonatomic,strong) SKTextureAtlas * atlas;
@property(strong, nonatomic) NSMutableArray * planeArray;
@property(strong,nonatomic) NSMutableArray * mountainSprites;


@property BOOL contentCreated;
@property BOOL shouldDrawMountains;


@property BOOL lastMountainWasTop;

@end
@implementation GamePlayScene
int widthBetween = 200;
- (instancetype)init
{
    self = [super init];
    if (self) {
        NSLog(@"We good");
    }
    

    _modelPlane = [[Plane alloc]init:CGRectMake(150, 400, 80, 80)];
    return self;
}
/*
-(void)didMoveToView:(SKView *)view{
    if(!_contentCreated){
        [self createSceneContents];
        _contentCreated = YES;
    }
}
 */
-(instancetype)initWithSize:(CGSize)size{
    self = [super initWithSize:size];
    if(!self){
        NSLog(@"Error making the initWithSize call to the Gameplay scene");
    }
    if(!_contentCreated){
        [self createSceneContents];
        _contentCreated = YES;

    }
    _shouldDrawMountains = NO;
    _modelPlane = [[Plane alloc]init:CGRectMake(150, 400, 80, 80)];
    
    
    
    return self;
}
-(void) resetViews{
    _modelPlane = [[Plane alloc]init:CGRectMake(150, 400, 80, 80)];
    //[self genMountainImages];
    _shouldDrawMountains = YES;
    for(SKSpriteNode * mountain in _mountainSprites){
        [self addChild:mountain];
    }
    
}

-(void) stopMountainSystem{
    for(SKSpriteNode * mountain in _mountainSprites){
        [mountain removeFromParent];
    }
    //[CollidableDrawer restartFrameDrawLocations];
//    _mountainSprites = nil;
    _shouldDrawMountains = NO;
}

-(void)update:(CFTimeInterval)currentTime{
    
    [self moveSkyBy:3];
    [self moveAndUpdateMountains:3];
    if(_debugMode){
        [self drawCollidables];
    }

}
 
-(void)didMoveToView:(SKView *)view{
    if(self.contentCreated == NO)
    {
        [self createSceneContents];
        self.contentCreated = YES;
        self.lastMountainWasTop = YES;
            _shouldDrawMountains = YES;
        
    }
    

}
-(CGPoint) getRectBySubtracting:(CGPoint) this
                          from:(int)thisAmount{
    
    this.x -= thisAmount;
    return this;
}
-(void) moveAndUpdateMountains:(int)speed{
    [_mountSystem moveMountainsBy:speed];
    for(int i = 0; i < [_mountSystem mountainSize]; i++){
        CGRect this =[_mountSystem getRectAtIndex:i];
        CGPoint point = [[[_mountSystem getMountainList]objectAtIndex:i]getMidPoint:0];
        SKSpriteNode * setThisTo = [_mountainSprites objectAtIndex:i];
        setThisTo.position = point;
        
    }
    
}

-(void) moveSkyBy:(int)speed{
    int skySpeed = speed/4;
    if(skySpeed == 0)
        skySpeed = 1;
    CGPoint newPosition;
    newPosition = _background.position;
    newPosition.x -=skySpeed;
    
    _background.position = newPosition;
    if(_background.position.x <=  -_background.size.width/2 ){
        //add it to the back
        CGPoint newPoint;
        newPoint.x = (float)_background.frame.size.width * (float)3/(float)2;
        newPoint.y = _background.position.y;
        _background.position = newPoint;
    }
    newPosition = _backgroundNext.position;
    newPosition.x -= skySpeed;
    _backgroundNext.position = newPosition;
    if(_backgroundNext.position.x <= -_background.size.width/2 ){
        //add it to the back
        CGPoint newPoint;
        newPoint.x = (float)_backgroundNext.frame.size.width * (float)3/(float)2;
        newPoint.y = _backgroundNext.position.y;
        _backgroundNext.position = newPoint;
    }
    
    
    newPosition = _backgroundGrass.position;
    newPosition.x -= speed;
    _backgroundGrass.position = newPosition;
    if(_backgroundGrass.position.x <= -_backgroundGrass.frame.size.width/2){
        //add it to the back
        CGPoint newPoint;
        newPoint.x = _backgroundGrass.frame.size.width * 3/2;
        newPoint.y = _backgroundGrass.position.y;
        _backgroundGrass.position = newPoint;
    }
    newPosition = _backgroundGrassNext.position;
    newPosition.x -= speed;
    _backgroundGrassNext.position = newPosition;
    if(_backgroundGrassNext.position.x <= -_backgroundGrassNext.frame.size.width/2){
        //add it to the back
        CGPoint newPoint;
        newPoint.x = _backgroundGrassNext.frame.size.width * 3/2;
        newPoint.y = _backgroundGrassNext.position.y;
        _backgroundGrassNext.position = newPoint;
    }
    // do all calculations for moving zee sheet
    
    
    
    
}

// This is more like update locations than actually drawin
-(void) drawCollidables{
    // draw plane and mountains
  
        [CollidableDrawer drawRectPerFrame:_modelPlane with:self.view.bounds.size.height];

    // it would be much more efficient if I could just pass in a list
        [CollidableDrawer drawRectsPerFrame:[_mountSystem getMountainList] with:self.view.bounds.size.height];

    // dont forget
    [CollidableDrawer restartFrameDrawLocations];
    
}
-(void)createSceneContents{
    
    _atlas = [SKTextureAtlas atlasNamed:@"Planes"];
   _mountainSprites = [[NSMutableArray alloc]init];
    //_atlas = [SKTextureAtlas atlasNamed:@"dumb"];
    _planeArray = [[NSMutableArray alloc]init];
    NSArray * planeAnimations = [[_atlas textureNames]sortedArrayUsingSelector:@selector(compare:) ];
    
    for(NSString * texName in planeAnimations){
        [_planeArray addObject:[_atlas textureNamed:texName] ];
        
    }
    
    
   // self.backgroundColor = [SKColor blueColor];
    //elf.scaleMode = SKSceneScaleModeAspectFill;
    _infoScene = [[GameInfoScene alloc]init];
    _plane = [SKSpriteNode spriteNodeWithTexture:_planeArray[0]];
    _plane.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    
    _background = [[SKSpriteNode alloc]initWithImageNamed:@"sky_background"];
    int test = self.position.x;
    _background.position = CGPointMake(_background.size.width/2, self.size.height/2);
    
    _backgroundNext = [_background copy];
    _backgroundNext.position = CGPointMake( _background.size.width* 3/2, self.size.height/2);
    
    _backgroundGrass = [[SKSpriteNode alloc]initWithImageNamed:@"ground_grass"];
    _backgroundGrass.position = CGPointMake(_backgroundGrass.size.width/2,_backgroundGrass.size.height/4);
    
    _backgroundGrassNext = [_backgroundGrass copy];
    _backgroundGrassNext.position = CGPointMake(_backgroundGrass.size.width* 3/2,_backgroundGrass.size.height/4);
    
    
    _groundFloor = [[Collideable alloc]init:CGRectMake(0, 0, 1000, _backgroundGrass.size.height/2)];
    
    _mountainDown= [[SKSpriteNode alloc]initWithImageNamed:@"rock_grass_down"];
    _mountainDown.position = CGPointMake(600,400-_mountainDown.frame.size.height/2);
    
    
    
    _mountainUp = [[SKSpriteNode alloc]initWithImageNamed:@"rock_grass"];
    _mountainUp.position = CGPointMake(300,0);
    
  

  
    _mountSystem = [[MountainSystem alloc]initWithMountainSize:_mountainDown.frame andminDistanceBetweenMountains:300 andMaxDistanceBetween:400 andDistanceBetweenHeights:150];
    
    if(_plane == nil || _background == nil || _backgroundGrass == nil || _mountainUp == nil || _mountainDown == nil){
        NSLog(@"Error loading one of the images");
    }
    // Size of the sprite is based on the size of the image :::||
    [self addChild:_background];
    [self addChild:_backgroundNext];
    
    [self addChild:_backgroundGrass];
    [self addChild:_backgroundGrassNext];
    // ORDER MATTERS
    [self genMountainImages];

    
    
    [self addChild:[_infoScene gameScoreNode]];
    [self addChild:[_infoScene distanceTraveledNode]];
    [self addChild:[_infoScene numStarsCollectedNode]];
    
    [self addChild:_plane];
    
    // THE CollideableDrawer overtakes alll!!!!!!!!!!
    // basically create all the skspritenodes and add them as children
    // so if we want we can draw them to the screen later
    // we will use the mountain system to update teh locations brah
    [CollidableDrawer linkSpriteNodesWith:self];
    // This is the hook
    

  
    // do plane animation
    SKAction * planeAnimation = [SKAction animateWithTextures:_planeArray timePerFrame:2.0/30.0];
    [_plane runAction:[SKAction repeatActionForever:planeAnimation]];
    _contentCreated = YES;
    
    
}
-(void) genMountainImages{
    if(!_mountSystem){
        NSLog(@"Error please initailize the _mountSystem you freaking noob");
        
    }
    BOOL mountainUp = NO;
    //[self addChild:_mountainDown];
    for(int i = 0; i < [_mountSystem mountainSize];i++){
        SKSpriteNode * nodeToAdd;
        if(mountainUp){
            nodeToAdd = [_mountainDown copy];
            mountainUp ^=1;
        }else{
            nodeToAdd = [_mountainUp copy];
            mountainUp^=1;
        }
        CGPoint location = [_mountSystem getRectAtIndex:i].origin;


        nodeToAdd.position = location;
        [_mountainSprites addObject:nodeToAdd];
        
        [self addChild:nodeToAdd];
    }
}
@end
