//
//  MyScene.m
//  Try_Shoot_learning
//
//  Created by irons on 2015/5/7.
//  Copyright (fc) 2015年 ___FULLUSERNAME___. All rights reserved.
//

#import "MyScene.h"
#import "TextureHelper.h"
#import "MyUtils.h"
#import "Cloud.h"
#import "Bullet.h"
#import "GameCenterUtil.h"
#import "CommonUtil.h"

int projectileLayerZPosition = -2;
int GAME_LEVEL2_START_LEVEL = 10;
int GAME_LEVEL3_START_LEVEL = 20;
int GAME_LEVEL4_START_LEVEL = 30;
int GAME_LEVEL5_START_LEVEL = 40;
int GAME_SUCCESS_LEVEL = 50;
int GAME_TIME_LIMIT_LEVEL2_START_LEVEL = 3;
int GAME_TIME_LIMIT_LEVEL3_START_LEVEL = 6;
int GAME_TIME_LIMIT_LEVEL4_START_LEVEL = 9;
int GAME_TIME_LIMIT_LEVEL5_START_LEVEL = 12;

const int NONE_MODE = -1;
const int INFINITY_MODE = 0;
const int BREAK_GAME_MODE = 1;
const int TIME_LIMIT_MODE = 2;

const int CLOUD_DEFAULT_MOVE_SPEED = 7;
const int CLOUD_LEVEL2_MOVE_SPEED = 9;
const int CLOUD_LEVEL3_MOVE_SPEED = 11;
const int CLOUD_LEVEL4_MOVE_SPEED = 13;
const int CLOUD_LEVEL5_MOVE_SPEED = 15;

int maxTime = 60;

static inline CGPoint rwAdd(CGPoint a, CGPoint b) {
    return CGPointMake(a.x + b.x, a.y + b.y);
}

@implementation MyScene{
    SKSpriteNode *player;
    SKSpriteNode *controlPoint;
    SKSpriteNode *gestureHintPoint;
    SKSpriteNode *pauseBtnNode;
    CGPoint touchPoint;
    SKSpriteNode *controlBar;
    SKSpriteNode *infoBar;
    SKSpriteNode *backgroundNode;
    SKLabelNode *questionNode;
    SKLabelNode *questionNode2;
    SKLabelNode *questionNode3;
    SKLabelNode *gameTimeNode;
    
    int gameLevel;
    int gameTime;
    
    int answar;
    int answars[3];
    int answerCorrectNUm;
    int answarIndex;
    
    bool isGameRun;
    int willChangeGameMode;
    int cloudMoveSpeed;
    
    NSMutableArray *array;
    NSMutableArray *clouds;
    NSMutableArray *spriteNodesProjectile;
    
    SKSpriteNode *rankBtn;
    SKSpriteNode *musicBtn;
    SKSpriteNode *modeBtn;
    NSMutableArray *cloudTexturesArray;
    
    SKSpriteNode *cloudClearedNode;
    SKLabelNode *cloudClearedNumNode;
    
    NSTimer *theGameTimer;
    
    NSMutableArray *musicBtnTextures;
    
    int correctAnswarIndex;
    int hintAppearingTimerCounter;
}

static int playerInitX, playerInitY;
static int barInitX, barInitY;
int backgroundLayerZPosition = -2;

static const uint32_t projectileCategory = 0x1 << 0;
static const uint32_t monsterCategory = 0x1 << 1;
static const uint32_t toolCategory = 0x1 << 2;
static const uint32_t hamsterCategory = 0x1 << 5;

bool isShootEnable = false;
bool isMoveBar = false;
bool isMoveAble = true;
bool isGameEndSuccess = false;

- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        NSLog(@"Size: %@", NSStringFromCGSize(size));
        [self initGame];
    }
    return self;
}

