//
//  MenuViewController.h
//  iC4
//
//  Created by zermelo on 29/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iC4ViewController.h"

@interface MenuViewController : UIViewController {
    IBOutlet iC4ViewController *gameViewController;
    IBOutlet UISegmentedControl *difficultySegment;
}

@property(nonatomic,retain) IBOutlet iC4ViewController *gameViewController;
@property(nonatomic,retain) IBOutlet UISegmentedControl *difficultySegment;

-(IBAction) toGameView;
-(IBAction) setDifficulty;

@end
