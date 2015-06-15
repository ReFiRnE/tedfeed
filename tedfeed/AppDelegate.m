//
//  AppDelegate.m
//  tedfeed
//
//  Created by deus4 on 08/06/15.
//  Copyright (c) 2015 deus4. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "AppDelegate.h"
#import "Parser.h"
#import "TedFeed.h"
#import <CFNetwork/CFNetwork.h>

static NSString *const TedTalksFeed = @"http://feeds.feedburner.com/tedtalks_video";

@interface AppDelegate ()

@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, strong) NSURLConnection *feedListConnection;
@property (nonatomic, strong) NSMutableData *feedListData;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:TedTalksFeed]];
    _feedListConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    NSAssert(self.feedListConnection != nil, @"Failure to create URL connection.");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    return YES;
}

- (void)handleError:(NSError *)error
{
    NSString *errorMessage = [error localizedDescription];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Cannot Show Feed Items"
                                                        message:errorMessage
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

-(void)connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *)response
{
    self.feedListData = [NSMutableData data];
}

-(void)connection:(NSURLConnection *) connection didReceiveData:(NSData *)data
{
    [self.feedListData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if ( error.code == kCFURLErrorNotConnectedToInternet)
    {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey:@"No Connection Error"};
        NSError *noConnectionError = [NSError errorWithDomain:NSCocoaErrorDomain
                                                         code:kCFURLErrorNotConnectedToInternet
                                                     userInfo:userInfo];
        [self handleError:noConnectionError];
    }
    else
    {
        [self handleError:error];
    }
    self.feedListConnection = nil;
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    self.feedListConnection = nil;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    self.queue = [[NSOperationQueue alloc] init];
    Parser *parser = [[Parser alloc] initWithData:self.feedListData];
    parser.errorHandler = ^(NSError *parseError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self handleError:parseError];
        });
    };
    __weak Parser *weakParser = parser;
    parser.completionBlock= ^(void) {
        if (weakParser.feedRecordList)  {
            dispatch_async(dispatch_get_main_queue(), ^{
                ViewController *viewController = (ViewController*)[(UINavigationController*)self.window.rootViewController topViewController];
                viewController.entries = weakParser.feedRecordList;
                
                [viewController.tableView reloadData];
            });
        }
        self.queue = nil;
    };
    [self.queue addOperation:parser];
    self.feedListData = nil;
}

@end
