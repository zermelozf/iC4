//
//  iC4AppDelegate.h
//  iC4
//
//  Created by zermelo on 13/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class iC4ViewController;

@interface iC4AppDelegate : NSObject <UIApplicationDelegate> {
    IBOutlet UINavigationController *navigationController;

}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property(nonatomic,retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) IBOutlet iC4ViewController *viewController;

@end