- (void)initGame {
    self.physicsWorld.gravity = CGVectorMake(0,0);
    self.physicsWorld.contactDelegate = self;
    
    gameLevel = 0;
    gameTime = 0;
    cloudMoveSpeed = CLOUD_DEFAULT_MOVE_SPEED;
    
    isGameRun = true;
    willChangeGameMode = NONE_MODE;
    
    cloudTexturesArray = [NSMutableArray array];
    [cloudTexturesArray addObject:[SKTexture textureWithImageNamed:@"c1-hd"]];
    [cloudTexturesArray addObject:[SKTexture textureWithImageNamed:@"c2-hd"]];
    [cloudTexturesArray addObject:[SKTexture textureWithImageNamed:@"c3-hd"]];
    [TextureHelper initTextures];
    
    musicBtnTextures = [NSMutableArray array];
    [musicBtnTextures addObject:[SKTexture textureWithImageNamed:@"btn_Music-hd"]];
    [musicBtnTextures addObject:[SKTexture textureWithImageNamed:@"btn_Music_Select-hd"]];
    
    clouds = [NSMutableArray array];
    
    spriteNodesProjectile = [[NSMutableArray alloc] init];
    
    controlBar = [SKSpriteNode spriteNodeWithImageNamed:@"control_bar"];
    controlBar.position = CGPointMake(0, 0);
    
    infoBar = [SKSpriteNode spriteNodeWithImageNamed:@"info_bar"];
    infoBar.size = CGSizeMake(self.frame.size.width, 30);
    infoBar.position = CGPointMake(self.frame.size.width / 2, infoBar.size.height / 2);
    
    backgroundNode = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"bgMainMenu-hd"]];
    
    CGSize backgroundSize = CGSizeMake(self.frame.size.width, self.frame.size.height - controlBar.size.height);
    
    backgroundNode.size = backgroundSize;
    
    backgroundNode.anchorPoint = CGPointMake(0, 0);
    
    backgroundNode.position = CGPointMake(0, 70);
    
    backgroundNode.zPosition = backgroundLayerZPosition;
    
    [self addChild:backgroundNode];
    
    [self addChild:controlBar];
    
    [self addChild:infoBar];
    
    NSArray * nsArray = [TextureHelper getTexturesWithSpriteSheetNamed:@"hamster" withinNode:nil sourceRect:CGRectMake(0, 0, 192, 200) andRowNumberOfSprites:2 andColNumberOfSprites:7
                                                              sequence:@[@7]];
    
    player = [SKSpriteNode spriteNodeWithTexture:nsArray[0]];
    
    player.size = CGSizeMake(60, 60);
    
    playerInitX = self.size.width / 2.0f;
    playerInitY = player.size.height + 40;
    player.position = CGPointMake(playerInitX, playerInitY);
    
    player.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:player.size.width/2];
    player.physicsBody.dynamic = YES;
    player.physicsBody.categoryBitMask = hamsterCategory;
    player.physicsBody.contactTestBitMask = monsterCategory|toolCategory;
    player.physicsBody.collisionBitMask = 0;
    player.physicsBody.usesPreciseCollisionDetection = YES;
    
    [self addChild:player];
    
    controlPoint = [SKSpriteNode spriteNodeWithImageNamed:@"control_point"];
    controlPoint.size = CGSizeMake(50, 50);
    
    barInitX = playerInitX;
    barInitY = controlPoint.size.height;
    controlPoint.position = CGPointMake(barInitX, barInitY);
    [self addChild:controlPoint];
    
    gestureHintPoint = [SKSpriteNode spriteNodeWithImageNamed:@"row-2-column-2"];
    CGSize size = gestureHintPoint.calculateAccumulatedFrame.size;
    CGFloat aspectRatio = size.width / size.height;
    CGFloat gestureHintWidth = controlPoint.size.width * 1.5;
    gestureHintPoint.size = CGSizeMake(gestureHintWidth, gestureHintWidth / aspectRatio);
    gestureHintPoint.anchorPoint = CGPointMake(0.5, 1);
    gestureHintPoint.hidden = true;
    [self addChild:gestureHintPoint];
    
    id isFirstLaunch = [[NSUserDefaults standardUserDefaults] objectForKey:@"isFirstLaunch"];
    if (isFirstLaunch == nil || [isFirstLaunch boolValue]) {
        [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"isFirstLaunch"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self showHint];
        });
    }
    
    rankBtn = [SKSpriteNode spriteNodeWithImageNamed:@"leader_board_btn"];
    rankBtn.size = CGSizeMake(42,42);
    rankBtn.anchorPoint = CGPointMake(0, 0);
    rankBtn.position = CGPointMake(self.frame.size.width - rankBtn.size.width, self.frame.size.height/2);
    rankBtn.zPosition = backgroundLayerZPosition;
    [self addChild:rankBtn];
    
    musicBtn = [SKSpriteNode spriteNodeWithImageNamed:@"btn_Music-hd"];
    musicBtn.size = CGSizeMake(42,42);
    musicBtn.anchorPoint = CGPointMake(0, 0);
    musicBtn.position = CGPointMake(self.frame.size.width - musicBtn.size.width, self.frame.size.height/2 - musicBtn.size.height);
    musicBtn.zPosition = backgroundLayerZPosition;
    [self addChild:musicBtn];
    
    modeBtn = [SKSpriteNode spriteNodeWithImageNamed:@"btn_Menu-hd"];
    modeBtn.size = CGSizeMake(42,42);
    modeBtn.anchorPoint = CGPointMake(0, 0);
    modeBtn.position = CGPointMake(self.frame.size.width - modeBtn.size.width, self.frame.size.height / 2 - modeBtn.size.height * 2);
    modeBtn.zPosition = backgroundLayerZPosition;
    [self addChild:modeBtn];
    
    cloudClearedNode = [SKSpriteNode spriteNodeWithImageNamed:@"c1-hd"];
    cloudClearedNode.anchorPoint = CGPointMake(0, 0);
    cloudClearedNode.size = CGSizeMake(70, 50);
    cloudClearedNode.position = CGPointMake(0, 100);
    
    cloudClearedNumNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    cloudClearedNumNode.text = @"0";
    cloudClearedNumNode.fontSize = 20;
    cloudClearedNumNode.color = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
    cloudClearedNumNode.position = CGPointMake(cloudClearedNode.position.x + cloudClearedNode.size.width + cloudClearedNumNode.frame.size.width / 2, cloudClearedNode.position.y + 3 );
    
    [self addChild:cloudClearedNode];
    [self addChild:cloudClearedNumNode];
    
    questionNode = [SKLabelNode labelNodeWithText:@"0000000"];
    questionNode.fontColor = [UIColor redColor];
    questionNode.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    [self addChild:questionNode];
    [self createQuestion];
    
    questionNode2 = [SKLabelNode labelNodeWithText:@"0000000"];
    questionNode2.fontColor = [UIColor redColor];
    questionNode2.position = CGPointMake(self.frame.size.width / 2, questionNode.position.y - questionNode2.frame.size.height);
    [self addChild:questionNode2];
    [self createQuestion];
    questionNode2.hidden = YES;
    
    questionNode3 = [SKLabelNode labelNodeWithText:@"0000000"];
    questionNode3.fontColor = [UIColor redColor];
    questionNode3.position = CGPointMake(self.frame.size.width / 2, questionNode2.position.y - questionNode3.frame.size.height);
    [self addChild:questionNode3];
    
    questionNode3.hidden = YES;
    
    gameTimeNode = [SKLabelNode labelNodeWithText:@"00:00"];
    gameTimeNode.fontName = @"Blod";
    gameTimeNode.fontSize = 25;
    gameTimeNode.position = CGPointMake(self.frame.size.width - gameTimeNode.frame.size.width / 2, self.frame.size.height - gameTimeNode.frame.size.height - 50);
    [self addChild:gameTimeNode];
    gameTimeNode.hidden = YES;
    
    [MyUtils preparePlayBackgroundMusic:@"am_white"];
    
    id isPlayMusicObject = [[NSUserDefaults standardUserDefaults] objectForKey:@"isPlayMusic"];
    BOOL isPlayMusic = true;
    if (isPlayMusicObject==nil) {
        isPlayMusicObject = false;
    } else {
        isPlayMusic = [isPlayMusicObject boolValue];
    }
    
    if (isPlayMusic) {
        [MyUtils backgroundMusicPlayerPlay];
        musicBtn.texture = musicBtnTextures[0];
    } else {
        [MyUtils backgroundMusicPlayerPause];
        musicBtn.texture = musicBtnTextures[1];
    }
}

