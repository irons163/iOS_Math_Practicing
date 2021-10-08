//
//  MyUtils.m
//  Try_Cat_Shoot
//
//  Created by irons on 2015/4/21.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import "MyUtils.h"
#import <AVFoundation/AVFoundation.h>

@implementation MyUtils

AVAudioPlayer *backgroundMusicPlayer;

+ (void)preparePlayBackgroundMusic:(NSString *)filename {
    NSError *error;
    NSURL *url = [[NSBundle mainBundle] URLForResource:filename withExtension:@"mp3"];
    if (url == nil) {
        NSDataAsset *data = [[NSDataAsset alloc] initWithName:filename];
        if (data == nil) {
            NSLog(@"Could not find file:%@", filename);
            return;
        }
        
        backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithData:data.data error:&error];
    } else {
        backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    }
    
    if (backgroundMusicPlayer == nil) {
        NSLog(@"Could not create audio player:%@",error);
        return;
    }
    
    backgroundMusicPlayer.numberOfLoops = -1;
    [backgroundMusicPlayer prepareToPlay];
}

+ (void)playBackgroundMusic:(NSString *)filename {
    NSURL *url = [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
    
    if (url == nil) {
        NSLog(@"Could not find file:%@",filename);
        return;
    }
    
    NSError *error;
    backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    
    if (backgroundMusicPlayer == nil) {
        NSLog(@"Could not create audio player:%@",error);
        return;
    }
    
    backgroundMusicPlayer.numberOfLoops = -1;
    [backgroundMusicPlayer prepareToPlay];
    [backgroundMusicPlayer play];
}

+ (void)backgroundMusicPlayerStop {
    [backgroundMusicPlayer stop];
}

+ (void)backgroundMusicPlayerPause {
    [backgroundMusicPlayer pause];
}

+ (void)backgroundMusicPlayerPlay {
    [backgroundMusicPlayer play];
}

+ (BOOL)isBackgroundMusicPlayerPlaying {
    return [backgroundMusicPlayer isPlaying];
}

@end
