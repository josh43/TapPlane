//
//  SettingsViewController.h
//  TapMyPlane
//
//  Created by joshua on 2/26/16.
//  Copyright © 2016 joshua. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface SimpleGameObject :NSObject

@property(nonatomic) BOOL showCollisions;
@property(nonatomic) float  gravity;


-(id)initWithCoder:(NSCoder *)decoder;
-(void)encodeWithCoder:(NSCoder *) encoder;
-(void)setGravity:(float) grav
andShowCollisions:(BOOL) collision;

@end;

@interface SettingsViewController : UIViewController

  @property(nonatomic,strong)  SimpleGameObject * myObject;

-(void) basicWriteToFile:(const char *) file withGravity:(float)grav andDebuggingMode:(BOOL) debug;
-(void) basicReadFromFile:(const char *) file withObject:(SimpleGameObject * )obj;

@end