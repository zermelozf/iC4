//
//  iC4ViewController.m
//  iC4
//
//  Created by zermelo on 13/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "iC4ViewController.h"

@implementation iC4ViewController;
@synthesize arrayOfYellowTileViews, arrayOfRedTileViews, arrayOfEmptyTileViews, tile, info, changePlayerButton, restartButton;


-(iC4Model *) model {
    if (!model) {
        model = [[iC4Model alloc] init];
    }
    return model;
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

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Game";
    model = self.model;
    if ([model firstPlayer] == @"Computer") {
        [model computerPlay];
        [self drawViewBoardFromModelBoard];
    }
    
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

-(IBAction) changePlayerButtonPressed:(UIButton *)sender {
    if(model.firstPlayer == @"Human"){
        model.firstPlayer = @"Computer";
        [sender setTitle:@"Human VS Comp" forState:UIControlStateNormal];
    }
    else {
        model.firstPlayer = @"Human";
        [sender setTitle:@"Comp VS Human" forState:UIControlStateNormal];
    }
}

-(IBAction) restartButtonPressed:(UIButton *)sender {
    [model restartGame];
    [self drawViewBoardFromModelBoard];
    if (model.firstPlayer == @"Computer") {
        [model computerPlay];
        [self drawViewBoardFromModelBoard];
    }
}

/* -----------------------------------------------------------------
Begin Interaction with Model
 -------------------------------------------------------------------*/

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (model.gameFinished == 1) {
        [model restartGame];
        [self drawViewBoardFromModelBoard];
        if (model.firstPlayer==@"Computer") {
            [model computerPlay];
            [self drawViewBoardFromModelBoard];
        }
    }
    else {
        [self updateGame:touches :event];
    }
}

-(NSInteger)determinTouchedColumn:(CGPoint) location {
    for (UIImageView *ntile in arrayOfEmptyTileViews){
        if (CGRectContainsPoint(ntile.frame, location)) {
            return ntile.tag%7;
        }
    }
    return -1;
}

-(void) drawViewBoardFromModelBoard {
    for (tile  in arrayOfRedTileViews) {
        if ([model getBoardAtRow:5-tile.tag/7 AndColumn:tile.tag%7] == -1) {
            tile.hidden = NO;
        }
        else {
            tile.hidden = YES;
        }
    }
    for (tile  in arrayOfYellowTileViews) {
        if ([model getBoardAtRow:5-tile.tag/7 AndColumn:tile.tag%7] == 1) {
            tile.hidden = NO;
        }
        else {
            tile.hidden = YES;
        }
    }
}

-(void) updateGame:(NSSet *)touches :(UIEvent *)event {
    CGPoint pt = [[touches anyObject] locationInView:self.view];
    columnTouched = [self determinTouchedColumn:pt];
    if (columnTouched != -1) {
        int row = [model firstEmptyRowAtCol:columnTouched];
        if (row != -1) {
            [model playAtColumn:columnTouched];
            [self drawViewBoardFromModelBoard];
            if ([model evalBoard] != 0) {
                [self endGame];
            }
            else {
                [model computerPlay];
            }
            [self drawViewBoardFromModelBoard];
            info.text = [NSString stringWithFormat:@"%d", [model evalBoard]];
            if ([model evalBoard] != 0) {
                [self endGame];
            }
        }
    }
}

-(void) endGame {
    model.gameFinished = 1;
    int winner = [model evalBoard];
    if (winner == 3) {
        info.text = @"Draw";
    }
    else {
        info.text = [@"Player " stringByAppendingString:[[NSString stringWithFormat:@"%d",[model evalBoard]] stringByAppendingString:@" Wins!"]];
    }
    //[info.text [NSString stringWithFormat:@"%d", [model evalBoard]]];
}

-(void) setDifficulty:(NSInteger)  dif{
    model.difficulty = dif;
}

@end
