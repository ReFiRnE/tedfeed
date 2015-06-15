//
//  Parser.h
//  tedfeed
//
//  Created by deus4 on 08/06/15.
//  Copyright (c) 2015 deus4. All rights reserved.
//
@interface Parser : NSOperation

@property (nonatomic, copy) void (^errorHandler)(NSError *error);
@property (nonatomic, strong, readonly) NSArray *feedRecordList;

- (instancetype)initWithData:(NSData *)data;

@end