- (void)didMoveToView:(SKView *)view {
    [self setModeByGameMode];
}

- (void)showHint {
    gestureHintPoint.position = CGPointMake(controlPoint.position.x, controlPoint.position.y + controlPoint.size.width / 2);
    gestureHintPoint.hidden = false;
    SKAction *actionRight = [SKAction moveToX:gestureHintPoint.position.x + 30 duration:0.6];
    SKAction *actionLeft = [SKAction moveToX:gestureHintPoint.position.x - 30 duration:1.2];
    SKAction *actionRightAgain = [SKAction moveToX:gestureHintPoint.position.x duration:0.6];
    SKAction *actionMoveDone = [SKAction hide];
    [gestureHintPoint runAction:[SKAction sequence:@[actionRight, actionLeft, actionRightAgain, actionMoveDone]]];
}

#pragma mark - Touch Events
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    CGRect rect = [controlPoint calculateAccumulatedFrame];
    bool isCollision = CGRectContainsPoint(rect, location);
    if (isCollision) {
        touchPoint = location;
        isMoveBar = true;
        hintAppearingTimerCounter = 0;
    }
    
    if (pauseBtnNode.hidden == false) {
        rect = [pauseBtnNode calculateAccumulatedFrame];
        isCollision = CGRectContainsPoint(rect, location);
        if (isCollision) {
            [self setGameRun:YES];;
        }
    }
    
    if (CGRectContainsPoint(rankBtn.calculateAccumulatedFrame, location)) {
        [self.gameDelegate showRankView];
    } else if (CGRectContainsPoint(modeBtn.calculateAccumulatedFrame, location)) {
        UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"InfinityMode", @""),NSLocalizedString(@"BreakthroughMode", @""), NSLocalizedString(@"TimeLimitMode", @""), nil];
        [actionSheet showInView:self.view];
    } else if(CGRectContainsPoint(musicBtn.calculateAccumulatedFrame, location)) {
        if ([MyUtils isBackgroundMusicPlayerPlaying]) {
            [MyUtils backgroundMusicPlayerPause];
            musicBtn.texture = musicBtnTextures[1];
            [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"isPlayMusic"];
        } else {
            [MyUtils backgroundMusicPlayerPlay];
            musicBtn.texture = musicBtnTextures[0];
            [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"isPlayMusic"];
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (isMoveBar && isMoveAble) {
        UITouch *touch = [touches anyObject];
        CGPoint location = [touch locationInNode:self];
        
        CGFloat offx = location.x - touchPoint.x;
        CGPoint position = controlPoint.position;
        position.x = position.x + offx;
        controlPoint.position = position;
        
        position = player.position;
        position.x = position.x + offx;
        player.position = position;
        
        touchPoint = location;
        
        if (offx > 8) {
            player.xScale = -1;
            player.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:player.size.width / 2];
            player.physicsBody.dynamic = YES;
            player.physicsBody.categoryBitMask = hamsterCategory;
            player.physicsBody.contactTestBitMask = monsterCategory|toolCategory;
            player.physicsBody.collisionBitMask = 0;
            player.physicsBody.usesPreciseCollisionDetection = YES;
            
            NSArray * nsArray = [TextureHelper getTexturesWithSpriteSheetNamed:@"hamster" withinNode:nil sourceRect:CGRectMake(0, 0, 192, 200) andRowNumberOfSprites:2 andColNumberOfSprites:7
                                                                      sequence:@[@3,@4,@5,@4,@3,@2]];
            
            SKAction * monsterAnimation = [SKAction animateWithTextures:nsArray timePerFrame:0.1];
            [player runAction:monsterAnimation];
        } else if(offx < -8) {
            player.xScale = 1;
            
            player.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:player.size.width/2];
            player.physicsBody.dynamic = YES;
            player.physicsBody.categoryBitMask = hamsterCategory;
            player.physicsBody.contactTestBitMask = monsterCategory|toolCategory;
            player.physicsBody.collisionBitMask = 0;
            player.physicsBody.usesPreciseCollisionDetection = YES;
            
            NSArray * nsArray = [TextureHelper getTexturesWithSpriteSheetNamed:@"hamster" withinNode:nil sourceRect:CGRectMake(0, 0, 192, 200) andRowNumberOfSprites:2 andColNumberOfSprites:7
                                                                      sequence:@[@3,@4,@5,@4,@3,@2]];
            
            SKAction * monsterAnimation = [SKAction animateWithTextures:nsArray timePerFrame:0.1];
            [player runAction:monsterAnimation];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    if (isMoveBar) {
        isMoveBar = false;
        isShootEnable = true;
    }
    
    if (isGameEndSuccess) {
        [self backToMenu];
    }
}

- (void)backToMenu {
    [self removeFromParent];
}

#pragma mark - Levels
- (NSString *)level1 {
    int firstNum;
    int secondNum;
    NSString *questionStr;
    firstNum = arc4random_uniform(10);
    secondNum = arc4random_uniform(10);
    int r = arc4random_uniform(2);
    if (r == 0) {
        answar = firstNum + secondNum;
        questionStr = @"%d+%d=?";
    } else {
        answar = firstNum - secondNum;
        questionStr = @"%d-%d=?";
    }
    
    return [NSString stringWithFormat:questionStr, firstNum, secondNum];
}

- (NSString *)level2 {
    int firstNum;
    int secondNum;
    NSString *questionStr;
    firstNum = arc4random_uniform(100);
    secondNum = arc4random_uniform(100);
    int r = arc4random_uniform(2);
    if (r == 0) {
        answar = firstNum + secondNum;
        questionStr = @"%d+%d=?";
    } else {
        answar = firstNum - secondNum;
        questionStr = @"%d-%d=?";
    }
    
    return [NSString stringWithFormat:questionStr, firstNum, secondNum];
}

- (NSString *)level3 {
    int firstNum;
    int secondNum;
    NSString *questionStr;
    firstNum = arc4random_uniform(1000);
    secondNum = arc4random_uniform(1000);
    int r = arc4random_uniform(2);
    if (r == 0) {
        answar = firstNum + secondNum;
        questionStr = @"%d+%d=?";
    } else {
        answar = firstNum - secondNum;
        questionStr = @"%d-%d=?";
    }
    
    return [NSString stringWithFormat:questionStr, firstNum, secondNum];
}

- (NSString *)level4 {
    int firstNum;
    int secondNum;
    NSString *questionStr;
    firstNum = arc4random_uniform(10);
    secondNum = arc4random_uniform(10);
    int r = arc4random_uniform(2);
    if (r == 0) {
        answar = firstNum * secondNum;
        questionStr = @"%dx%d=?";
    } else {
        if (secondNum > firstNum) {
            int tmp = firstNum;
            firstNum = secondNum;
            secondNum = tmp;
        }
        if (secondNum == 0) {
            secondNum = 1;
        }
        answar = firstNum / secondNum;
        questionStr = @"%d÷%d=?";
        
    }
    
    return [NSString stringWithFormat:questionStr, firstNum, secondNum];
}

- (NSString *)level5 {
    int firstNum;
    int secondNum;
    NSString *questionStr;
    firstNum = arc4random_uniform(100);
    secondNum = arc4random_uniform(100);
    int r = arc4random_uniform(2);
    if (r == 0) {
        answar = firstNum * secondNum;
        questionStr = @"%dx%d=?";
    } else {
        if (secondNum > firstNum) {
            int tmp = firstNum;
            firstNum = secondNum;
            secondNum = tmp;
        }
        if (secondNum == 0) {
            secondNum = 1;
        }
        answar = firstNum / secondNum;
        questionStr = @"%d÷%d=?";
    }
    
    return [NSString stringWithFormat:questionStr, firstNum, secondNum];
}

#pragma mark - Questions
- (void)createGameWithRandomQuestionType:(BOOL)random {
    correctAnswarIndex = arc4random_uniform(3);
    int questionType = 0;
    
    if (answerCorrectNUm >= GAME_LEVEL5_START_LEVEL) {
        questionType = 0;
    } else if (answerCorrectNUm >= GAME_LEVEL4_START_LEVEL) {
        questionType = 1;
    } else if (answerCorrectNUm >= GAME_LEVEL3_START_LEVEL) {
        questionType = 2;
    } else if (answerCorrectNUm >= GAME_LEVEL2_START_LEVEL) {
        questionType = 3;
    } else {
        questionType = 4;
    }
    
    for (int i = 0; i < 3; i++) {
        if (random) {
            questionType = arc4random_uniform(5);
        }
        
        NSString *questionString;
        if (questionType == 0) {
            questionString = [self level5];
        } else if (questionType == 1) {
            questionString = [self level4];
        } else if (questionType == 2) {
            questionString = [self level3];
        } else if (questionType == 3) {
            questionString = [self level2];
        } else {
            questionString = [self level1];
        }
        
        Boolean isHasTheSameNum = false;
        for (int j = 0; j < i; j++) {
            if (answar == answars[j]) {
                isHasTheSameNum = true;
                break;
            }
        }
        
        if (isHasTheSameNum) {
            i--;
            continue;
        }
        
        answars[i] = answar;
        
        if (i == correctAnswarIndex)
            questionNode.text = questionString;
    }
}

- (void)createQuestion {    
    if (self.gameMode == BREAK_GAME_MODE) {
        [self createGameWithRandomQuestionType:NO];
    } else if (self.gameMode == TIME_LIMIT_MODE) {
        for (int i = 0; i < 3; i++) {
            NSString *questionString;
            if (answerCorrectNUm >= GAME_TIME_LIMIT_LEVEL5_START_LEVEL) {
                questionString = [self level5];
            } else if (answerCorrectNUm >= GAME_TIME_LIMIT_LEVEL4_START_LEVEL) {
                questionString = [self level4];
            } else if (answerCorrectNUm >= GAME_TIME_LIMIT_LEVEL3_START_LEVEL) {
                questionString = [self level3];
            } else if (answerCorrectNUm >= GAME_TIME_LIMIT_LEVEL2_START_LEVEL) {
                questionString = [self level2];
            } else {
                questionString = [self level1];
            }
            
            answars[i] = answar;
            if (i == 0) {
                questionNode.text = questionString;
            } else if (i == 1) {
                questionNode2.text = questionString;
            } else {
                questionNode3.text = questionString;
            }
        }
    } else {
        [self createGameWithRandomQuestionType:YES];
    }
}

- (void)checkAndCreateAnswer {
    if (answarIndex < array.count)
        return;
    
    answarIndex = 0;
    array = [NSMutableArray array];
    
    if (self.gameMode == BREAK_GAME_MODE || self.gameMode == INFINITY_MODE) {
        for (int i = 0; i < 3; i++) {
            array[i] = [NSNumber numberWithInt:answars[i]];
        }
    } else if (self.gameMode == TIME_LIMIT_MODE) {
        
        NSMutableArray * tmp = [self getAnswarsRandom];
        
        for (int i = 0; i < 3; i++) {
            int index = [tmp[i] intValue];
            array[i] = [NSNumber numberWithInt:answars[index]];
        }
    }
}

- (NSMutableArray *)getAnswarsRandom {
    NSMutableArray *uniqueNumbers = [[NSMutableArray alloc] init];
    int r;
    while (uniqueNumbers.count < 3){
        r = arc4random_uniform(3);
        if (![uniqueNumbers containsObject:[NSNumber numberWithInt:r]]) {
            [uniqueNumbers addObject:[NSNumber numberWithInt:r]];
        }
    }
    return uniqueNumbers;
}

- (int)getAnswer {
    int answer = [array[answarIndex] intValue];
    answarIndex++;
    return answer;
}

- (void)checkAndCreateCloud {
    if (self.gameMode == BREAK_GAME_MODE || self.gameMode == INFINITY_MODE) {
        for (int i = 0; i < 1; i++) {
            int cloudStyleIndex = arc4random_uniform(cloudTexturesArray.count);
            Cloud * cloud = [Cloud spriteNodeWithTexture:cloudTexturesArray[cloudStyleIndex]];
            cloud.size = CGSizeMake(120, 80);
            cloud.position = CGPointMake(0 - cloud.size.width / 2.0f, arc4random_uniform(self.frame.size.height - cloudClearedNode.position.y*3 - cloud.size.height / 2) + cloudClearedNode.position.y * 2);
            cloud.num = [self getAnswer];
            cloud.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:cloud.size.width / 2.5f];
            cloud.physicsBody.dynamic = YES;
            cloud.physicsBody.categoryBitMask = monsterCategory;
            cloud.physicsBody.contactTestBitMask = projectileCategory;
            cloud.physicsBody.collisionBitMask = 0;
            cloud.physicsBody.usesPreciseCollisionDetection = YES;
            [self addChild:cloud];
            [clouds addObject:cloud];
        }
    } else if(self.gameMode == TIME_LIMIT_MODE) {
        int cloudStyleIndex = arc4random_uniform(cloudTexturesArray.count);
        Cloud * cloud = [Cloud spriteNodeWithTexture:cloudTexturesArray[cloudStyleIndex]];
        cloud.size = CGSizeMake(120, 80);
        cloud.position = CGPointMake(0, arc4random_uniform(self.frame.size.height - cloudClearedNode.position.y*2 - cloud.size.height/2) + cloudClearedNode.position.y*2);
        cloud.num = [self getAnswer];
        cloud.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:cloud.size.width/2.5f];
        cloud.physicsBody.dynamic = YES;
        cloud.physicsBody.categoryBitMask = monsterCategory;
        cloud.physicsBody.contactTestBitMask = projectileCategory;
        cloud.physicsBody.collisionBitMask = 0;
        cloud.physicsBody.usesPreciseCollisionDetection = YES;
        [self addChild:cloud];
        [clouds addObject:cloud];
    }
}

