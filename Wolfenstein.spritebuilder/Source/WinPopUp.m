//
//  WinPopUp.m
//  Wolfenstein
//
//  Created by Sreejita Ray on 3/22/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "WinPopUp.h"

@implementation WinPopUp
CCLabelTTF *_winPopUpLabel;

- (void)restart {
    CCScene *gameplayscene = [CCBReader loadAsScene:@"Gameplay"];
    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
    [[CCDirector sharedDirector] presentScene:gameplayscene withTransition:transition];
}

@end
