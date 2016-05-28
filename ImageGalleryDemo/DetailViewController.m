//
//  DetailViewController.m
//  ImageGalleryDemo
//
//  Created by Rahul on 28/05/16.
//  Copyright © 2016 ROPOSO. All rights reserved.
//

#import "DetailViewController.h"
#import "AsyncDataDownloadManager.h"

@interface DetailViewController ()
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UIWebView *webView;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setAuthorDetails:(Author *)newAuthorDetails {
  if (_authorDetails != newAuthorDetails) {
    _authorDetails = newAuthorDetails;
  }
}


- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  [self setUpAuthorDescription];
  [self loadAuthorMediaImage];
}

/*
 ** this function loads author image from server or cache
 */

-(void)loadAuthorMediaImage {
  
  NSDictionary *media = _authorDetails.media;
  NSString *imageUrl = media[@"m"];
  NSURL *imageUrlLink = [NSURL URLWithString:imageUrl];
  
  [[AsyncDataDownloadManager sharedManager] downloadImageWithURL:imageUrlLink completionBlock:^(BOOL succeeded, NSURL *url, UIImage *image) {
    if (succeeded && image) {
      if (imageUrlLink == url) {
        dispatch_async(dispatch_get_main_queue(), ^{
          self.imageView.image = image;
        });
      }
    }
  }];
}

/*
 ** this function shows description html
*/

-(void) setUpAuthorDescription{
  NSString *desc = _authorDetails.descriptionText;
  desc = [desc stringByReplacingOccurrencesOfString:@"\\" withString:@""];
  NSMutableString *displayHTML = [NSMutableString stringWithString:@"<html><head><body>"];
  [displayHTML appendString:desc];
  [displayHTML appendString:@"</body></head></html>"];
  [self.webView loadHTMLString:displayHTML baseURL:nil];
}

-(void)viewWillAppear:(BOOL)animated {
  self.navigationItem.title = @"AUTHOR DETAILS";
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
