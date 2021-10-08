//
//  MyScene.h
//  Try_Shoot_learning
//
//  Copyright (c) 2015年 ___FULLUSERNAME___. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@protocol gameDelegate;

extern const int NORMAL_MODE;
extern const int BREAK_GAME_MODE;
extern const int TIME_LIMIT_MODE;

@interface MyScene : SKScene<UIActionSheetDelegate>

@property (nonatomic) NSTimeInterval lastSpawnTimeInterval;
@property (nonatomic) NSTimeInterval lastSpawnMoveTimeInterval;
@property (nonatomic) NSTimeInterval lastSpawnShootTimeInterval;
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;

@property (weak) id<gameDelegate> gameDelegate;

@property int gameMode;

- (void)setGameRun:(bool)isrun;

- (int)getAnswerCorrectNUm;

- (int)getGameTime;

- (void)setWillChangeGameMode:(int)willChangeGameMode;

@end
