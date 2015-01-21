//
//  Pig.m
//  PeevedPenguins
//
//  Created by Dante Fan on 9/18/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Pig.h"

@implementation Pig
- (void)didLoadFromCCB
{
    self.physicsBody.collisionType = @"Pig";
}
@end
