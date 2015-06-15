//
//  ImageDownloader.m
//  tedfeed
//
//  Created by deus4 on 13/06/15.
//  Copyright (c) 2015 deus4. All rights reserved.
//
#import "ImageDownloader.h"
#import "TedFeed.h"

#define kImageIconSize 48

@interface ImageDownloader ()

@property (nonatomic, strong) NSMutableData *activeDownload;
@property (nonatomic, strong) NSURLConnection *imageConnection;

@end

@implementation ImageDownloader

- (void)startDownload
{
    self.activeDownload = [NSMutableData data];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.tedFeed.imageURLString]];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    self.imageConnection = conn;
}

- (void)cancelDownload
{
    [self.imageConnection cancel];
    self.imageConnection = nil;
    self.activeDownload = nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.activeDownload appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.activeDownload = nil;
    self.imageConnection = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    UIImage *image = [[UIImage alloc] initWithData:self.activeDownload];
    if (image.size.width != kImageIconSize || image.size.height != kImageIconSize)
    {
        CGSize itemSize = CGSizeMake(kImageIconSize, kImageIconSize);
        UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0f);
        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
        [image drawInRect:imageRect];
        self.tedFeed.appIcon = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    else
    {
        self.tedFeed.appIcon = image;
    }
    self.activeDownload = nil;
    self.imageConnection = nil;
    if (self.completionHandler)
    {
        self.completionHandler();
    }
}

@end
