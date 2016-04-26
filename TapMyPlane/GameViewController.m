//
//  GameViewController.m
//  TapMyPlane
//
//  Created by joshua on 2/10/16.
//  Copyright © 2016 joshua. All rights reserved.
//

#import "GameViewController.h"
#import "SpriteKit/SpriteKit.h"
#import "GamePlayScene.h"
#import "AvAudioPlayerPool.h"
#import "CollidableDrawer.h"

@interface GameViewController ()
@property (strong,nonatomic) CADisplayLink * displayLink;
@property (weak, nonatomic) IBOutlet UIImageView *grassBackground;
@property (weak, nonatomic) IBOutlet UIImageView *skyBackground;


@property (weak, nonatomic) IBOutlet UIButton *mountainUpFirst;
@property (weak, nonatomic) IBOutlet UIButton *mountainUpSecond;

@property (weak, nonatomic) IBOutlet UIButton *plane;

@property (weak, nonatomic) IBOutlet UIButton *mountainDownFirst;
@property (weak, nonatomic) IBOutlet UIButton *mountainDownSecond;


// Main menu popup begin

@property (strong, nonatomic) IBOutlet UIView *mainMenuPopupView;

@property (strong, nonatomic) IBOutlet UIButton *mainMenuPlayButton;
@property (strong, nonatomic) IBOutlet UIButton *mainMenuSettingsButton;
@property (strong, nonatomic) IBOutlet UIButton *mainMenuCreditButton;

// Main menu popup end


@property(strong,nonatomic) SKSpriteNode * mountainUpButton;
@property(strong,nonatomic) SKSpriteNode * mountainDownButton;
@property(strong,nonatomic) SKSpriteNode * planeButton;
@property(strong,nonatomic) GamePlayScene * gpScene;
@property(nonatomic,strong) UINavigationController * myNavigator;
//@property(weak,nonatomic)
@property(nonatomic) BOOL gameOver;
@property(nonatomic) BOOL backgroundMoving;
@property(nonatomic, strong) NSURL * planeLope;
@property(nonatomic, strong) NSURL * nukeAlarm;
@property(nonatomic, strong) NSURL * coinNoise;
@property(nonatomic, strong) NSURL * backgroundMusic;

@property(nonatomic,strong) AVAudioPlayer * planeLopePlayer;
@property(nonatomic,strong) AVAudioPlayer * nukeAlarmPlayer;
@property(nonatomic,strong) AVAudioPlayer * coinNoisePlayer;
@property(nonatomic,strong) AVAudioPlayer * backgroundMusicPlayer;
@property(nonatomic) BOOL playAtomic;
@property(nonatomic,strong) UIView * flashView;


@property double last;

@property double totalTime;
@property float frameRate;

@property int numFrames;



//@property(nonatomic, strong) (NSURL *) planeLope;

@end


const int MAIN_MENU_PLAY_TAG = 3;
const int MAIN_MENU_SETTINGS_TAG =4;
const int MAIN_MENU_CREDITS_TAG =5;

@implementation GameViewController : UIViewController
const int skyMoveSpeed =2;
const int grassMoveSpeed =4;
BOOL alreadyLoaded = false;

// changing the anchor point changes where the animation is applied

