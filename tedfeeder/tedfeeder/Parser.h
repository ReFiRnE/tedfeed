//
//  Parser.h
//  tedfeeder
//
//  Created by deus4 on 12/06/15.
//  Copyright (c) 2015 deus4. All rights reserved.
//
#import <Foundation/Foundation.h>

@class Ted;

@protocol ParserRssDel;

@interface Parser : NSObject {
    Ted * _currentItem;
    NSMutableString * _currentItemValue;
    NSMutableArray * _rssItems;
    id<ParserRssDel> _delegate;
    NSOperationQueue *_retrieverQueue;
}


@property(nonatomic, retain) Ted * currentItem;
@property(nonatomic, retain) NSMutableString * currentItemValue;
@property(readonly) NSMutableArray * rssItems;

@property(nonatomic, assign) id<ParserRssDel> delegate;
@property(nonatomic, retain) NSOperationQueue *retrieverQueue;

- (void)startProcess;


@end

@protocol ParserRssDel <NSObject>

-(void)processCompleted;
-(void)processHasErrors;

@end
