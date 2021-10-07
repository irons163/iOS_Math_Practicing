//
//  ViewController.m
//  Try_Shoot_learning
//
//  Created by irons on 2015/5/7.
//  Copyright (c) 2015年 ___FULLUSERNAME___. All rights reserved.
//

#import "ViewController.h"
#import "MyScene.h"
#import "GameCenterUtil.h"

@implementation ViewController{
    ADBannerView * adBannerView;
    MyScene * scene;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(echoNotification:) name:@"pauseGame" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(echoNotificationResume:) name:@"resumeGame" object:nil];
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
//    skView.showsFPS = YES;
//    skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    scene = [MyScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    scene.gameDelegate = self;
    
    // Present the scene.
    [skView presentScene:scene];
    
    adBannerView = [[ADBannerView alloc] initWithFrame:CGRectMake(0, -50, 200, 30)];
    adBannerView.delegate = self;
    adBannerView.alpha = 1.0f;
    [self.view addSubview:adBannerView];
    
    GameCenterUtil * gameCenterUtil = [GameCenterUtil sharedInstance];
    gameCenterUtil.delegate = self;
    [gameCenterUtil isGameCenterAvailable];
    [gameCenterUtil authenticateLocalUser:self];
    [gameCenterUtil submitAllSavedScores];
}

-(void) showRankView{
    GameCenterUtil * gameCenterUtil = [GameCenterUtil sharedInstance];
    gameCenterUtil.delegate = self;
    [gameCenterUtil isGameCenterAvailable];
    //    [gameCenterUtil authenticateLocalUser:self];
    [gameCenterUtil showGameCenter:self];
    [gameCenterUtil submitAllSavedScores];
}

-(void)showGameOver{
    //    return;
    GameOverViewController* gameOverDialogViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"GameOverViewController"];
    gameOverDialogViewController.gameDelegate = self;
    
    gameOverDialogViewController.gameTime = [scene getAnswerCorrectNUm];
    
    self.navigationController.providesPresentationContextTransitionStyle = YES;
    self.navigationController.definesPresentationContext = YES;
    
    [gameOverDialogViewController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    
    [self presentViewController:gameOverDialogViewController animated:YES completion:^{
        //        [reset];
    }];
    
}

-(void)showGameWin{
    //    return;
    GameWinViewController* gameWinDialogViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"GameWinViewController"];
    gameWinDialogViewController.gameDelegate = self;
    
    gameWinDialogViewController.gameTime = [scene getGameTime];
    
    self.navigationController.providesPresentationContextTransitionStyle = YES;
    self.navigationController.definesPresentationContext = YES;
    
    [gameWinDialogViewController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    
    [self presentViewController:gameWinDialogViewController animated:YES completion:^{
        //        [reset];
    }];
    
}

-(void)restartGame{
    SKView * skView = (SKView *)self.view;
    [self initAndaddScene:skView];
}

-(void)initAndaddScene:(SKView*)skView{
    // Create and configure the scene.
    // Create and configure the scene.
    int mode = scene.gameMode;
    scene = [MyScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    scene.gameDelegate = self;
    scene.gameMode = mode;
    [scene setWillChangeGameMode:mode];
    // Present the scene.
    [skView presentScene:scene];
}

- (void)echoNotification:(NSNotification *)notification {
    [self pauseGame];
}

- (void)echoNotificationResume:(NSNotification *)notification{
    [scene setGameRun:true];
}

-(void)pauseGame{
    [scene setGameRun:false];
}

-(void)bannerViewDidLoadAd:(ADBannerView *)banner{
    [self layoutAnimated:true];
}


-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    //    [adBannerView removeFromSuperview];
    //    adBannerView.delegate = nil;
    //    adBannerView = nil;
    [self layoutAnimated:true];
}

-(BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave{
    //    [MyScene setAllGameRun:NO];
    return true;
}

- (void)layoutAnimated:(BOOL)animated
{
    //    CGRect contentFrame = self.view.bounds;
    
    CGRect contentFrame = self.view.bounds;
    //    contentFrame.origin.y = -50;
    CGRect bannerFrame = adBannerView.frame;
    if (adBannerView.bannerLoaded)
    {
        //        contentFrame.size.height -= adBannerView.frame.size.height;
        contentFrame.size.height = 0;
        bannerFrame.origin.y = contentFrame.size.height;
    } else {
        //        bannerFrame.origin.y = contentFrame.size.height;
        bannerFrame.origin.y = -50;
    }
    
    [UIView animateWithDuration:animated ? 0.25 : 0.0 animations:^{
        adBannerView.frame = contentFrame;
        [adBannerView layoutIfNeeded];
        adBannerView.frame = bannerFrame;
    }];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
