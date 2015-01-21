//
//  Cliff.m
//  PeevedPenguins
//
//  Created by Dante Fan on 9/23/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "Cliff.h"


@implementation Cliff
- (void)didLoadFromCCB
{
    self.physicsBody.collisionType = @"Cliff";
}

@end
