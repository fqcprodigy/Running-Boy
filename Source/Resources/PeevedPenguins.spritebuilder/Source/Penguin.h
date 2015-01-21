//
//  Penguin.h
//  PeevedPenguins
//
//  Created by Benjamin Encz on 16/01/14.
//  Copyright (c) 2014 MakeGamesWithUs Inc. Free to use for all purposes.
//

#import "CCSprite.h"

@interface Penguin : CCSprite
{
    @public
    bool onfish;
}

@property (nonatomic, assign) BOOL launched;

@end
