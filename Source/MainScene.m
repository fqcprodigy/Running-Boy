//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"

@implementation MainScene
- (void)play {
    CCScene *gameplayScene = [CCBReader loadAsScene:@"Scences/GamePlay"];
    [[CCDirector sharedDirector]replaceScene:gameplayScene];
}
- (void)help {
    CCScene *tutorialScene = [CCBReader loadAsScene:@"Scences/Tutorial"];
    [[CCDirector sharedDirector]replaceScene:tutorialScene];
}


@end