- (void)checkAndMoveClouds {
    for(int i = 0; i < clouds.count; i++){
        Cloud * cloud = clouds[i];
        cloud.position = CGPointMake(cloud.position.x + cloudMoveSpeed, cloud.position.y);
    }
}

- (void)checkAndRemoveCloud {
    for(int i = 0; i < clouds.count; i++){
        Cloud * cloud = clouds[i];
        if(cloud.position.x - cloud.size.width/2.0f > self.frame.size.width){
            [cloud removeFromParent];
            [clouds removeObject:cloud];
        }
    }
}

- (void)shoot {
    NSArray * nsArray = [TextureHelper getTexturesWithSpriteSheetNamed:@"bullets" withinNode:nil sourceRect:CGRectMake(0, 0, 200, 232) andRowNumberOfSprites:1 andColNumberOfSprites:3];
    
    Bullet * projectile = [Bullet spriteNodeWithTexture:nil size:CGSizeMake(50, 50)];
    
    projectile.position = player.position;
    
    SKAction * monsterAnimation = [SKAction repeatActionForever:[SKAction animateWithTextures:nsArray timePerFrame:0.08]];
    
    [projectile runAction:[SKAction repeatActionForever: monsterAnimation ]];
    
    projectile.zPosition = projectileLayerZPosition;
    [self insertChild:projectile atIndex:1];
    //        [self addChild:projectile];
    [spriteNodesProjectile addObject:projectile];
    
    CGPoint p = CGPointMake(0, 1000);
    
    CGPoint realDest = rwAdd(p, projectile.position);
    
    float velocity = 480.0/5.0;
    float realMoveDuration = self.size.width / velocity;
    SKAction * actionMove = [SKAction moveTo:realDest duration:realMoveDuration];
    SKAction * actionMoveDone = [SKAction removeFromParent];
    [projectile runAction:[SKAction sequence:@[actionMove, actionMoveDone]]];
    
    
    projectile.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:projectile.size.width/2];
    projectile.physicsBody.dynamic = YES;
    projectile.physicsBody.categoryBitMask = projectileCategory;
    projectile.physicsBody.contactTestBitMask = monsterCategory;
    projectile.physicsBody.collisionBitMask = 0;
    projectile.physicsBody.usesPreciseCollisionDetection = YES;
    
    nsArray = [TextureHelper getTexturesWithSpriteSheetNamed:@"hamster" withinNode:nil sourceRect:CGRectMake(0, 0, 192, 200) andRowNumberOfSprites:2 andColNumberOfSprites:7 sequence:@[@7,@8,@0,@1,@2]];
    
    monsterAnimation = [SKAction animateWithTextures:nsArray timePerFrame:0.1];
    [player runAction:monsterAnimation];
}

