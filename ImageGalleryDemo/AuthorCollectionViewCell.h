//
//  AuthorCollectionViewCell.h
//  ImageGalleryDemo
//
//  Created by Rahul on 28/05/16.
//  Copyright © 2016 ROPOSO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Author.h"

@interface AuthorCollectionViewCell : UICollectionViewCell

-(void)customizeCell:(Author*)author;

@end
