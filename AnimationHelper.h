//
//  AnimationHelper.h
//  ours
//
//  Created by Dante Fan on 11/3/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "CCSprite.h"
#import "CCAnimation.h"
@interface AnimationHelper : CCSprite {
    
}
+(CCAnimation *)animationWithPrefix:(NSString *)prefix startFrameIdx:(unsigned int)startFrameIdx frameCount:(unsigned int)frameCount delay:(float)delay;
@end
