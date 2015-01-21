//
//  MainScene.m
//  PeevedPenguins
//
//  Created by Benjamin Encz on 16/01/14.
//  Copyright (c) 2014 MakeGamesWithUs Inc. Free to use for all purposes.
//

#import "MainScene.h"

@implementation MainScene
{
    OALSimpleAudio *audio;
}

-(void)didLoadFromCCB
{
    audio = [OALSimpleAudio sharedInstance];
    // play background sound
    [audio playBg:@"Mainbg.mp3" loop:TRUE];
}

- (void)play {
    [audio stopEverything];
    CCScene *gameplayScene = [CCBReader loadAsScene:@"Gameplay"];
    [[CCDirector sharedDirector]replaceScene:gameplayScene];
}

@end
