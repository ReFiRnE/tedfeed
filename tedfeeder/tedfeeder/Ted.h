//
//  Ted.h
//  tedfeeder
//
//  Created by deus4 on 12/06/15.
//  Copyright (c) 2015 deus4. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface Ted : NSObject {
    NSString * _title;
    NSString * _imageUrl;
    NSString * _videoUrl;
}

@property(nonatomic, copy) NSString  * title;
@property(nonatomic, copy) NSString  * imageUrl;
@property(nonatomic, copy) NSString  * videoUrl;

@end