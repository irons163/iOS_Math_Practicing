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

@implementation ViewController {
    MyScene *scene;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(echoNotification:) name:@"pauseGame" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(echoNotificationResume:) name:@"resumeGame" object:nil];
    
    SKView *skView = (SKView *)self.view;
    
    // Create and configure the scene.
    scene = [MyScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    scene.gameDelegate = self;
    
    // Present the scene.
    [skView presentScene:scene];
    
    GameCenterUtil *gameCenterUtil = [GameCenterUtil sharedInstance];
    gameCenterUtil.delegate = self;
    [gameCenterUtil isGameCenterAvailable];
    [gameCenterUtil authenticateLocalUser:self];
    [gameCenterUtil submitAllSavedScores];
}

- (void)showRankView {
    GameCenterUtil *gameCenterUtil = [GameCenterUtil sharedInstance];
    gameCenterUtil.delegate = self;
    [gameCenterUtil isGameCenterAvailable];
    [gameCenterUtil showGameCenter:self];
    [gameCenterUtil submitAllSavedScores];
}

- (void)showGameOver {
    GameOverViewController *gameOverDialogViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"GameOverViewController"];
    gameOverDialogViewController.gameDelegate = self;
    
    gameOverDialogViewController.gameTime = [scene getAnswerCorrectNUm];
    
    self.navigationController.providesPresentationContextTransitionStyle = YES;
    self.navigationController.definesPresentationContext = YES;
    
    [gameOverDialogViewController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    
    [self presentViewController:gameOverDialogViewController animated:YES completion:nil];
    
}

- (void)showGameWin {
    GameWinViewController *gameWinDialogViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"GameWinViewController"];
    gameWinDialogViewController.gameDelegate = self;
    
    gameWinDialogViewController.gameTime = [scene getGameTime];
    
    self.navigationController.providesPresentationContextTransitionStyle = YES;
    self.navigationController.definesPresentationContext = YES;
    
    [gameWinDialogViewController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    
    [self presentViewController:gameWinDialogViewController animated:YES completion:nil];
    
}

- (void)restartGame {
    SKView *skView = (SKView *)self.view;
    [self initAndaddScene:skView];
}

- (void)initAndaddScene:(SKView*)skView {
    int mode = scene.gameMode;
    scene = [MyScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    scene.gameDelegate = self;
    scene.gameMode = mode;
    [scene setWillChangeGameMode:mode];
    
    [skView presentScene:scene];
}

- (void)echoNotification:(NSNotification *)notification {
    [self pauseGame];
}

- (void)echoNotificationResume:(NSNotification *)notification {
    [scene setGameRun:true];
}

- (void)pauseGame {
    [scene setGameRun:false];
}

- (void)layoutAnimated:(BOOL)animated {

}

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