- (void)setCloudClearNumNodeText {
    cloudClearedNumNode.text = [NSString stringWithFormat:@"%d", answerCorrectNUm];
    cloudClearedNumNode.position = CGPointMake(cloudClearedNode.position.x + cloudClearedNode.size.width + cloudClearedNumNode.frame.size.width/2, cloudClearedNumNode.position.y);
}

- (void)resetQusetion {
    for(Cloud * cloud in clouds){
        [cloud removeFromParent];
    }
    [clouds removeAllObjects];
    [self createQuestion];
}

- (void)reset {
    answerCorrectNUm = 0;
    [self setCloudClearNumNodeText];
    
    [self resetQusetion];
}

- (void)didBeginContact:(SKPhysicsContact *)contact {
    [self handleContact:contact];
}

- (void)handleContact:(SKPhysicsContact *)contact {
    NSLog(@"contact");
    
    SKPhysicsBody *firstBody, *secondBody;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    } else {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    if ((firstBody.categoryBitMask == projectileCategory) && (secondBody.categoryBitMask == monsterCategory)) {
        NSLog(@"will do didCollideWithMonster");
        [self projectile:(SKSpriteNode *) firstBody.node didCollideWithMonster:(SKSpriteNode *) secondBody.node];
    }
}

- (void)projectile:(Bullet *)projectile didCollideWithMonster:(Cloud *)cloud {
    if (projectile.hidden || cloud.hidden || projectile == nil || cloud == nil) {
        return;
    }
    
    NSLog(@"Hit");
    
    projectile.hidden = true;
    [projectile removeFromParent];
    
    [cloud removeFromParent];
    [clouds removeObject:cloud];
    
    if (self.gameMode == TIME_LIMIT_MODE) {
        if (!questionNode.hidden) {
            answar = answars[0];
            if(cloud.num == answar){
                questionNode.hidden = YES;
            }
        } else if(!questionNode2.hidden) {
            answar = answars[1];
            if(cloud.num == answar){
                questionNode2.hidden = YES;
            }
        } else {
            answar = answars[2];
            if(cloud.num == answar){
                questionNode3.hidden = YES;
            }
        }
        if (cloud.num == answar) {
            answerCorrectNUm++;
            [self setCloudClearNumNodeText];

            if(questionNode.hidden&&questionNode2.hidden&&questionNode3.hidden){
                questionNode.hidden = NO;
                questionNode2.hidden = NO;
                questionNode3.hidden = NO;
                [self resetQusetion];
            }
        }
    } else if(self.gameMode == BREAK_GAME_MODE) {
        if (cloud.num == answars[correctAnswarIndex]) {
            answerCorrectNUm++;
            [self setCloudClearNumNodeText];
            [self resetQusetion];
        } else {
            [theGameTimer invalidate];
            gameTime = 0;
            [self setGameRun:false];
            answerCorrectNUm = 0;
            [self.gameDelegate showGameOver];
        }
    } else if(self.gameMode == INFINITY_MODE) {
        if (cloud.num == answars[correctAnswarIndex]) {
            answerCorrectNUm++;
            [self setCloudClearNumNodeText];
            [[NSUserDefaults standardUserDefaults] setInteger:answerCorrectNUm forKey:@"score"];
            [self reportInfinityModeScore];
            [self resetQusetion];
        }
    }
}

- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast {
    if(!isGameRun)
        return;
    
    self.lastSpawnTimeInterval += timeSinceLast;
    self.lastSpawnMoveTimeInterval += timeSinceLast;
    self.lastSpawnShootTimeInterval += timeSinceLast;
    
    if(self.lastSpawnMoveTimeInterval > 0.1){
        self.lastSpawnMoveTimeInterval = 0;
        if (willChangeGameMode != NONE_MODE) {
            self.gameMode = willChangeGameMode;
            switch (self.gameMode) {
                case INFINITY_MODE:
                    [self changeToInfiniteMode];
                    break;
                case BREAK_GAME_MODE:
                    [self changeToBreakGameMode];
                    break;
                case TIME_LIMIT_MODE:
                    [self changeToTimeLimitMode];
                    break;
                default:
                    break;
            }
            willChangeGameMode = NONE_MODE;
            return;
        }
        [self checkAndMoveClouds];
        
    }
    
    if (self.lastSpawnShootTimeInterval > 0.5) {
        self.lastSpawnShootTimeInterval = 0;
        if(isShootEnable){
            [self shoot];
            isShootEnable = false;
        }
    }
    
    if (self.lastSpawnTimeInterval > 2.0) {
        self.lastSpawnTimeInterval = 0;
        
        [self checkAndRemoveCloud];
        [self checkAndCreateAnswer];
        [self checkAndCreateCloud];
        
        if (!isMoveBar) {
            hintAppearingTimerCounter++;
            if (hintAppearingTimerCounter > 3) {
                hintAppearingTimerCounter = 0;
                [self showHint];
            }
        }
    }
}

