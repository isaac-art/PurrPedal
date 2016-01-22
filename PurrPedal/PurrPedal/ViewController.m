//
//  ViewController.m
//  PurrPedal
//
//  Created by Isaac Clarke on 07/01/2016.
//  Copyright © 2016 Isaac Clarke. All rights reserved.

//
#define radiansToDegrees( radians ) ( ( radians ) * ( 180.0 / M_PI ) )

#import "ViewController.h"
#import "AKFoundation.h"
#import "Purr.h"


@implementation ViewController
{
    Purr *purr;
    BOOL chaos;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //background audio stuff here

    //first time instructions
    static NSString* const hasRunAppOnceKey = @"hasRunAppOnceKey";
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:hasRunAppOnceKey] == NO)
    {
        NSLog(@"%@", @"app first time");
        UIImageView *welcomeImg = [[UIImageView alloc] init];
        welcomeImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"welcome.png"]];
        welcomeImg.center = self.view.center;
        [self.view addSubview:welcomeImg];
        
        [defaults setBool:YES forKey:hasRunAppOnceKey];
        
        double delayInSeconds = 6.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [welcomeImg setImage:nil];
        });
        
    }//end first time
    
    //bgcolor
    NSInteger randomIndex = arc4random()%[self.colors count];
    self.view.backgroundColor = [self.colors objectAtIndex:randomIndex];
    
    //purr
    purr = [[Purr alloc] initWithNumber:1];
    [AKOrchestra addInstrument:purr];
    [purr play];
    
    
    }

- (void)viewWillDisappear:(BOOL)animated{
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}


- (IBAction)handleLongPress:(UILongPressGestureRecognizer *)recognizer{
    if ( recognizer.state == UIGestureRecognizerStateEnded ){
    if (chaos){
        [self changeColor];
        chaos = NO;
    }else{
        chaos = YES;
        self.view.backgroundColor = [UIColor blackColor];
    }
    }
}


- (IBAction)handleRotate:(UIRotationGestureRecognizer *)recognizer {
    recognizer.view.transform = CGAffineTransformRotate(recognizer.view.transform, recognizer.rotation);
    
    float myDegrees = radiansToDegrees( recognizer.rotation );
    float biggerNum = myDegrees * 100;
    if (chaos) {
        int lowerBound = 1;
        int upperBound = 1000;
        int rndValue = lowerBound + arc4random() % (upperBound - lowerBound);
        purr.sawFreq.value = rndValue;
        int lowerBound2 = 0;
        int upperBound2 = 10;
        int rndValue2 = lowerBound2 + arc4random() % (upperBound2 - lowerBound2);
        purr.sawSpeed.value = rndValue2;
    }else{
        if (biggerNum >0) {
                float higherPurrValue = (purr.sawFreq.value + 1);
                purr.sawFreq.value = higherPurrValue;
        }else{
            if (purr.sawFreq.value >=2) {
                    float higherPurrValue = (purr.sawFreq.value - 1);
                    purr.sawFreq.value = higherPurrValue;
            }
        }
    }
    //last reset
    recognizer.rotation = 0;

}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}


-(NSArray *)colors {
    if (!_colors) _colors = @[[UIColor colorWithRed:0.97 green:0.79 blue:0.78 alpha:1],
                              [UIColor colorWithRed:0.97 green:0.47 blue:0.4 alpha:1],
                             [UIColor colorWithRed:0.57 green:0.66 blue:0.83 alpha:1],
                             [UIColor colorWithRed:0 green:0.31 blue:0.53 alpha:1],
                              [UIColor colorWithRed:0.98 green:0.88 blue:0 alpha:1],
                              [UIColor colorWithRed:0.6 green:0.87 blue:0.87 alpha:1],
                              [UIColor colorWithRed:0.6 green:0.59 blue:0.65 alpha:1],
                              [UIColor colorWithRed:0.87 green:0.26 blue:0.16 alpha:1],
                              [UIColor colorWithRed:0.69 green:0.56 blue:0.39 alpha:1]];
    return _colors;
}

- (void)changeColor
{
    NSInteger randomIndex = arc4random()%[self.colors count];
    self.view.backgroundColor = [self.colors objectAtIndex:randomIndex];
    
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        [self changeColor];
        purr.sawFreq.value = 20;
        purr.sawSpeed.value = 0.18;
        chaos = NO;
    }
    
}



@end