- (void)viewDidLoad {
    [super viewDidLoad];

    if(!alreadyLoaded){
        _mainMenuPlayButton.tag = MAIN_MENU_PLAY_TAG;
        _mainMenuSettingsButton.tag = MAIN_MENU_SETTINGS_TAG;
        _mainMenuCreditButton.tag = MAIN_MENU_CREDITS_TAG;
    }
    _gameOver = NO;
    _backgroundMoving = YES;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // init audio engine
    if(!_displayLink){
        // init it
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update:)];
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    //SKView * spriteView = [[[[UIApplication sharedApplication]delegate]window]rootViewController];
    SKView * spriteView = self.view;

   
        _playAtomic = YES;
        [_mainMenuPlayButton addTarget:self action:@selector(userTappedPlay) forControlEvents:UIControlEventTouchUpInside];
        //if(!initialized)
        _backgroundMusic = [[NSBundle mainBundle] URLForResource:@"background_music" withExtension:@"mp3"];
        _backgroundMusicPlayer = [AvAudioPlayerPool playerWithUrl:_backgroundMusic];
        _backgroundMusicPlayer.numberOfLoops = -1;
        [_backgroundMusicPlayer play];
        
        
        _planeLope = [[NSBundle mainBundle]URLForResource:@"plane_lope" withExtension:@".mp3"];
        _coinNoise = [[NSBundle mainBundle]URLForResource:@"coin_noise" withExtension:@".wav"];
        _nukeAlarm = [[NSBundle mainBundle]URLForResource:@"nuke_alarm" withExtension:@".mp3"];
        
        _planeLopePlayer = [AvAudioPlayerPool playerWithUrl:_planeLope];
        _planeLopePlayer.numberOfLoops = -1;
        _planeLopePlayer.volume = 0.10f;
        [_planeLopePlayer play];
        
        // This will intialize the players but not actually use them
        [AvAudioPlayerPool playerWithUrl:_coinNoise];
        [AvAudioPlayerPool playerWithUrl:_nukeAlarm];
        
        _gpScene = [[GamePlayScene alloc]initWithSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
        [_gpScene stopMountainSystem];
        
        
        _last = CACurrentMediaTime();
        
        _totalTime = 0;
        _frameRate = 1/60.0f;
        
        _numFrames = 0;
        
        
        
        
    
        spriteView.allowsTransparency = YES;
        spriteView.frameInterval = 1;
        
        
        //    spriteView.frameInterval =1;
        [spriteView presentScene:_gpScene];
        
    
    _gameOver = NO;
    _backgroundMoving = YES;
    _gpScene.debugMode = _debugMode;
    if(_debugMode){
        spriteView.showsDrawCount = YES;
        spriteView.showsFPS = YES;
        spriteView.showsNodeCount = YES;
    }
    
    
    alreadyLoaded = YES;
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) doMethodWith:
(   NSString *)thisString{
    NSLog(@"Logging your string %@", thisString);
}
-(void)goToSettingsSegue{
    _gameOver =YES;
    _backgroundMoving = NO;
    [self performSegueWithIdentifier:@"settingSegue" sender:self];
}
-(void) setButtons:(SKSpriteNode *)plane
    andMountUpRect:(SKSpriteNode *)mountain
      andMountDown:(SKSpriteNode *)down{
    _planeButton = plane;
    _mountainUpButton = mountain;
    _mountainDownButton = down;
    
}



-(void)userTappedPlay{
    NSLog(@"User tapped play bra");
    [self restartGame];
    
}
-(void)restartGame{
    [self.mainMenuPopupView removeFromSuperview];
    // make neccessary restarts
    if(_gpScene){
        [_gpScene resetViews];
    }
    
    _gameOver = NO;
    //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void){
    
    if(!_displayLink){
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update:)];

    }
    
    //});
}
-(void) update:(CADisplayLink *)displayLink{
    NSLog(@"COOONT");
    [self updateGameLoop];
}
-(void)tryGameOver{
    // [self performSegueWithIdentifier:@"MainMenuPopup" sender:self];
    //[_mainMenuPopupView add]
    [self.view addSubview:_mainMenuPopupView];
    //[self.view add]
    //UIButton * mainMenu = [_mainMenuPlayButton s]
   
    //[_mainMenuPopupView ad]
    [_mainMenuPlayButton addTarget:self action:@selector(userTappedPlay) forControlEvents:UIControlEventTouchUpInside];
    _gameOver = YES;
    [self.gpScene stopMountainSystem];
    
    
}

