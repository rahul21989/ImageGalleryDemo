//
//  Author.h
//  ImageGalleryDemo
//
//  Created by Rahul on 28/05/16.
//  Copyright © 2016 ROPOSO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Author : NSObject

@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *link;
@property (nonatomic,strong) NSDictionary *media;
@property (nonatomic,strong) NSDate *date_taken;
@property (nonatomic,strong) NSString *descriptionText;
@property (nonatomic,strong) NSDate *published;
@property (nonatomic,strong) NSString *author;
@property (nonatomic,strong) NSString *author_id;
@property (nonatomic,strong) NSString *tags;

@end
