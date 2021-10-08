//
//  TextureHelper.m
//  Try_Cat_Shoot
//
//  Created by irons on 2015/3/23.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import "TextureHelper.h"

static NSArray *cat1Textures, *cat2Textures, *cat3Textures, *cat4Textures, *cat5Textures;
static SKTexture *hamster_injure, *gesture_hint;
static SKTexture *bg01, *bg02, *bg03, *bg04, *bg05, *bg06, *bg07, *bg08, *bg09, *bg10, *bg11, *bg12, *bg13, *bg14, *bg15;
static SKTexture *time01, *time02, *time03, *time04, *time05, *time06, *time07, *time08, *time09, *time00, *timeQ;
static NSArray *timeScores, *timeScoresImages;

@implementation TextureHelper

SKTexture *temp;

- (void)setHand2Textures:(NSArray *)hand2Textures {
    
}

+ (NSArray *)cat1Textures {
    return cat1Textures;
}

+ (NSArray *)cat2Textures {
    return cat2Textures;
}

+ (NSArray *)cat3Textures {
    return cat3Textures;
}

+ (NSArray *)cat4Textures {
    return cat4Textures;
}

+ (NSArray *)cat5Textures {
    return cat5Textures;
}

+ (SKTexture *)hamsterInjureTexture {
    return hamster_injure;
}

+ (SKTexture *)gestureHintTexture {
    return gesture_hint;
}

+ (NSArray *)timeTextures {
    return timeScores;
}

+ (NSArray *)timeImages {
    return timeScoresImages;
}

+ (id)getTexturesWithSpriteSheetNamed:(NSString *)spriteSheet withinNode:(SKSpriteNode *)scene sourceRect:(CGRect)source andRowNumberOfSprites:(int)rowNumberOfSprites andColNumberOfSprites:(int) colNumberOfSprites {
    NSMutableArray *mAnimatingFrames = [NSMutableArray array];
    
    SKTexture  *ssTexture = [SKTexture textureWithImageNamed:spriteSheet];

    ssTexture.filteringMode = SKTextureFilteringNearest;
    
    float sx = source.origin.x;
    float sy = source.origin.y;
    float sWidth = source.size.width;
    float sHeight = source.size.height;
    
    // IMPORTANT: textureWithRect: uses 1 as 100% of the sprite.
    // This is why division from the original sprite is necessary.
    // Also why sx is incremented by a fraction.
    
    for (int i = 0; i < rowNumberOfSprites*colNumberOfSprites; i++) {
        CGRect cutter = CGRectMake(sx, sy, sWidth/ssTexture.size.width, sHeight/ssTexture.size.height);
        temp = [SKTexture textureWithRect:cutter inTexture:ssTexture];
        [mAnimatingFrames addObject:temp];

        sx+=sWidth/ssTexture.size.width;
        
        if ((i + 1) % colNumberOfSprites == 0) {
            sx = source.origin.x;
            sy += sHeight / ssTexture.size.height;
        }
    }
    
    return mAnimatingFrames;
}

+ (id)getTexturesWithSpriteSheetNamed:(NSString *)spriteSheet withinNode:(SKSpriteNode *)scene sourceRect:(CGRect)source andRowNumberOfSprites:(int)rowNumberOfSprites andColNumberOfSprites:(int) colNumberOfSprites sequence:(NSArray *)positions {
    NSMutableArray *mAnimatingFrames = [NSMutableArray array];
    
    UIImage *myImage = [UIImage imageNamed:spriteSheet];
    
    SKTexture *ssTexture = [SKTexture textureWithImage:myImage];
    
    ssTexture.filteringMode = SKTextureFilteringNearest;
    
    float sx = source.origin.x;
    float sy = source.origin.y;
    float sWidth = source.size.width;
    float sHeight = source.size.height;
    
    for (int i = 0; i < rowNumberOfSprites*colNumberOfSprites; i++) {
        CGRect cutter = CGRectMake(sx, sy, sWidth/ssTexture.size.width, sHeight/ssTexture.size.height);
        SKTexture *temp = [SKTexture textureWithRect:cutter inTexture:ssTexture];
        [mAnimatingFrames addObject:temp];
        
        sx+=sWidth/ssTexture.size.width;
        
        if ((i+1) % colNumberOfSprites == 0) {
            sx=source.origin.x;
            sy+=sHeight/ssTexture.size.height;
        }
    }
    
    NSMutableArray * array = [NSMutableArray array];
    
    for (int i = 0; i < positions.count; i++) {
        int sequencePosition = [positions[i] intValue];
        [array addObject: mAnimatingFrames[sequencePosition]];
    }
    
    return array;
}

+ (void)initTextures {
    hamster_injure = [SKTexture textureWithImageNamed:@"hamster_injure"];
    gesture_hint = [SKTexture textureWithImageNamed:@"row-2-column-2"];
    
    time01 = [SKTexture textureWithImageNamed:@"s1"];
    time02 = [SKTexture textureWithImageNamed:@"s2"];
    time03 = [SKTexture textureWithImageNamed:@"s3"];
    time04 = [SKTexture textureWithImageNamed:@"s4"];
    time05 = [SKTexture textureWithImageNamed:@"s5"];
    time06 = [SKTexture textureWithImageNamed:@"s6"];
    time07 = [SKTexture textureWithImageNamed:@"s7"];
    time08 = [SKTexture textureWithImageNamed:@"s8"];
    time09 = [SKTexture textureWithImageNamed:@"s9"];
    time00 = [SKTexture textureWithImageNamed:@"s0"];
    timeQ = [SKTexture textureWithImageNamed:@"dot"];
    
    timeScores = @[time00, time01, time02, time03, time04, time05,time06, time07, time08, time09, timeQ];
    
    UIImage *image01 = [UIImage imageNamed:@"s1"];
    UIImage *image02 = [UIImage imageNamed:@"s2"];
    UIImage *image03 = [UIImage imageNamed:@"s3"];
    UIImage *image04 = [UIImage imageNamed:@"s4"];
    UIImage *image05 = [UIImage imageNamed:@"s5"];
    UIImage *image06 = [UIImage imageNamed:@"s6"];
    UIImage *image07 = [UIImage imageNamed:@"s7"];
    UIImage *image08 = [UIImage imageNamed:@"s8"];
    UIImage *image09 = [UIImage imageNamed:@"s9"];
    UIImage *image00 = [UIImage imageNamed:@"s0"];
    UIImage *imageQ = [UIImage imageNamed:@"dot"];
    timeScoresImages = @[image00, image01, image02, image03, image04, image05, image06, image07, image08, image09, imageQ];
}

@end
