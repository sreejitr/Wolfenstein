//
//  TutorialGameplay.m
//  Wolfenstein
//
//  Created by Sreejita Ray on 4/15/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "TutorialGameplay.h"
#import "Level.h"
#import "Wolfe.h"
#import "DeadBunny.h"
#import "WinPopUp.h"
#import "CCActionFollow+CurrentOffset.h"
#import "MenuLayer.h"
#import "GameState.h"
#import "SceneManager.h"


static NSString *thisLevel = @"Level0";

@implementation TutorialGameplay {
    CCNode *_levelNode;
    Level *_loadedLevel;
    Wolfe *_wolfe;
    DeadBunny *_bunny;
    CCLabelTTF *_instructions;
    CCLabelTTF *_score;
    CGPoint touchBeganLocation;
    CGPoint touchMovedLocation;
    BOOL wolfeAttackEnable;
    BOOL crouchCombo;
    int points;
    int numOfHits;
    WinPopUp *popup;
    CCAction *_followWolfe;
    BOOL wolfe_jumped;
    BOOL facingeachother;
    BOOL rightface;
    BOOL swiped_left;
    BOOL swiped_right;
    BOOL swiped_down;
    BOOL jumped_up;
    BOOL jumped_left;
    BOOL jumped_right;
}

- (void)didLoadFromCCB {
    _physicsNode.collisionDelegate = self;
    _instructions.string = [NSString stringWithFormat:@"Tap anywhere on the screen to hit Dead Bunny"];
    _instructions.visible = true;
    [self showScore];
    points = 0;
    _score.visible = true;
    numOfHits = 0;
    wolfe_jumped = FALSE;
    facingeachother = true;
    rightface = TRUE;
    swiped_left = FALSE;
    swiped_right = FALSE;
    jumped_up = FALSE;
    jumped_left = FALSE;
    jumped_right = FALSE;
    swiped_down = FALSE;
    _loadedLevel = (Level *) [CCBReader load:thisLevel owner:self];
    [_levelNode addChild:_loadedLevel];
    self.userInteractionEnabled = TRUE;
    _wolfe = (Wolfe*)[CCBReader load:@"Wolfe"];
    _bunny = (DeadBunny*)[CCBReader load:@"DeadBunny"];
    [_physicsNode addChild:_wolfe];
    [_physicsNode addChild:_bunny];
    CGPoint offsetFromParentCenter = CGPointMake(200, 130);
    _wolfe.position = CGPointMake(self.contentSize.width * self.anchorPoint.x + offsetFromParentCenter.x,
                                  self.contentSize.height * self.anchorPoint.y + offsetFromParentCenter.y);
    offsetFromParentCenter = CGPointMake(340, 140);
    _bunny.position = CGPointMake(self.contentSize.width * self.anchorPoint.x + offsetFromParentCenter.x,
                                  self.contentSize.height * self.anchorPoint.y + offsetFromParentCenter.y);
    CCActionFollow *followWolfe = [CCActionFollow actionWithTarget:_wolfe worldBoundary:[_loadedLevel boundingBox]];
    _physicsNode.position = [followWolfe currentOffset];
    [_physicsNode runAction:followWolfe];
}

- (void)onEnter {
    [super onEnter];

}

- (void)loadNextLevel {
    [SceneManager presentGameplayScene];
}

-(void) touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    if (numOfHits < 4 && fabs(_wolfe.position.x - _bunny.position.x) <= 140 && !wolfe_jumped) {
        [self wolfeAttackBegan];
        _instructions.string = [NSString stringWithFormat:@"Thats awesome!! Now hit Dead Bunny 3 times.."];
        _instructions.visible = true;
        crouchCombo = FALSE;
    } else {
        touchBeganLocation = [touch locationInNode:self];
    }
}

