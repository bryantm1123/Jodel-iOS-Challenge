//
// Created by Dmitry on 14/03/2017.
// Copyright (c) 2017 company. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FlickrApi : NSObject

+ (void)fetchPhotosWithCompletion:(nullable void (^)(NSArray <NSURL *> * _Nullable, NSError *_Nullable))completion;

@end
