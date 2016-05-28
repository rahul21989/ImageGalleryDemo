//
//  AsyncDataDownloadManager.m
//  ImageGalleryDemo
//
//  Created by Rahul on 28/05/16.
//  Copyright © 2016 ROPOSO. All rights reserved.
//

#import "AsyncDataDownloadManager.h"
#import "Author.h"
#import "NSString+ValidJson.h"
#import "Constants.h"

#define URL @"https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1"


@interface AsyncDataDownloadManager(){
  NSCache *_imageCache;
}

@end

@implementation AsyncDataDownloadManager

+(AsyncDataDownloadManager *)sharedManager {
  static AsyncDataDownloadManager *_sharedManager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _sharedManager = [[AsyncDataDownloadManager alloc] init];
  });
  
  return _sharedManager;
}

-(id)init {
  if (self = [super init]) {
    _imageCache = [[NSCache alloc] init];
    _dataSourceArray = [[NSMutableArray alloc] init];
  }
  return  self;
}

/*
 ** this function helps downloand data from URL Asynchronously
 */

-(void)downloadDataWithCompletionBlock:(DownloadCompletionHandler)handler
{
  
  BOOL isConnectedToInternet = [Constants connectedToNetwork];
  if (isConnectedToInternet) {
    NSURL *url = [NSURL URLWithString:URL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
      if ( !error && data)
      {
        [self parseResponse:data];
        handler(YES, _dataSourceArray);
      } else{
        handler(NO,nil);
      }
    }];
    
    [task resume];
  } else {
    [self showNoInternetSigninAlert];
  }
}


/*
 ** this function helps downloand image from URL Asynchronously
 */

-(void)downloadImageWithURL:(NSURL *)url completionBlock:(ImageDownloadCompletionHandler)handler
{
  UIImage *image = [_imageCache objectForKey:url];
  
  if(image)
  {
    handler(YES, url, image);
  }
  else {
    BOOL isConnectedToInternet = [Constants connectedToNetwork];
    if (isConnectedToInternet) {
      NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
      NSURLSession *session = [NSURLSession sharedSession];
      NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error && data)
        {
          UIImage *originalImage = [UIImage imageWithData:data];
          handler(YES, url, originalImage);
          [_imageCache setObject:originalImage forKey:url];
          
        } else{
          handler(NO,nil,nil);
        }
      }];
      
      [task resume];
    } else {
      [self showNoInternetSigninAlert];
    }
  }
}


/*
 ** this function parse downloanded data and put into the dataSourceArray
*/

- (void) parseResponse:(NSData *) data {
  
  NSString *originalString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
  NSString *validString = [originalString convertOriginalJSONStringToValidJSONString];
  NSData *validData = [validString dataUsingEncoding:NSUTF8StringEncoding];

  NSError* error = nil;
  
  id jsonObject = [NSJSONSerialization JSONObjectWithData:validData options:NSJSONReadingMutableContainers error:&error];
  
  NSArray *resultArray = [jsonObject objectForKey:@"items"];
  
  for (NSDictionary *dict in resultArray)
  {
    NSString *title = dict[@"title"];
    NSDictionary *media = dict[@"media"];
    NSString *link = dict[@"link"];
    NSDate *date_taken = dict[@"date_taken"];
    NSString *description = dict[@"description"];
    NSDate *published = dict[@"published"];
    NSString *authorName = dict[@"author"];
    NSString *author_id = dict[@"author_id"];
    NSString *tags = dict[@"tags"];
    
    Author *author = [Author new];
    author.title = title;
    author.media = media;
    author.link = link;
    author.date_taken = date_taken;
    author.descriptionText = description;
    author.published = published;
    author.author = authorName;
    author.author_id = author_id;
    author.tags = tags;
    [_dataSourceArray addObject:author];
  }
}


- (void)showNoInternetSigninAlert {
  UIAlertView *alertView = [[UIAlertView alloc]
                            initWithTitle:@"Network not available."
                            message:@"Network is required to fetch data."
                            delegate:nil
                            cancelButtonTitle:@"OK"
                            otherButtonTitles:nil,nil];
  [alertView show];
}

@end
