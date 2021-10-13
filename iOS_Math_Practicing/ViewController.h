//
//  ViewController.h
//  Try_Shoot_learning
//

//  Copyright (c) 2015年 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "GameOverViewController.h"
#import "GameWinViewController.h"

extern const int NORMAL_MODE;
extern const int BREAK_GAME_MODE;
extern const int TIME_LIMIT_MODE;

@protocol gameDelegate <NSObject>

-(void)showGameOver;
-(void)showRankView;
-(void)restartGame;
-(void)showGameWin;

@end

@protocol pauseGameDelegate <NSObject>
- (void)pauseGame;
@end

@interface ViewController : UIViewController<gameDelegate,pauseGameDelegate>

@end