- (void)touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    if (numOfHits >= 4) {
        touchMovedLocation = [touch locationInNode:self.parent];
        if ((touchMovedLocation.y - touchBeganLocation.y > 50) && (touchBeganLocation.x - touchMovedLocation.x > 50) && !wolfe_jumped && !jumped_left && swiped_left && swiped_right && jumped_right && swiped_down && jumped_up) {
            [self jumpLeft];
        } else if ((touchBeganLocation.x - touchMovedLocation.x > 50) && (_wolfe.position.x - 20 > _loadedLevel.boundingBox.origin.x + 90) && !wolfe_jumped) {
            [self walkLeft];
        }
        
        if ((touchMovedLocation.y - touchBeganLocation.y > 50) && (touchMovedLocation.x - touchBeganLocation.x > 50) && ((_wolfe.position.x + 200) < (_loadedLevel.boundingBox.size.width - _wolfe.boundingBox.size.width)) && !wolfe_jumped && !jumped_right && swiped_left && swiped_right && swiped_down && jumped_up) {
            [self jumpRight];
        } else if ((touchMovedLocation.x - touchBeganLocation.x > 50) && (_wolfe.position.x + 20 < (_loadedLevel.boundingBox.size.width - 90)) && !wolfe_jumped && swiped_left) {
            [self walkRight];
        }
        
        if ((touchMovedLocation.y - touchBeganLocation.y > 50) && !wolfe_jumped && !jumped_up && swiped_left && swiped_right && swiped_down) {
            [self jumpUp];
        }
        
        if (touchBeganLocation.y - touchMovedLocation.y > 50 && !swiped_down && swiped_left && swiped_right) {
            wolfeAttackEnable = TRUE;
            crouchCombo = TRUE;
            [self wolfeAttackBegan];
        } else {
            wolfeAttackEnable = false;
        }
    }
    _followWolfe = [CCActionFollow actionWithTarget:_wolfe worldBoundary:self.boundingBox];
    [_levelNode runAction:_followWolfe];

}

-(void) touchEnded:(CCTouch*)touch withEvent:(CCTouchEvent *)event{

}


- (void)walkRight {
    if ((_wolfe.position.x + 70) < (_bunny.position.x - 95) || (_wolfe.position.x > _bunny.position.x)) {
        _wolfe.flipX=NO;
        if (swiped_right == FALSE) {
            swiped_right = TRUE;
            points += 500;
        }
        [_wolfe walk];
        points += 500;
        id moveRight = [CCActionMoveBy actionWithDuration:0.10 position:ccp(20, 0)];
        [_wolfe runAction:moveRight];
        facingeachother = FALSE;
        [self performSelector:@selector(wolfe_idle) withObject:nil afterDelay:0.5f];
    }
}

- (void)walkLeft {
    if (((_wolfe.position.x - _wolfe.contentSizeInPoints.width/2 - 20) > (_bunny.position.x + _bunny.contentSizeInPoints.width/2 - 5)) || (_wolfe.position.x < _bunny.position.x)) {
        _wolfe.flipX=YES;
        if (swiped_left == FALSE) {
            swiped_left = TRUE;
            points += 500;
        }
        [_wolfe walk];
        id moveLeft = [CCActionMoveBy actionWithDuration:0.10 position:ccp(-20, 0)];
        [_wolfe runAction:moveLeft];
        facingeachother = FALSE;
        [self performSelector:@selector(wolfe_idle) withObject:nil afterDelay:0.5f];
    }
}

-(void)jumpUp {
    self.userInteractionEnabled = FALSE;
    [_wolfe jumpflip];
    id jumpUp = [CCActionJumpBy actionWithDuration:0.7f position:ccp(0, 200)
                                            height:50 jumps:1];
    id jumpDown = [CCActionJumpBy actionWithDuration:0.7f position:ccp(0,-80)
                                              height:50 jumps:1];
    
    id seq = [CCActionSequence actions:jumpUp, jumpDown, nil];
    
    [_wolfe runAction:seq];
    [self performSelector:@selector(wolfe_idle) withObject:nil afterDelay:0.5f];
    wolfe_jumped = TRUE;
    if(jumped_up == FALSE) {
        jumped_up = TRUE;
        points += 500;
    }
    [self performSelector:@selector(resetJump) withObject:nil afterDelay:2.f];
    _wolfe.physicsBody.velocity = CGPointMake(0, 0);
}

