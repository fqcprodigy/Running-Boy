//
//  Fish1.m
//  PeevedPenguins
//
//  Created by Dante Fan on 10/5/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "Fish1.h"


@implementation Fish1
- (void)didLoadFromCCB
{
    self.physicsBody.collisionType = @"Fish1";
    //self.physicsBody.sensor=TRUE;
}
@end
