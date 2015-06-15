//
//  Parser.m
//  tedfeed
//
//  Created by deus4 on 08/06/15.
//  Copyright (c) 2015 deus4. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "TedFeed.h"
#import "Parser.h"

static NSString *kTitleStr   = @"title";
static NSString *kMediaStr  = @"media:thumbnail";
static NSString *kItemStr  = @"item";

@interface Parser () <NSXMLParserDelegate>

@property (nonatomic, strong) NSArray *feedRecordList;
@property (nonatomic, strong) NSData *dataToParse;
@property (nonatomic, strong) NSMutableArray *workingArray;
@property (nonatomic, strong) TedFeed *workingItem;
@property (nonatomic, strong) NSMutableString * workingPropertyString;
@property (nonatomic, strong) NSArray *elementsToParse;
@property (nonatomic, readwrite) bool storingCharactedData;

@end

@implementation Parser

-(instancetype)initWithData:(NSData *)data
{
    self = [super init];
    if (self != nil)
    {
        _dataToParse = data;
        _elementsToParse = @[kTitleStr, kMediaStr];
    }
    return self;
}

-(void)main
{
    _workingArray = [NSMutableArray array];
    _workingPropertyString = [NSMutableString string];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:self.dataToParse];
    [parser setDelegate:self];
    [parser parse];
    if (![self isCancelled])
    {
        self.feedRecordList = [NSArray arrayWithArray:self.workingArray];
    }
    self.workingArray = nil;
    self.workingPropertyString = nil;
    self.dataToParse = nil;
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:kItemStr])
    {
        self.workingItem = [[TedFeed alloc] init];
    }
    if ([elementName isEqual:@"itunes:image"])
    {
        _workingItem.imageURLString = [attributeDict objectForKey:@"href"];
    }
    if ([elementName isEqual:@"media:content"])
    {
        _workingItem.mediaURLString = [attributeDict objectForKey:@"url"];
    }
    self.storingCharactedData = [self.elementsToParse containsObject: elementName];
}
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if(self.workingItem != nil)
    {
        if(self.storingCharactedData)
        {
            NSString *trimmedString = [self.workingPropertyString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            [self.workingPropertyString setString:@""];
            if ([ elementName isEqualToString:kTitleStr])
            {
                self.workingItem.feedName = trimmedString;
            }
            else if ([elementName isEqualToString:kMediaStr])
            {
                self.workingItem.imageURLString = trimmedString;
            }
        }
        else if ([elementName isEqualToString:kItemStr])
        {
            [self.workingArray addObject:self.workingItem];
            self.workingItem = nil;
        }
    }
}

-(void)parser:(NSXMLParser *) parser foundCharacters:(NSString *)string
{
    if(self.storingCharactedData)
    {
        [self.workingPropertyString appendString:string];
    }
}

-(void)parser:(NSXMLParser *) parser parseErrorOccurred:(NSError *)parseError
{
    if (self.errorHandler)
    {
        self.errorHandler(parseError);
    }
}

@end