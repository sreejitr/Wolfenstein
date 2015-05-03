#import "MainScene.h"
#import "SceneManager.h"
#import "Fister.h"
#import "MenuLayer.h"
#import "GameState.h"


static NSString *currentLevelStart = @"LevelStart0";

@implementation MainScene {
   __weak Fister *_fister;
    MenuLayer *_popoverMenuLayer;
    MenuLayer* newMenuLayer;
}

- (void)didLoadFromCCB {
    _fister.color = [CCColor colorWithRed:0.3 green:1.0 blue:1.0];
    [_fister performSelector:@selector(idle) withObject:nil afterDelay:1.f];
}

//- (void)play {
//    CCScene *gameplayScene = [CCBReader loadAsScene:@"Gameplay"];
//    [[CCDirector sharedDirector] replaceScene:gameplayScene];
//}

- (void)play {
//    CCScene *firstLevel = [CCBReader loadAsScene:@"Gameplay"];
//    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
//    [[CCDirector sharedDirector] presentScene:firstLevel withTransition:transition];
//    [SceneManager presentGameplayScene];
    
//--------------------------This is to ensure that game always starts from Training level-----------------------------
//    [GameState sharedGameState].highestUnlockedLevel = @"LevelStart0";
//    [GameState sharedGameState].scoreLevel0 = Nil;
//    [GameState sharedGameState].scoreLevel1 = nil;
//    [GameState sharedGameState].scoreLevel2 = nil;
//    [GameState sharedGameState].scoreLevel3 = nil;
//    [GameState sharedGameState].scoreLevel4 = nil;
//--------------------------------------------------------------------------------------------------------------------
    
    currentLevelStart = [GameState sharedGameState].highestUnlockedLevel;
    if ([currentLevelStart isEqualToString:@"LevelStart0"]) {
        [self showPopoverNamed:currentLevelStart];
    } else {
       [SceneManager presentGameplayScene];
    }
    
//     [SceneManager presentTrainingScene];
}

-(void) showPopoverNamed:(NSString*)name
{
    if (_popoverMenuLayer == nil)
    {
        newMenuLayer = (MenuLayer*)[CCBReader load:name];
        [self addChild:newMenuLayer];
        _popoverMenuLayer = newMenuLayer;
        _popoverMenuLayer.mainscene = self;
//        _levelNode.paused = YES;
//        if ([name containsString:@"LevelStart"]) {
//            currentLevelStart = newMenuLayer.nextLevelStart;
//        }
    }
}

-(void) removePopover
{
    if (_popoverMenuLayer)
    {
        [_popoverMenuLayer removeFromParent];
        _popoverMenuLayer = nil;
        
//        NSString *highestUnlockedLevel = [GameState sharedGameState].highestUnlockedLevel;
//        NSString *levelnumber = [highestUnlockedLevel substringFromIndex: [highestUnlockedLevel length] - 1];
//        int level = levelnumber.intValue;
//        int currentLevel = [currentLevelStart substringFromIndex: [currentLevelStart length] - 1].intValue;
//        if (level == currentLevel) {
//            [GameState sharedGameState].highestUnlockedLevel = newMenuLayer.nextLevelStart;
//        }
     
    }
}

//- (void)train {
////    CCScene *firstLevel = [CCBReader loadAsScene:@"TutorialGameplay"];
////    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
////    [[CCDirector sharedDirector] presentScene:firstLevel withTransition:transition];
//    [SceneManager presentTrainingScene];
//}
@end
