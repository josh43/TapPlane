//
//  SettingsViewController.m
//  TapMyPlane
//
//  Created by joshua on 2/26/16.
//  Copyright © 2016 joshua. All rights reserved.
//

#import "SettingsViewController.h"
#import "GameViewController.h"
#include <stdio.h>



@implementation SimpleGameObject


-(void)setGravity:(float)grav
        andShowCollisions:(BOOL)collision{
    _gravity = grav;
    _showCollisions = collision;
}



@end


@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *mySwitch;
@property (weak, nonatomic) IBOutlet UISlider *mySlider;

@end

@implementation SettingsViewController


// Needed to write data to be persistent
FILE * myFile;

// IB actions
- (IBAction)switchedButton:(id)sender {
    NSLog(@"Someone is toggling the collision buttone");
    _myObject.showCollisions ^=1;
    
}
- (IBAction)changedGravity:(id)sender {
    if([sender isKindOfClass:[UISlider class]]){
        _myObject.gravity = _mySlider.value;
        
        
    }
}

#pragma mark Transitions
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    GameViewController * gvc = (GameViewController *)segue.destinationViewController;
    gvc.debugMode = _myObject.showCollisions;
    gvc.setGravity = _myObject.gravity;
    
}
-(void)goToMainMenu{
    [self performSegueWithIdentifier:@"settingsToGame" sender:self];
    
}
#pragma mark I/O
-(void) basicWriteToFile:(const char *) file withGravity:(float)grav andDebuggingMode:(BOOL) debug{
    if(myFile){
        fclose(myFile);
    }
    
    myFile = fopen(file,"w");
    if(!myFile){
        NSLog(@"ERROR opening the file to write to :(");
        return;
    }
    // else write
    fprintf(myFile, "showCollisions %i\n",debug);
    fprintf(myFile, "gravity %f\n",grav);
    
    fclose(myFile);
            myFile = NULL;
}
-(void) basicReadFromFile:(const char *) file withObject:(SimpleGameObject * )obj{
    if(myFile){
        fclose(myFile);
        myFile = NULL;
    }
    
    myFile = fopen(file,"r");
    if(!myFile){
        NSLog(@"error reading file");
        return;
    }
    int coll = 0;
    float grav = 0.0f;
    fscanf(myFile, "showCollisions %i\n",&coll);
    fscanf(myFile, "gravity %f\n",&grav);
    
    fclose(myFile);
            myFile = NULL;
    obj.showCollisions = coll;
    obj.gravity = grav;
    
    return;
}

#pragma mark VC Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // this bullshit with saving file to disk took my longer than 30 minutes and still doesnt work
    // so I can just use a simple C creation
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *fileName = [NSString stringWithFormat:@"%@/settingsInformation.txt",
                          documentsDirectory];
    
    char * str = [fileName cStringUsingEncoding:NSUTF8StringEncoding];
    myFile = fopen(str,"r");
    
    if(!myFile){
        // first time create it
        [self basicWriteToFile:str withGravity:9.8f andDebuggingMode:NO ];
    
    }else{
        fclose(myFile);
        myFile = NULL;
    }
    if(_myObject == nil){
        // createa new one
        _myObject = [[SimpleGameObject alloc]init];
        [_myObject setGravity:6.0f andShowCollisions:NO];
    }
    [self basicReadFromFile:str withObject:_myObject];
    if(_mySlider){
        _mySlider.value = _myObject.gravity;
        
    }
    if(_mySwitch)
        _mySwitch.on = _myObject.showCollisions;
    

    
   
    
    // Do any additional setup after loading the view.
}
- (void)viewWillDisappear:(BOOL)animated{
// save data
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *fileName = [NSString stringWithFormat:@"%@/settingsInformation.txt",
                          documentsDirectory];
    
    char * str = [fileName cStringUsingEncoding:NSUTF8StringEncoding];
    [self basicWriteToFile:str withGravity:_myObject.gravity andDebuggingMode:_myObject.showCollisions];
    
           [super viewWillDisappear:animated];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
