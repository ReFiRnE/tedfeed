//
//  DetailViewController.h
//  tedfeeder
//
//  Created by deus4 on 12/06/15.
//  Copyright (c) 2015 deus4. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parser.h"

@class Parser;
@class Ted;
@class AppDelegate;

@interface DetailViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,ParserRssDel> {
    Parser * _rssParser;
    UITableView * _tableView;
    AppDelegate * _appDelegate;
    UIToolbar * _toolbar;
}

@property (nonatomic,retain) IBOutlet Parser * rssParser;
@property (nonatomic,retain) IBOutlet UITableView * tableView;
@property (nonatomic,retain) IBOutlet UIToolbar * toolbar;
@property (nonatomic,retain) IBOutlet AppDelegate * appDelegate;

-(void)toggleToolBarButtons:(BOOL)newState;

@end