- (void)update:(CFTimeInterval)currentTime {
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;
    if (timeSinceLast > 1) {
        timeSinceLast = 1.0 / 60.0;
        self.lastUpdateTimeInterval = currentTime;
    }
    
    [self updateWithTimeSinceLastUpdate:timeSinceLast];
}

- (void)setModeByGameMode {
    if (self.gameMode == INFINITY_MODE) {
        [self initInfiniteMode];
    } else if (self.gameMode == BREAK_GAME_MODE) {
        [self initBreakGameMode];
    } else if (self.gameMode == TIME_LIMIT_MODE) {
        [self initTimeLimitMode];
    }
}

- (void)initInfiniteMode {
    answerCorrectNUm = [[NSUserDefaults standardUserDefaults] integerForKey:@"score"];
    [self setCloudClearNumNodeText];
    
    questionNode2.hidden = YES;
    questionNode3.hidden = YES;
    [self createQuestion];
}

- (void)initBreakGameMode {
    questionNode2.hidden =YES;
    questionNode3.hidden = YES;
    [self createQuestion];
    [self initGameTimer];
}

- (void)initTimeLimitMode {
    questionNode2.hidden = NO;
    questionNode3.hidden = NO;
    [self createQuestion];
    [self initGameTimer];
}

- (void)changeToInfiniteMode {
    gameTimeNode.hidden = YES;
    self.gameMode = INFINITY_MODE;
    [self reset];
    answerCorrectNUm = [[NSUserDefaults standardUserDefaults] integerForKey:@"score"];
    [self setCloudClearNumNodeText];
    questionNode2.hidden = YES;
    questionNode3.hidden = YES;
    [self createQuestion];
}

