//
//  DetailViewController.h
//  tedfeed
//
//  Created by deus4 on 10/06/15.
//  Copyright (c) 2015 deus4. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "TedFeed.h"

@interface DetailViewController : UIViewController

@property (nonatomic, strong) TedFeed *feedItem;
@property (nonatomic, strong) IBOutlet UIImageView *feedImage;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;

- (IBAction)playMovie:(id)sender;

@end
