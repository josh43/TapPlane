//
//  ViewController.m
//  TapMyPlane
//
//  Created by joshua on 2/10/16.
//  Copyright © 2016 joshua. All rights reserved.
//

#import "ViewController.h"
#import "GameViewController.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *tapPlayButton;
@property (weak, nonatomic) IBOutlet UIButton *creditsButton;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    _tapPlayButton.layer.borderWidth = 1.0f;
    _tapPlayButton.layer.cornerRadius = 3.0f;

    _tapPlayButton.layer.borderColor = [[UIColor blackColor]CGColor];
    
    _creditsButton.layer.borderWidth = 1.0f;
    _creditsButton.layer.cornerRadius = 3.0f;
    _creditsButton.layer.borderColor = [[UIColor blackColor]CGColor];
    NSLog(@"view controller logged");
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)credits:(id)sender {
}
-(IBAction)doneWithCredits:(UIStoryboardSegue *)sender{
    NSLog(@"I have popped off the credits and now am in View Controller");
}
-(IBAction)doneWithSettings:(UIStoryboardSegue *)sender{
    NSLog(@"I have popped off the settings and now am in View Controller");
}
-(IBAction)doneWithGame:(UIStoryboardSegue *)sender{
    NSLog(@"I have popped off the Game and now am in View Controller");
}
- (IBAction)startGame:(id)sender {
    // you need to set the id in the storyboard if you want to do it this way
    GameViewController * toBePresented = [self.storyboard instantiateViewControllerWithIdentifier:@"GameViewController"];
    [toBePresented doMethodWith:@"Holla"];
    [self presentViewController:toBePresented animated:NO completion:NULL];
    
    
}

@end
