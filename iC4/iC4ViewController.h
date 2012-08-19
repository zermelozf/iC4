//
//  iC4ViewController.h
//  iC4
//
//  Created by zermelo on 13/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iC4Model.h"

@interface iC4ViewController : UIViewController {
    
    iC4Model *model;
    
    NSArray *arrayOfYellowTileViews;
    NSArray *arrayOfRedTileViews;
    NSArray *arrayOfEmptyTileViews;
    UIImageView *tile;
    
    IBOutlet UILabel *info;
    
    NSInteger columnTouched;
    NSInteger computerPlaying;
    
    
}

@property(nonatomic,retain) IBOutletCollection(UIImageView) NSArray *arrayOfYellowTileViews;
@property(nonatomic,retain) IBOutletCollection(UIImageView) NSArray *arrayOfRedTileViews;
@property(nonatomic,retain) IBOutletCollection(UIImageView) NSArray *arrayOfEmptyTileViews;
@property(nonatomic,retain) UIImageView *tile;
@property(nonatomic,retain) IBOutlet UILabel *info;
@property(nonatomic,retain) IBOutlet UIButton *changePlayerButton;
@property(nonatomic,retain) IBOutlet UIButton *restartButton;

//@property(nonatomic,retain) iC4Model *model;

-(NSInteger) determinTouchedColumn:(CGPoint) location;
-(void) drawViewBoardFromModelBoard;
-(void) updateGame:(NSSet *) touches :(UIEvent *) event;
-(void) endGame;
-(void) setDifficulty:(NSInteger) dif;
-(IBAction) changePlayerButtonPressed:(UIButton *)sender;
-(IBAction) restartButtonPressed:(UIButton *) sender;

@end
