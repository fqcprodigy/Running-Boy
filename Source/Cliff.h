//
//  Cliff.h
//  ours
//
//  Created by Dante Fan on 10/16/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "CCSprite.h"
@interface Cliff : CCSprite {
    
}
@property(nonatomic, strong)id disappearAction;
@property(nonatomic, strong)id hitAction;


- (void)destroy;
-(void) hitplayer;
@end
