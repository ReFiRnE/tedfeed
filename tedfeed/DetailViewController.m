//
//  DetailViewController.m
//  tedfeed
//
//  Created by deus4 on 10/06/15.
//  Copyright (c) 2015 deus4. All rights reserved.
//
#import "DetailViewController.h"
#import "TedFeed.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

@synthesize titleLabel;
@synthesize feedImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.titleLabel.text = self.feedItem.feedName;
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.feedItem.imageURLString]];
    self.feedImage.image =[UIImage imageWithData:imageData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}
-(void)playMovie:(id)sender
{
    NSURL *url = [NSURL URLWithString:
                  self.feedItem.mediaURLString];
    
    _moviePlayer =  [[MPMoviePlayerController alloc]
                     initWithContentURL:url];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:_moviePlayer];
    
    _moviePlayer.controlStyle = MPMovieControlStyleDefault;
    _moviePlayer.shouldAutoplay = YES;
    [self.view addSubview:_moviePlayer.view];
    [_moviePlayer setFullscreen:YES animated:YES];
}
- (void) moviePlayBackDidFinish:(NSNotification*)notification {
    MPMoviePlayerController *player = [notification object];
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:MPMoviePlayerPlaybackDidFinishNotification
     object:player];
    
    if ([player
         respondsToSelector:@selector(setFullscreen:animated:)])
    {
        [player.view removeFromSuperview];
    }
}
@end
