//
//  Gameplay.m
//  Wolfenstein
//
//  Created by Sreejita Ray on 3/19/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Gameplay.h"
#import "Level.h"
#import "Wolfe.h"
#import "Fister.h"
#import "WinPopUp.h"
#import "CCActionFollow+CurrentOffset.h"

static NSString * const kFirstLevel = @"Level1";
static NSString *selectedLevel = @"Level1";


@implementation Gameplay{
    Wolfe *_wolfe;
    Fister *_fister;
    CCPhysicsNode *_physicsNode;
//    CCNode *_contentNode;
    CCNode *_levelNode;
    Level *_loadedLevel;
    CCLabelTTF *_healthLabel;
    CCLabelTTF *_fisterHealth;
    CCLabelTTF *_winPopUpLabel;
    BOOL _jumped;
    double_t timeelapsed;
    int wolfe_hit;
    int fister_hit;
    BOOL wolfe_attack;
    BOOL fister_attack;
    WinPopUp *popup;
    int points;
    int points_fister;
    BOOL _gameOver;
    CCButton *_leftButton;
    CCButton *_rightButton;
    CCButton *_punch;
    CCButton *_jump;
    BOOL rightface;
    CCAction *_followWolfe;
}


#pragma mark - Node Lifecycle

- (void)didLoadFromCCB {
    _physicsNode.collisionDelegate = self;
    _loadedLevel = (Level *) [CCBReader load:selectedLevel owner:self];
    [_levelNode addChild:_loadedLevel];
    self.userInteractionEnabled = TRUE;
    _wolfe = (Wolfe*)[CCBReader load:@"Wolfe"];
    [_physicsNode addChild:_wolfe];
    _wolfe.position = ccp(205, 110);
    rightface = TRUE;
    _fister = (Fister*)[CCBReader load:@"Fister"];
    [_physicsNode addChild:_fister];
    _fister.position = ccp(370, 110);
    wolfe_attack = FALSE;
    fister_attack = FALSE;
    wolfe_hit = 0;
    fister_hit = 0;
    timeelapsed = 0.0f;
    _healthLabel.visible = TRUE;
    _fisterHealth.visible = TRUE;
    points = 100;
    points_fister = 100;
    [self showScore];
    _gameOver = FALSE;
}

- (void)onEnter {
    [super onEnter];
    
    CCActionFollow *follow = [CCActionFollow actionWithTarget:_wolfe worldBoundary:[_loadedLevel boundingBox]];
    _physicsNode.position = [follow currentOffset];
    [_physicsNode runAction:follow];
}

-(void)update:(CCTime)delta
{
    if (_wolfe.position.x > _fister.position.x) {
        rightface = FALSE;
    }
    if (!_gameOver) {
        timeelapsed += delta;
        if (timeelapsed > 2.f) {
        
            if (!wolfe_attack && fabsf(_wolfe.position.x - _fister.position.x) < 200) {
                self.userInteractionEnabled = FALSE;
                fister_attack = TRUE;
                wolfe_hit += 1;
//                points -= 5;
                [self showScore];
                [_fister punch];
                if (points == 0) {
                    [_wolfe hit];
                    [_wolfe groundhit];
                }
                else {
                    [_wolfe hit];
                }
                [self performSelector:@selector(turnoff_fister_attack) withObject:nil afterDelay:2.f];
//                [_wolfe performSelector:@selector(idle) withObject:nil afterDelay:6.f];
//                [_fister performSelector:@selector(idle) withObject:nil afterDelay:6.f];
//                _wolfe.position = ccp(225, 110);
                _fister.position = ccp(420, 130);
            }
            timeelapsed = 0.0f;
            
            
        }
        if (points_fister == 0) {
            
            popup = (WinPopUp *)[CCBReader load:@"WinPopUp" owner:self];
            popup.positionType = CCPositionTypeNormalized;
            popup.position = ccp(0.5, 0.5);
            [_wolfe stopAllActions];
            [_fister stopAllActions];
            [self addChild:popup];
            _gameOver = TRUE;

        }
        if (points == 0) {
            popup = (WinPopUp *)[CCBReader load:@"WinPopUp" owner:self];
            popup.positionType = CCPositionTypeNormalized;
            popup._winPopUpLabel.string = [NSString stringWithFormat:@"You Lose!!"];
            popup.position = ccp(0.5, 0.5);
            [_wolfe stopAllActions];
            [_fister stopAllActions];
            [self addChild:popup];
            _gameOver = TRUE;
        }
    }
}

//- (void)

