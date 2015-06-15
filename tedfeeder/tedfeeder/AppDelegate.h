//
//  AppDelegate.h
//  tedfeeder
//
//  Created by deus4 on 12/06/15.
//  Copyright (c) 2015 deus4. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;
@class MasterViewController;
@class Ted;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow * _window;
    DetailViewController * _viewController;
    UINavigationController * _navigationController;
    MasterViewController * _newsDetailController;
    Ted * _currentlySelectedBlogItem;
}

@property (nonatomic, retain) IBOutlet UIWindow * window;
@property (nonatomic, retain) IBOutlet DetailViewController *viewController;
@property (nonatomic, retain) IBOutlet UINavigationController * navigationController;
@property (nonatomic,retain) IBOutlet MasterViewController * newsDetailController;

@property (readwrite,retain) Ted * currentlySelectedBlogItem;

-(void)loadNewsDetails;

@end

