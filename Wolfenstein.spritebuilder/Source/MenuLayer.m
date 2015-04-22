//
//  MenuLayer.m
//  Wolfenstein
//
//  Created by Sreejita Ray on 4/22/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "MenuLayer.h"
#import "Gameplay.h"

@implementation MenuLayer
- (void)didLoadFromCCB {
    
}

- (void)pauseGame {
    Gameplay* _gameplay = (Gameplay*)self.scene.children.firstObject;
//    [_gameplay showPopoverNamed:@"MenuLayer"];
}
@end
