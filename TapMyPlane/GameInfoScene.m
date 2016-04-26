//
//  GameInfoScene.m
//  TapMyPlane
//
//  Created by joshua on 2/16/16.
//  Copyright © 2016 joshua. All rights reserved.
//

#import "GameInfoScene.h"
@interface GameInfoScene()


@end
@implementation GameInfoScene

-(instancetype)init{
    self = [super init];
    
    _gameScoreNode = [SKLabelNode labelNodeWithText:@"Score : "];
    _distanceTraveledNode = [SKLabelNode labelNodeWithText:@"Distance Traveled : "];
    _numStarsCollectedNode = [SKLabelNode labelNodeWithText:@"Stats Collected : "];
    
    _gameScoreNode.fontSize = 24;
    _distanceTraveledNode.fontSize = 24;
    _numStarsCollectedNode.fontSize = 24;
    
    _distanceTraveledNode.position = CGPointMake(60, 350);
    _gameScoreNode.position = CGPointMake(60, 330);
    _numStarsCollectedNode.position = CGPointMake(60,300);
    
    _distanceTraveledNode.color = [SKColor blackColor];
    _gameScoreNode.color = [SKColor blueColor];
    _numStarsCollectedNode.color = [SKColor orangeColor];
    
    
    return self;
}




-(void)setNumStarsCollected:(int)numStarsCollected{
    _numStarsCollected = numStarsCollected;
    _numStarsCollectedNode.text = [NSString stringWithFormat:@"Score : %i",_numStarsCollected];
    
    
}
-(void)setDistanceTraveled:(int)distanceTraveled{
    _distanceTraveled = distanceTraveled;
    _distanceTraveledNode.text = [NSString stringWithFormat:@"Distance Traveled : %i",+distanceTraveled];
    
}
-(void)setGameScore:(int)gameScore{
    _gameScore = gameScore;
    _gameScoreNode.text = [NSString stringWithFormat:@"Score : %i",_gameScore];
    
}
@end
