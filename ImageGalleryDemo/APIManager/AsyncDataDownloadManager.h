//
//  AsyncDataDownloadManager.h
//  ImageGalleryDemo
//
//  Created by Rahul on 28/05/16.
//  Copyright © 2016 ROPOSO. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AsyncDataDownloadManager : NSObject

+(AsyncDataDownloadManager *)sharedManager;

@property (strong,nonatomic) NSMutableArray* dataSourceArray;

typedef void(^DownloadCompletionHandler)(BOOL succeeded, NSMutableArray *results);

typedef void(^ImageDownloadCompletionHandler)(BOOL succeeded, NSURL *url, UIImage *image);

/*
 ** this function helps downloand image from URL Asynchronously
 ** scaling the original image
 */

-(void)downloadImageWithURL:(NSURL *)url completionBlock:(ImageDownloadCompletionHandler)handler;

/*
 ** this function helps downloand data from URL Asynchronously
 */

-(void)downloadDataWithCompletionBlock:(DownloadCompletionHandler)handler;


@end
