//
//  ViewController.m
//  tedfeed
//
//  Created by deus4 on 08/06/15.
//  Copyright (c) 2015 deus4. All rights reserved.
//
#import "ViewController.h"
#import "TedFeed.h"
#import "DetailViewController.h"
#import "ImageDownloader.h"

#define kCustomRowCount 1

static NSString *CellIdentifier = @"TedTableCell";
static NSString *PlaceholderCellIdentifier = @"PlaceholderCell";

@interface MyTableViewCell : UITableViewCell

@end

@implementation MyTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    return [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
}

@end

@interface ViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[MyTableViewCell class] forCellReuseIdentifier:CellIdentifier];
    [self.tableView registerClass:[MyTableViewCell class] forCellReuseIdentifier:PlaceholderCellIdentifier];
    // Do any additional setup after loading the view, typically from a nib.
    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
}

- (void)terminateAllDownloads
{
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    [self.imageDownloadsInProgress removeAllObjects];
    
}

- (void)dealloc
{
    [self terminateAllDownloads];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [self terminateAllDownloads];
}

- (void)startIconDownload:(TedFeed *)tedFeed forIndexPath:(NSIndexPath *)indexPath
{
    ImageDownloader *iconDownloader = (self.imageDownloadsInProgress)[indexPath];
    if (iconDownloader == nil)
    {
        iconDownloader = [[ImageDownloader alloc] init];
        iconDownloader.tedFeed = tedFeed;
        [iconDownloader setCompletionHandler:^
        {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            cell.imageView.image = tedFeed.appIcon;
            [self.imageDownloadsInProgress removeObjectForKey:indexPath];
        }];
        (self.imageDownloadsInProgress)[indexPath] = iconDownloader;
        [iconDownloader startDownload];
    }
}

- (void)loadImagesForOnscreenRows
{
    if (self.entries.count > 0)
    {
        NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            TedFeed *appRecord = (self.entries)[indexPath.row];
            if (!appRecord.appIcon)
            {
                [self startIconDownload:appRecord forIndexPath:indexPath];
            }
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        [self loadImagesForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger count = self.entries.count;
    if (count == 0)
    {
        return kCustomRowCount;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyTableViewCell *cell = nil;
    NSUInteger nodeCount = self.entries.count;
    if (nodeCount == 0 && indexPath.row == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:PlaceholderCellIdentifier forIndexPath:indexPath];
        cell.detailTextLabel.text = @"Loading...";
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        if (nodeCount > 0)
        {
            TedFeed *tedFeed = (self.entries)[indexPath.row];
            cell.textLabel.text = tedFeed.feedName;
            if (!tedFeed.appIcon)
            {
                if (self.tableView.dragging == NO && self.tableView.decelerating == NO)
                {
                    [self startIconDownload:tedFeed forIndexPath:indexPath];
                }
                cell.imageView.image = [UIImage imageNamed:@"Placeholder.png"];
            }
            else
            {
                cell.imageView.image = tedFeed.appIcon;
            }
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.test1 = [self.entries objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"ShowDetail" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DetailViewController *details = segue.destinationViewController;
    details.feedItem = self.test1;
}

@end
