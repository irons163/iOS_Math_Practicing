//
//  TextureHelper.h
//  Try_Cat_Shoot
//
//  Created by irons on 2015/3/23.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface TextureHelper : NSObject

+ (NSArray *)cat1Textures;
+ (NSArray *)cat2Textures;
+ (NSArray *)cat3Textures;
+ (NSArray *)cat4Textures;
+ (NSArray *)cat5Textures;

+ (SKTexture *)hamsterInjureTexture;
+ (SKTexture *)gestureHintTexture;

+ (NSArray *)timeTextures;

+ (NSArray *)timeImages;

+ (id)getTexturesWithSpriteSheetNamed:(NSString *)spriteSheet withinNode:(SKSpriteNode *)scene sourceRect:(CGRect)source andRowNumberOfSprites:(int)rowNumberOfSprites andColNumberOfSprites:(int)colNumberOfSprites;
+ (id)getTexturesWithSpriteSheetNamed: (NSString *) spriteSheet withinNode: (SKSpriteNode *) scene sourceRect:(CGRect)source andRowNumberOfSprites:(int)rowNumberOfSprites andColNumberOfSprites:(int)colNumberOfSprites sequence:(NSArray*)positions;
+ (void)initTextures;

@end
