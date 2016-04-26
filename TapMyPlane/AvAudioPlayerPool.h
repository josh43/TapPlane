//
//  AvAudioPlayerPool.h
//  TapMyPlane
//
//  Created by joshua on 2/19/16.
//  Copyright © 2016 joshua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface AvAudioPlayerPool : NSObject
+(AVAudioPlayer *) playerWithUrl:(NSURL *) url;
+(void) stopPlayersWithUrl:(NSURL *)url;
@end
