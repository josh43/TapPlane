//
//  GameViewController.h
//  TapMyPlane
//
//  Created by joshua on 2/10/16.
//  Copyright © 2016 joshua. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface GameViewController : UIViewController

@property(atomic) double delta;
@property(nonatomic) float jumpForceTime;
@property BOOL debugMode;
@property float setGravity;
-(void) doMethodWith:
(   NSString *)thisString;
-(void) update:(CADisplayLink *) displayLink;
-(void) handleTouch:(CGPoint)point;

@end
