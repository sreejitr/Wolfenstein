#import "MainScene.h"
#import "SceneManager.h"

@implementation MainScene

//- (void)play {
//    CCScene *gameplayScene = [CCBReader loadAsScene:@"Gameplay"];
//    [[CCDirector sharedDirector] replaceScene:gameplayScene];
//}

- (void)play {
//    CCScene *firstLevel = [CCBReader loadAsScene:@"Gameplay"];
//    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
//    [[CCDirector sharedDirector] presentScene:firstLevel withTransition:transition];
    [SceneManager presentGameplayScene];
}

- (void)train {
//    CCScene *firstLevel = [CCBReader loadAsScene:@"TutorialGameplay"];
//    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
//    [[CCDirector sharedDirector] presentScene:firstLevel withTransition:transition];
    [SceneManager presentTrainingScene];
}
@end