- (IBAction)homeButton:(id)sender {
    GameViewController * toBePresented = [self.storyboard instantiateViewControllerWithIdentifier:@"Start"];
    [self presentViewController:toBePresented animated:NO completion:NULL];
    
    NSLog(@"Trying to go home ");
    
}
#pragma mark - Called when I am about to transfer to another segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSLog(@"About to perform the %@ segue",segue.identifier);
    //_myNavigator  = [[UINavigationController alloc]initWithRootViewController:self];
    [_backgroundMusicPlayer stop];
    [_planeLopePlayer stop];
    [_nukeAlarmPlayer stop];
    [_coinNoisePlayer stop];
    [_displayLink invalidate];
    _displayLink = nil;
   
    
    [CollidableDrawer unlinkSpriteNodesWith:_gpScene];
    
    [_gpScene removeFromParent];
    SKView * myView = [self view];
    [myView presentScene:nil];
}
#pragma mark - Screen Flash For Loss
-(void) screenFlash{
    
    
    
    if(_flashView == nil)
    {
        _flashView = [[UIView alloc]
                      initWithFrame:CGRectMake(0,
                                               0,
                                               self.view.frame.size.width,
                                               self.view.frame.size.height)];
        _flashView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_flashView];
    }
    
    [_flashView setAlpha:1.0f];
    
    
    //flash animation code
    [UIView beginAnimations:@"flash screen" context:nil];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    [_flashView setAlpha:0.0f];
    
    [UIView commitAnimations];
    
    
    //    for(SKSpriteNode * spr : [_gpScene get])
    
    
    
}
#pragma mark - Game Loop
-(void) updateGameLoop{
    // 50 milis
    
    if(_backgroundMoving){
        _delta = CACurrentMediaTime() - _last;
        _last = _delta + _last;
        
        if(_delta < _frameRate){
            // wait
            [NSThread sleepForTimeInterval:_frameRate-_delta];
        }
        _numFrames++;
        
        // Apply game logic if the game is not over
        if (!_gameOver) {
            //dispatch_async(dispatch_get_main_queue(), ^{
            [_gpScene.modelPlane applyGravity:_delta withForce:-10.8f];
            [_gpScene.modelPlane applyFoce:60.0f forTime:_jumpForceTime/2];
            _jumpForceTime /=2;
            //[_gpScene.modelPlane applyFoce:30.0f forTime:_jumpForceTime/2];
            //});
            
            
            if(_gpScene != nil){
                if([_gpScene.mountSystem didHitPlane:_gpScene.modelPlane]){
                    // [self onGameOver];
                }
                
                if([Collideable did:_gpScene.modelPlane hit:_gpScene.groundFloor]){
                    [self onGameOver];
                    
                }
            }
            _jumpForceTime-=_delta;
            
            CGPoint  planePos =[_gpScene.modelPlane getMidPoint:self.view.bounds.size.height];
            _gpScene.plane.position = planePos;
            
            
            
        }
        // dont call this dumb dumnb
       // [_gpScene update:.05f];
        
        _totalTime+= _delta;
        if(_totalTime > 1.0){
            NSLog(@"Frames Per Second: %i",_numFrames);
            _numFrames = 0;
            _totalTime = 0.0;
        }
        
    }
}
-(void) onGameOver{
    
    _nukeAlarmPlayer = [AvAudioPlayerPool playerWithUrl:_nukeAlarm];
    [_nukeAlarmPlayer play];
    _playAtomic = NO;
    
    //AVAudioPlayer * gameOver = [AvAudioPlayerPool playerWithUrl:_nukeAlarm];
    
    //[gameOver play];
    
    _gameOver = YES;
    [self tryGameOver];
    [self screenFlash];
    
    
}
#pragma mark - Input
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    for(UITouch * touch in touches){
        CGPoint point = [touch locationInView:self.view];
        [self handleTouch:point];
    }
    _jumpForceTime = .10f;
    float vel = _gpScene.modelPlane.velocity;
    if(vel < -11){
        _gpScene.modelPlane.velocity+=25;
    }else if(vel < -7){
        _gpScene.modelPlane.velocity+=15;
    }else if(vel < -3){
        _gpScene.modelPlane.velocity+=13;
        
    }
    [_gpScene.modelPlane applyFoce:60.0f forTime:_jumpForceTime/2];
    _jumpForceTime /=2;
}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    for(UITouch * touch in touches){
        CGPoint point = [touch locationInView:self.view];
        int startOffset = self.view.frame.size.height/2;
        point.y = startOffset + (startOffset - point.y);
        NSLog(@"Dragging (%f,%f)",point.x,point.y);
        BOOL planeMoved = [self touchedInside:point againstRect:_planeButton.frame];
        if(planeMoved){
            
            _planeButton.position = point;
            
        }
    }
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}
-(BOOL)touchedInside:(CGPoint) point
         againstRect:(CGRect)rect{
    return point.x > rect.origin.x && point.x < (rect.origin.x + rect.size.width)
    && point.y > rect.origin.y && point.y < (rect.origin.y + rect.size.height);
    
}
-(void)handleTouch:(CGPoint)point{
    
    
    if (_gameOver) {
        // then check if they touched one of the buttons!!!
        if([self touchedInside:point againstRect:self.mainMenuPlayButton.frame] == YES){
            
            [self restartGame];
            return;
        }if([self touchedInside:point againstRect:self.mainMenuSettingsButton.frame] == YES){
            NSLog(@"You touched the settings button1!");
            [self goToSettingsSegue];
            return;
        }if([self touchedInside:point againstRect:self.mainMenuCreditButton.frame] == YES){
            
            NSLog(@"You touched the credits button1!");
            return;
        }
    }else{
        int startOffset = self.view.frame.size.height/2;
        point.y = startOffset + (startOffset - point.y);
        NSLog(@"You touched (%f,%f)",point.x,point.y);
        CGRect planeR = _planeButton.frame;
        CGRect mountUp = _mountainUpButton.frame;
        CGRect mountainDown = _mountainDownButton.frame;
        // [_planeClicker touchUpInside:point];
        
        BOOL planeHit = [self touchedInside:point
                                againstRect:planeR];
        BOOL upHit =[self touchedInside:point
                            againstRect:mountUp];
        BOOL downHit =     [self touchedInside:point
                                   againstRect:mountainDown];
        
        
        if(planeHit == YES){
            NSLog(@"You touched the plane at location %f %f",planeR.origin.x,planeR.origin.y);
        }
        if(upHit == YES){
            NSLog(@"You touched the mountina pointing up at location %f %f",mountUp.origin.x,mountUp.origin.y);
        }
        if(downHit == YES){
            NSLog(@"You touched the mountain pointng down at location %f  %f",mountainDown.origin.x,mountainDown.origin.y);
        }
    }
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
