//
//  MasterViewController.m
//  ImageGalleryDemo
//
//  Created by Rahul on 28/05/16.
//  Copyright © 2016 ROPOSO. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "Author.h"
#import "AuthorCollectionViewCell.h"
#import "AsyncDataDownloadManager.h"


#define kNumberOfCellInRow 3

static NSString  *authorCollectionReuseIdentifier = @"AuthorCollectionViewCell";

@interface MasterViewController () <UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
  UIActivityIndicatorView *indicator;
}

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic,strong) IBOutlet UICollectionView *imageListView;
@property  NSMutableArray *imageList;

@end

@implementation MasterViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self.imageListView registerNib:[UINib nibWithNibName:authorCollectionReuseIdentifier bundle:nil] forCellWithReuseIdentifier:authorCollectionReuseIdentifier];
  
  [self.activityIndicator startAnimating];
  
  [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
  
  self.navigationItem.title = @"IMAGES";
  self.imageListView.delegate = self;
  self.imageListView.dataSource = self;
  self.imageListView.backgroundColor = [UIColor clearColor];
  
  //load datasource
  [self loadData];
  
  // Do any additional setup after loading the view, typically from a nib.
  self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
}


-(void)loadData {
  [[AsyncDataDownloadManager sharedManager] downloadDataWithCompletionBlock:^(BOOL succeeded, NSMutableArray *results) {
    if (succeeded) {
      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
      _imageList = results;
      dispatch_async(dispatch_get_main_queue(), ^{
        [self.activityIndicator stopAnimating];
        [_imageListView reloadData];
      });
    }
  }];
}

#pragma mark-- UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  return _imageList.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  AuthorCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:authorCollectionReuseIdentifier forIndexPath:indexPath];
  
  if([_imageList objectAtIndex:indexPath.row] != nil)
  {
    Author *authorInfo = (Author *)[_imageList objectAtIndex:indexPath.row];
    [cell customizeCell:authorInfo];
  }

  return cell;
}


#pragma mark -- UICollectionViewDelegate


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
  if([_imageList objectAtIndex:indexPath.row] != nil)
  {
    [self performSegueWithIdentifier:@"showDetail" sender:self];
  }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
  CGFloat cellWidth =  [[UIScreen mainScreen] bounds].size.width/kNumberOfCellInRow;
  return CGSizeMake(cellWidth-20, cellWidth - 20);
}

#pragma mark collection view cell paddings
- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
  // top, left, bottom, right
  return UIEdgeInsetsMake(5, 5, 15, 5);
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([[segue identifier] isEqualToString:@"showDetail"]) {
    
    NSIndexPath *indexPath = [[self.imageListView indexPathsForSelectedItems] lastObject];
    Author *object = _imageList[indexPath.row];
    DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
    [controller setAuthorDetails:object];
    self.navigationItem.title = @"";
    controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
    controller.navigationItem.leftItemsSupplementBackButton = YES;
  }
}

@end

