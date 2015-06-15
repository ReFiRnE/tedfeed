/*
 
 File: RootViewController.m
 
 Abstract: Controller for the main table view of the LazyTable sample.
 
 This table view controller works off the AppDelege's data model.
 
 produce a three-stage lazy load:
 
 1. No data (i.e. an empty table)
 
 2. Text-only data from the model's RSS feed
 
 3. Images loaded over the network asynchronously
 
 
 
 This process allows for asynchronous loading of the table to keep the UI responsive.
 
 Stage 3 is managed by the AppRecord corresponding to each row/cell.
 
 
 
 Images are scaled to the desired height.
 
 If rapid scrolling is in progress, downloads do not begin until scrolling has ended.
 
 
 
 Version: 1.5
 
 
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 
 Inc. ("Apple") in consideration of your agreement to the following
 
 terms, and your use, installation, modification or redistribution of
 
 this Apple software constitutes acceptance of these terms.  If you do
 
 not agree with these terms, please do not use, install, modify or
 
 redistribute this Apple software.
 
 
 
 In consideration of your agreement to abide by the following terms, and
 
 subject to these terms, Apple grants you a personal, non-exclusive
 
 license, under Apple's copyrights in this original Apple software (the
 
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 
 Software, with or without modifications, in source and/or binary forms;
 
 provided that if you redistribute the Apple Software in its entirety and
 
 without modifications, you must retain this notice and the following
 
 text and disclaimers in all such redistributions of the Apple Software.
 
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 
 be used to endorse or promote products derived from the Apple Software
 
 without specific prior written permission from Apple.  Except as
 
 expressly stated in this notice, no other rights or licenses, express or
 
 implied, are granted by Apple herein, including but not limited to any
 
 patent rights that may be infringed by your derivative works or by other
 
 works in which the Apple Software may be incorporated.
 
 
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 
 POSSIBILITY OF SUCH DAMAGE.
 
 
 
 Copyright (C) 2014 Apple Inc. All Rights Reserved.
 
 
 
 */



#import "RootViewController.h"

#import "AppRecord.h"

#import "IconDownloader.h"



#define kCustomRowCount 7



static NSString *CellIdentifier = @"LazyTableCell";

static NSString *PlaceholderCellIdentifier = @"PlaceholderCell";



@interface MyTableViewCell : UITableViewCell

@end

@implementation MyTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier

{
    
    // ignore the style argument and force the creation with style UITableViewCellStyleSubtitle
    
    return [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    
}

@end





#pragma mark -



@interface RootViewController () <UIScrollViewDelegate>

// the set of IconDownloader objects for each app

@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;

@end



#pragma mark -



@implementation RootViewController



// -------------------------------------------------------------------------------

//  viewDidLoad

// -------------------------------------------------------------------------------

- (void)viewDidLoad

{
    
    [super viewDidLoad];
    
    
    
    [self.tableView registerClass:[MyTableViewCell class] forCellReuseIdentifier:CellIdentifier];
    
    [self.tableView registerClass:[MyTableViewCell class] forCellReuseIdentifier:PlaceholderCellIdentifier];
    
    
    
    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
    
}



// -------------------------------------------------------------------------------

//  terminateAllDownloads

// -------------------------------------------------------------------------------

- (void)terminateAllDownloads

{
    
    // terminate all pending download connections
    
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    
    
    
    [self.imageDownloadsInProgress removeAllObjects];
    
}



// -------------------------------------------------------------------------------

//  dealloc

//  If this view controller is going away, we need to cancel all outstanding downloads.

// -------------------------------------------------------------------------------

- (void)dealloc

{
    
    // terminate all pending download connections
    
    [self terminateAllDownloads];
    
}



// -------------------------------------------------------------------------------

//  didReceiveMemoryWarning

// -------------------------------------------------------------------------------

- (void)didReceiveMemoryWarning

{
    
    [super didReceiveMemoryWarning];
    
    
    
    // terminate all pending download connections
    
    [self terminateAllDownloads];
    
}





#pragma mark - UITableViewDataSource



// -------------------------------------------------------------------------------

//  tableView:numberOfRowsInSection:

//  Customize the number of rows in the table view.

// -------------------------------------------------------------------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    
    NSUInteger count = self.entries.count;
    
    
    
    // if there's no data yet, return enough rows to fill the screen
    
    if (count == 0)
        
    {
        
        return kCustomRowCount;
        
    }
    
    return count;
    
}



