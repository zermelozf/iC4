//
//  MenuViewController.m
//  iC4
//
//  Created by zermelo on 29/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MenuViewController.h"


@implementation MenuViewController
@synthesize gameViewController, difficultySegment;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Menu";
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction) toGameView {
    [[self navigationController] pushViewController:gameViewController animated:YES];
}

-(IBAction) setDifficulty {
    switch (self.difficultySegment.selectedSegmentIndex) {
        case 0:
            [gameViewController setDifficulty:2];
            break;
        case 1:
            [gameViewController setDifficulty:5];
            break;            
        default:
            [gameViewController setDifficulty:7];
            break;
    }

}

@end