-(void)jumpLeft {
    self.userInteractionEnabled = FALSE;
    _wolfe.flipX=YES;
    [_wolfe jumpflip];
    id jumpUp = [CCActionJumpBy actionWithDuration:0.7f position:ccp(-1*_wolfe.position.x, 200)
                                            height:50 jumps:1];
    id jumpDown = [CCActionJumpBy actionWithDuration:0.7f position:ccp(-1*_wolfe.position.x,-80)
                                              height:50 jumps:1];
    
    id seq = [CCActionSequence actions:jumpUp, jumpDown, nil];
    
    [_wolfe runAction:seq];
    facingeachother = FALSE;
    [self performSelector:@selector(wolfe_idle) withObject:nil afterDelay:2.f];
    wolfe_jumped = TRUE;
    if(jumped_left == FALSE) {
        jumped_left = TRUE;
        points += 500;
    }
    [self performSelector:@selector(resetJump) withObject:nil afterDelay:2.5f];
    _wolfe.physicsBody.velocity = CGPointMake(0, 0);
}

-(void)jumpRight {
    self.userInteractionEnabled = FALSE;
    [_wolfe jumpflip];
    id jumpUp = [CCActionJumpBy actionWithDuration:0.7f position:ccp(300, 200)
                                            height:50 jumps:1];
    id jumpDown = [CCActionJumpBy actionWithDuration:0.3f position:ccp(300,-80)
                                              height:50 jumps:1];
    
    id seq = [CCActionSequence actions:jumpUp, jumpDown, nil];
    
    [_wolfe runAction:seq];
    facingeachother = FALSE;
    [self performSelector:@selector(wolfe_idle) withObject:nil afterDelay:1.5f];
    wolfe_jumped = TRUE;
    if(jumped_right == FALSE) {
        jumped_right = TRUE;
        points += 500;
    }
    [self performSelector:@selector(resetJump) withObject:nil afterDelay:2.5f];
    _wolfe.physicsBody.velocity = CGPointMake(0, 0);
    
}

- (void)resetJump {
    wolfe_jumped = FALSE;
    self.userInteractionEnabled = TRUE;
    [self flip_handle];
}

- (void)flip_handle {
    float wolfeXcoordRight = _wolfe.boundingBox.origin.x + _wolfe.boundingBox.size.width;
    float wolfeXcoordLeft = _wolfe.boundingBox.origin.x;
    float bunnyXcoordRight = _bunny.boundingBox.origin.x + _bunny.boundingBox.size.width;
    float bunnyXcoordLeft = _bunny.boundingBox.origin.x;
    if (wolfeXcoordRight < bunnyXcoordLeft) {
        rightface = TRUE;
        _wolfe.flipX=NO;
        _bunny.flipX=NO;
    }
    else if (wolfeXcoordLeft > bunnyXcoordRight) {
        rightface = FALSE;
        _wolfe.flipX=YES;
        _bunny.flipX=YES;
    }
}

- (void)wolfe_idle {
    [_wolfe idle];
    [self flip_handle];
    facingeachother = TRUE;
}