// -------------------------------------------------------------------------------

//  tableView:cellForRowAtIndexPath:

// -------------------------------------------------------------------------------

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    MyTableViewCell *cell = nil;
    
    
    
    NSUInteger nodeCount = self.entries.count;
    
    
    
    if (nodeCount == 0 && indexPath.row == 0)
        
    {
        
        // add a placeholder cell while waiting on table data
        
        cell = [tableView dequeueReusableCellWithIdentifier:PlaceholderCellIdentifier forIndexPath:indexPath];
        
        
        
        cell.detailTextLabel.text = @"Loading…";
        
    }
    
    else
        
    {
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        
        
        // Leave cells empty if there's no data yet
        
        if (nodeCount > 0)
            
        {
            
            // Set up the cell representing the app
            
            AppRecord *appRecord = (self.entries)[indexPath.row];
            
            
            
            cell.textLabel.text = appRecord.appName;
            
            cell.detailTextLabel.text = appRecord.artist;
            
            
            
            // Only load cached images; defer new downloads until scrolling ends
            
            if (!appRecord.appIcon)
                
            {
                
                if (self.tableView.dragging == NO && self.tableView.decelerating == NO)
                    
                {
                    
                    [self startIconDownload:appRecord forIndexPath:indexPath];
                    
                }
                
                // if a download is deferred or in progress, return a placeholder image
                
                cell.imageView.image = [UIImage imageNamed:@"Placeholder.png"];
                
            }
            
            else
                
            {
                
                cell.imageView.image = appRecord.appIcon;
                
            }
            
        }
        
    }
    
    
    
    return cell;
    
}





#pragma mark - Table cell image support



// -------------------------------------------------------------------------------

//  startIconDownload:forIndexPath:

// -------------------------------------------------------------------------------

- (void)startIconDownload:(AppRecord *)appRecord forIndexPath:(NSIndexPath *)indexPath

{
    
    IconDownloader *iconDownloader = (self.imageDownloadsInProgress)[indexPath];
    
    if (iconDownloader == nil)
        
    {
        
        iconDownloader = [[IconDownloader alloc] init];
        
        iconDownloader.appRecord = appRecord;
        
        [iconDownloader setCompletionHandler:^{
            
            
            
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            
            
            
            // Display the newly loaded image
            
            cell.imageView.image = appRecord.appIcon;
            
            
            
            // Remove the IconDownloader from the in progress list.
            
            // This will result in it being deallocated.
            
            [self.imageDownloadsInProgress removeObjectForKey:indexPath];
            
            
            
        }];
        
        (self.imageDownloadsInProgress)[indexPath] = iconDownloader;
        
        [iconDownloader startDownload];
        
    }
    
}



// -------------------------------------------------------------------------------

//  loadImagesForOnscreenRows

//  This method is used in case the user scrolled into a set of cells that don't

//  have their app icons yet.

// -------------------------------------------------------------------------------

- (void)loadImagesForOnscreenRows

{
    
    if (self.entries.count > 0)
        
    {
        
        NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
        
        for (NSIndexPath *indexPath in visiblePaths)
            
        {
            
            AppRecord *appRecord = (self.entries)[indexPath.row];
            
            
            
            if (!appRecord.appIcon)
                
                // Avoid the app icon download if the app already has an icon
                
            {
                
                [self startIconDownload:appRecord forIndexPath:indexPath];
                
            }
            
        }
        
    }
    
}





#pragma mark - UIScrollViewDelegate



// -------------------------------------------------------------------------------

//  scrollViewDidEndDragging:willDecelerate:

//  Load images for all onscreen rows when scrolling is finished.

// -------------------------------------------------------------------------------

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate

{
    
    if (!decelerate)
        
    {
        
        [self loadImagesForOnscreenRows];
        
    }
    
}



// -------------------------------------------------------------------------------

//  scrollViewDidEndDecelerating:scrollView

//  When scrolling stops, proceed to load the app icons that are on screen.

// -------------------------------------------------------------------------------

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView

{
    
    [self loadImagesForOnscreenRows];
    
}



@end