- (void)changeToBreakGameMode {
    gameTimeNode.hidden = NO;
    self.gameMode = BREAK_GAME_MODE;
    [self reset];
    questionNode2.hidden = YES;
    questionNode3.hidden = YES;
    [self createQuestion];
    [self initGameTimer];
}

- (void)changeToTimeLimitMode {
    gameTimeNode.hidden = NO;
    self.gameMode = TIME_LIMIT_MODE;
    [self reset];
    questionNode2.hidden = NO;
    questionNode3.hidden = NO;
    [self createQuestion];
    [self initGameTimer];
}

- (void)initGameTimer {
    if (theGameTimer != nil) {
        [theGameTimer invalidate];
        gameTime = 0;
        if (self.gameMode == BREAK_GAME_MODE) {
            [self setGameTimeNodeText: gameTime];
        } else if (self.gameMode == TIME_LIMIT_MODE) {
            [self setGameTimeNodeText: maxTime - gameTime];
        }
    }
    theGameTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                    target:self
                                                  selector:@selector(countGameTime)
                                                  userInfo:nil
                                                   repeats:YES];
}

- (void)countGameTime {
    if(!isGameRun){
        return;
    }
    
    gameTime++;
    
    if(self.gameMode == BREAK_GAME_MODE){
        if(answerCorrectNUm==GAME_LEVEL2_START_LEVEL){
            cloudMoveSpeed = CLOUD_LEVEL2_MOVE_SPEED;
        }else if(answerCorrectNUm==GAME_LEVEL3_START_LEVEL){
            cloudMoveSpeed = CLOUD_LEVEL3_MOVE_SPEED;
        }else if(answerCorrectNUm==GAME_LEVEL4_START_LEVEL){
            cloudMoveSpeed = CLOUD_LEVEL4_MOVE_SPEED;
        }else if(answerCorrectNUm==GAME_LEVEL5_START_LEVEL){
            cloudMoveSpeed = CLOUD_LEVEL5_MOVE_SPEED;
        }
        [self setGameTimeNodeText:gameTime];
        
        if (answerCorrectNUm >= GAME_SUCCESS_LEVEL) {
            [theGameTimer invalidate];
            [self setGameRun:false];
            [self reportBreakGameModeScore];
            [self.gameDelegate showGameWin];
            gameTime = 0;
        }
    } else if(self.gameMode == TIME_LIMIT_MODE) {
        [self setGameTimeNodeText: maxTime - gameTime];
        
        if (maxTime - gameTime==0) {
            [theGameTimer invalidate];
            gameTime = 0;
            [self setGameRun:false];
            [self reportTimeLimitModeScore];
            [self.gameDelegate showGameOver];
        }
    }
}

- (void)setGameTimeNodeText:(int)time {
    gameTimeNode.text = [CommonUtil timeFormatted:time];
    gameTimeNode.position = CGPointMake(self.frame.size.width-gameTimeNode.frame.size.width/2, self.frame.size.height-gameTimeNode.frame.size.height - 50);
}

- (void)reportInfinityModeScore {
    GameCenterUtil *gameCenterUtil = [GameCenterUtil sharedInstance];
    [gameCenterUtil reportScore:answerCorrectNUm forCategory:@"ShootLearningInfinityLeaderBoard"];
}

- (void)reportBreakGameModeScore {
    GameCenterUtil *gameCenterUtil = [GameCenterUtil sharedInstance];
    [gameCenterUtil reportScore:gameTime forCategory:@"ShootLearningBreakGameLeaderBoard"];
}

- (void)reportTimeLimitModeScore {
    GameCenterUtil *gameCenterUtil = [GameCenterUtil sharedInstance];
    [gameCenterUtil reportScore:answerCorrectNUm forCategory:@"ShootLearningTimeLimitLeaderBoard"];
}

- (void)beHited {
    isGameRun = false;
    GameCenterUtil * gameCenterUtil = [GameCenterUtil sharedInstance];
    [gameCenterUtil reportScore:gameTime forCategory:@"QuteDodgeLeaderBoard"];
    [self.gameDelegate showGameOver];
}

- (void)setGameRun:(bool)isrun {
    [self setViewRun:isrun];
    [self setPauseBtnHidden:isrun];
}

- (void)setPauseBtnHidden:(bool)isrun {
    pauseBtnNode.hidden = isrun;
}

- (void)setViewRun:(bool)isrun {
    isGameRun = isrun;
    
    for (int i = 0; i < [self children].count; i++) {
        SKNode * n = [self children][i];
        n.paused = !isrun;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        willChangeGameMode = INFINITY_MODE;
    } else if(buttonIndex == 1) {
        willChangeGameMode = BREAK_GAME_MODE;
    } else if(buttonIndex==2) {
        willChangeGameMode = TIME_LIMIT_MODE;
    }
}

- (int)getAnswerCorrectNUm {
    return answerCorrectNUm;
}

- (int)getGameTime {
    return gameTime;
}

- (void)setWillChangeGameMode:(int)_willChangeGameMode {
    willChangeGameMode = _willChangeGameMode;
}

@end
