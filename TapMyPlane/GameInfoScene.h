//
//  GameInfoScene.h
//  TapMyPlane
//
//  Created by joshua on 2/16/16.
//  Copyright © 2016 joshua. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GameInfoScene : NSObject
@property(nonatomic) int gameScore;
@property(nonatomic) int distanceTraveled;
@property(nonatomic) int numStarsCollected;

@property(nonatomic,strong) SKLabelNode * gameScoreNode;
@property(nonatomic,strong) SKLabelNode * distanceTraveledNode;
@property(nonatomic,strong) SKLabelNode * numStarsCollectedNode;


-(void) setGameScore:(int)gameScore;
-(void)setDistanceTraveled:(int)distanceTraveled;
-(void)setNumStarsCollected:(int)numStarsCollected;
@end
