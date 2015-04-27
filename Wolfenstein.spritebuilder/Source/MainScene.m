#import "MainScene.h"
#import "SceneManager.h"
#import "Fister.h"

@implementation MainScene {
   __weak Fister *_fister;
}

- (void)didLoadFromCCB {
    _fister.color = [CCColor colorWithRed:0.3 green:1.0 blue:1.0];
     [_fister punchcharge];
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
     [SceneManager presentTrainingScene];
}

//- (void)train {
////    CCScene *firstLevel = [CCBReader loadAsScene:@"TutorialGameplay"];
////    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
////    [[CCDirector sharedDirector] presentScene:firstLevel withTransition:transition];
//    [SceneManager presentTrainingScene];
//}
@end
