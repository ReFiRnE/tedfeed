//
//  Ted.m
//  tedfeeder
//
//  Created by deus4 on 12/06/15.
//  Copyright (c) 2015 deus4. All rights reserved.
//

#import "Ted.h"

@implementation Ted

@synthesize title = _title;
@synthesize imageUrl = _imageUrl;
@synthesize videoUrl = _videoUrl;

-(void)dealloc {
    self.title = nil;
    self.imageUrl = nil;
    self.videoUrl = nil;
    [super dealloc];
}
@end