-(void)update:(CCTime)delta
{
    if (_wolfe.position.x < _loadedLevel.positionInPoints.x + 70) {
        _wolfe.position = ccp(_loadedLevel.positionInPoints.x + 60, _wolfe.position.y);
    }
    if (_wolfe.position.x > _loadedLevel.contentSizeInPoints.width - 60) {
        _wolfe.position = ccp(_loadedLevel.contentSizeInPoints.width - 60, _wolfe.position.y);
    }
    if (fabsf(_wolfe.position.x - _bunny.position.x) <= 180 && !wolfe_jumped) {
        _wolfe.color = [CCColor colorWithRed:1. green:0.7 blue:0.7];
    } else {
       _wolfe.color = [CCColor colorWithRed:1. green:1 blue:1];
    }
    
    [self showScore];
    if (numOfHits >= 4) {
        if (!swiped_left) {
            _instructions.fontSize = 15;
            _instructions.string = [NSString stringWithFormat:@"Nicely done! Now swipe left to move away from Dead Bunny"];
            _instructions.visible = true;
        } else if (!swiped_right) {
            _instructions.fontSize = 13;
            _instructions.string = [NSString stringWithFormat:@"Excellent! You have now moved away from the attack zone. Now swipe right to move back towards Dead Bunny."];
            _instructions.visible = true;
        } else if (!swiped_down) {
            _instructions.fontSize = 13;
            _instructions.string = [NSString stringWithFormat:@"Perfect! You are now back in the attack zone. Notice how Wolfe's reddish tinge has returned. Now swipe down for Crouch-Combo attack"];
            _instructions.visible = true;
        } else if (!jumped_up) {
            _instructions.fontSize = 18;
            _instructions.string = [NSString stringWithFormat:@"You're doing great! Now swipe up to jump"];
            _instructions.visible = true;
        } else if (!jumped_right) {
            _instructions.string = [NSString stringWithFormat:@"Swipe diagonally from bottom-left to top-right to jump and move right"];
            _instructions.fontSize = 15;
            _instructions.visible = true;
        } else if (!jumped_left) {
            _instructions.string = [NSString stringWithFormat:@"Swipe diagonally from bottom-right to top-left to jump and move left"];
            _instructions.fontSize = 15;
            _instructions.visible = true;
        }
        if (swiped_left && swiped_right && swiped_down && jumped_up && jumped_right && jumped_left) {
            [self performSelector:@selector(winScreen) withObject:nil afterDelay:1.9f];
        }
    }
    
}

-(void) wolfeAttackBegan {
    self.userInteractionEnabled = FALSE;
    if (crouchCombo) {
        [_wolfe crouchcombo];
        [_bunny hit];
        if (swiped_down == FALSE) {
            swiped_down = TRUE;
            points += 1000;
        }
        crouchCombo = FALSE;
    } else {
        [_wolfe attack];
        [_bunny hit];
        points += 500;
    }
    numOfHits += 1;
    [self showScore];
    [self performSelector:@selector(turnoff_wolfe_attack) withObject:nil afterDelay:1.9f];
    
}

-(void) turnoff_wolfe_attack {
    self.userInteractionEnabled = TRUE;
}

- (void)showScore
{
    _score.string = [NSString stringWithFormat:@"Score: %d", points];
    _score.visible = true;
}

- (void)winScreen {
    [self levelInfoDidChange];
    popup = (WinPopUp *)[CCBReader load:@"WinPopUp3star" owner:self];
    popup._scoreLabel.string = [NSString stringWithFormat:@"Score: %d", points];
    popup._winPopUpLabel.string = [NSString stringWithFormat:@"Congratulations!! You have cleared this level!!"];
    popup._winPopUpLabel.fontSize = 20;
    popup._winPopUpLabel.dimensions = CGSizeMake(180,100);
    CGPoint offsetFromParentCenter = CGPointMake(10, 70);
    popup._winPopUpLabel.position = CGPointMake(self.contentSize.width * self.anchorPoint.x + offsetFromParentCenter.x,
                                  self.contentSize.height * self.anchorPoint.y + offsetFromParentCenter.y);
    popup.positionType = CCPositionTypeNormalized;
    popup.position = ccp(0.5, 0.5);
    [_wolfe stopAllActions];
    [_bunny stopAllActions];
    [self addChild:popup];
}

-(void) levelInfoDidChange
{
    NSString *highestUnlockedLevel = [GameState sharedGameState].highestUnlockedLevel;
    NSString *levelnumber = [highestUnlockedLevel substringFromIndex: [highestUnlockedLevel length] - 1];
    int level = levelnumber.intValue;
    int currentLevel = [thisLevel substringFromIndex: [thisLevel length] - 1].intValue;
    if (currentLevel == 0) {
        [GameState sharedGameState].scoreLevel0 = points;
        if ([GameState sharedGameState].highestScoreLevel0 < points) {
            [GameState sharedGameState].highestScoreLevel0 = points;
        }
    }
    if (level == currentLevel) {
        [GameState sharedGameState].highestUnlockedLevel = @"LevelStart1";
    }
    
}

@end
