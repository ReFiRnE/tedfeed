//
//  ImageDownloader.h
//  tedfeed
//
//  Created by deus4 on 13/06/15.
//  Copyright (c) 2015 deus4. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class TedFeed;

@interface ImageDownloader : NSObject

@property (nonatomic, strong) TedFeed *tedFeed;
@property (nonatomic, copy) void (^completionHandler)(void);

- (void)startDownload;
- (void)cancelDownload;

@end