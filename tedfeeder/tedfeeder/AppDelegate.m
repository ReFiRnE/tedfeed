//
//  AppDelegate.m
//  tedfeeder
//
//  Created by deus4 on 12/06/15.
//  Copyright (c) 2015 deus4. All rights reserved.
//

#import "AppDelegate.h"
#import "DetailViewController.h"
#import "MasterViewController.h"
#import "Ted.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize navigationController = _navigationController;
@synthesize newsDetailController = _newsDetailController;
@synthesize currentlySelectedBlogItem = _currentlySelectedBlogItem;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    _navigationController.viewControllers = [NSArray arrayWithObject:_viewController];
    
    // Override point for customization after app launch
    [_window addSubview:_navigationController.view];
    [_window makeKeyAndVisible];
}

-(void)loadNewsDetails{
    [[self navigationController]pushViewController:_newsDetailController animated:YES];
}


- (void)dealloc {
    [_navigationController release];
    [_viewController release];
    [_window release];
    [super dealloc];
}


@end
