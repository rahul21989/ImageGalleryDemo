//
//  AuthorCollectionViewCell.m
//  ImageGalleryDemo
//
//  Created by Rahul on 28/05/16.
//  Copyright © 2016 ROPOSO. All rights reserved.
//

#import "AuthorCollectionViewCell.h"
#import "Author.h"
#import "AsyncDataDownloadManager.h"

@interface AuthorCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation AuthorCollectionViewCell

-(void)awakeFromNib {
  [super awakeFromNib];
}

-(void)customizeCell:(Author*)author {
  
  Author *authorInfo = (Author*)author;
  self.imageView.image = nil;
  [self.activityIndicator startAnimating];
  
  self.imageView.layer.cornerRadius = 4;
  self.imageView.layer.borderWidth = 2.0;
  self.imageView.layer.borderColor = [UIColor blackColor].CGColor;
  
  NSDictionary *media = authorInfo.media;
  [self loadAuthorMediaImage:media];
}


/*
 ** this function loads author image from server or cache
 */

-(void)loadAuthorMediaImage:(NSDictionary *)media {
  
  NSString *imageUrl = media[@"m"];
  NSURL *imageUrlLink = [NSURL URLWithString:imageUrl];
  
  [[AsyncDataDownloadManager sharedManager] downloadImageWithURL:imageUrlLink completionBlock:^(BOOL succeeded, NSURL *url, UIImage *image) {
    if (succeeded && image) {
      if (imageUrlLink == url) {
        dispatch_async(dispatch_get_main_queue(), ^{
          self.imageView.image = image;
          [self.activityIndicator stopAnimating];

        });
      }
    }
  }];
}

@end