- (void)showScore
{
    _healthLabel.string = [NSString stringWithFormat:@"Wolfe: %d", points];
    _healthLabel.visible = true;
    _fisterHealth.string = [NSString stringWithFormat:@"Fister: %d", points_fister];
    _fisterHealth.visible = true;
}

-(void) touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    NSLog(@"touch received");

    if (!_gameOver) {
        
        self.userInteractionEnabled = FALSE;
//        NSLog([NSString stringWithFormat:@"Wolfe: %f", _wolfe.position.x]);
//        NSLog([NSString stringWithFormat:@"Fister: %f", _fister.position.x]);
//        NSLog([NSString stringWithFormat:@"diff: %f", fabsf(_wolfe.position.x - _fister.position.x)]);
        if (!fister_attack && fabsf(_wolfe.position.x - _fister.position.x) < 200) {
            wolfe_attack = TRUE;
            [_wolfe attack];
            fister_hit += 1;
            points_fister -= 5;
            [self showScore];
            if (points_fister == 0) {
                [_fister hit];
                [_fister groundhit];
            }
            else {
                [_fister hit];
            }
            
            [self performSelector:@selector(turnoff_wolfe_attack) withObject:nil afterDelay:2.f];
//            [_wolfe performSelector:@selector(idle) withObject:nil afterDelay:6.f];
//            [_fister performSelector:@selector(idle) withObject:nil afterDelay:6.f];
//            _wolfe.position = ccp(205, 110);
            _fister.position = ccp(370, 130);
        }
        else {
            [self wolfe_idle];
            self.userInteractionEnabled = TRUE;
            
        }
    
    }
    
}


-(void) turnoff_wolfe_attack {
    wolfe_attack = FALSE;
    self.userInteractionEnabled = TRUE;
}

-(void) turnoff_fister_attack {
    fister_attack = FALSE;
    self.userInteractionEnabled = TRUE;
}

- (void)touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    // we want to know the location of our touch in this scene
//    [_wolfe stopAllActions];
//    if ccpDistance(lastTouchPoint, location)
    self.userInteractionEnabled = TRUE;
    [_fister idle];
    CGPoint touchLocation = [touch locationInNode:self.parent];
//    if(!CGRectIntersectsRect(_wolfe.boundingBox, _fister.boundingBox)){
    
    if (touchLocation.x < _wolfe.position.x && (_wolfe.position.x - 20 > _loadedLevel.boundingBox.origin.x + 90)){
        _wolfe.flipX=YES;
        _fister.flipX=YES;
        [_wolfe walk];
//        CGSize size = [[CCDirector sharedDirector] viewSize];
        id moveLeft = [CCActionMoveBy actionWithDuration:0.10 position:ccp(-20, 0)];
        [_wolfe runAction:moveLeft];
        [self performSelector:@selector(wolfe_idle) withObject:nil afterDelay:0.5f];
        
    }
    if (touchLocation.x > _wolfe.position.x && (_wolfe.position.x + 20 > (_loadedLevel.boundingBox.origin.x + _loadedLevel.boundingBox.size.width - 90))) {
        _wolfe.flipX=NO;
        _fister.flipX=NO;
        [_wolfe walk];
        id moveLeft = [CCActionMoveBy actionWithDuration:0.10 position:ccp(10, 0)];
        [_wolfe runAction:moveLeft];
        [self performSelector:@selector(wolfe_idle) withObject:nil afterDelay:0.5f];
    }
        _followWolfe = [CCActionFollow actionWithTarget:_wolfe worldBoundary:self.boundingBox];
    [_levelNode runAction:_followWolfe];
    
    NSLog(@"touch move received");
    
    
}

- (void)wolfe_idle {
    float wolfeXcoordRight = _wolfe.boundingBox.origin.x + _wolfe.boundingBox.size.width;
    float wolfeXcoordLeft = _wolfe.boundingBox.origin.x;
    float fisterXcoordRight = _fister.boundingBox.origin.x + _fister.boundingBox.size.width;
    float fisterXcoordLeft = _fister.boundingBox.origin.x;
    if (wolfeXcoordRight < fisterXcoordLeft) {
        rightface = TRUE;
        _wolfe.flipX=NO;
        _fister.flipX=NO;
    }
    else if (wolfeXcoordLeft > fisterXcoordRight) {
        rightface = FALSE;
        _wolfe.flipX=YES;
        _fister.flipX=YES;
    }

    [_wolfe idle];
}

- (void)fister_idle {
    [_fister idle];
}

@end
