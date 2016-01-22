//
//  ViewController.h
//  PurrPedal
//
//  Created by Isaac Clarke on 07/01/2016.
//  Copyright © 2016 Isaac Clarke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKFoundation.h"

@interface ViewController : UIViewController <UIGestureRecognizerDelegate>


- (IBAction)handleRotate:(UIRotationGestureRecognizer *)recognizer;
- (IBAction)handleLongPress:(UILongPressGestureRecognizer *)recognizer;

@property (strong, nonatomic) NSArray *colors;

@end

