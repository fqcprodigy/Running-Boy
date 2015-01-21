//
//  Gameover.m
//  PeevedPenguins
//
//  Created by Dante Fan on 9/29/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "Gameover.h"

extern NSString* deadcause;
extern unsigned long int scores;
@implementation Gameover
{
    CCLabelTTF *dead;
    CCLabelTTF *score;
    OALSimpleAudio *audio;
}
- (void)didLoadFromCCB
{
    self.userInteractionEnabled=YES;
    [dead setString:deadcause];
    audio = [OALSimpleAudio sharedInstance];
    [score setString:[NSString stringWithFormat:@"%lu",scores]];
    [audio playBg:@"Ending.mp3" loop:TRUE];}

- (void)menu
{
    [audio stopEverything];
    CCScene *MenuScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector]replaceScene:MenuScene];
}
@end