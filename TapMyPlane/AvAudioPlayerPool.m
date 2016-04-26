//
//  AvAudioPlayerPool.m
//  TapMyPlane
//
//  Created by joshua on 2/19/16.
//  Copyright © 2016 joshua. All rights reserved.
//  This is actually from iOS game dev cookbook

#import "AvAudioPlayerPool.h"


NSMutableArray * mediaPlayers = nil;

@implementation AvAudioPlayerPool
// IF YOU DONT USE STRONG REFERENCE YOU WILL LOOSE THE AUDIO PLAYER

+(NSMutableArray * )players{
    if(mediaPlayers == nil){
        mediaPlayers = [[NSMutableArray alloc]init];
    }
    return mediaPlayers;
}

+(AVAudioPlayer *)playerWithUrl:(NSURL *)url{
    NSMutableArray* availablePlayers = [self players];
    [availablePlayers filterUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(AVAudioPlayer * evaluatedObject,NSDictionary * bindings) {
        return evaluatedObject.playing == NO && [evaluatedObject.url isEqual:url];
        
    }]];
    
    if(availablePlayers.count > 0){
        return [availablePlayers firstObject];
    }
    // else create one
    NSError * err = nil;
    AVAudioPlayer * newPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:&err];
    if(err != nil){
        NSLog(@"Error c reating a new audio player with url %@ : %@",url,err);
        return nil;
    }
    
    [[self players]addObject:newPlayer];
    return newPlayer;
    
    
}

+(void) stopPlayersWithUrl:(NSURL *)url{
    NSMutableArray* availablePlayers = [self players];
    [availablePlayers filterUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(AVAudioPlayer * evaluatedObject,NSDictionary * bindings) {
        return evaluatedObject.playing == YES && [evaluatedObject.url isEqual:url];
        
    }]];
    
    if(availablePlayers.count < 1){
        return;
    }
    for(AVAudioPlayer * player in availablePlayers){
        [player stop];

    }

    
    
}
@end
