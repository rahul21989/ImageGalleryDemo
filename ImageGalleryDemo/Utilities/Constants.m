//
//  Constants.m
//  ImageGalleryDemo
//
//  Created by Rahul on 28/05/16.
//  Copyright © 2016 ROPOSO. All rights reserved.
//

#import "Constants.h"
#import "Reachability.h"

@implementation Constants 

+(BOOL)connectedToNetwork
{
  // Create zero addy
  struct sockaddr_in zeroAddress;
  bzero(&zeroAddress, sizeof(zeroAddress));
  zeroAddress.sin_len = sizeof(zeroAddress);
  zeroAddress.sin_family = AF_INET;
	
  // Recover reachability flags
  SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
  SCNetworkReachabilityFlags flags;
	
  BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
  CFRelease(defaultRouteReachability);
	
  if (!didRetrieveFlags)
  {
    return NO;
  }
	
  BOOL isReachable = flags & kSCNetworkFlagsReachable;
  BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
	BOOL nonWiFi = flags & kSCNetworkReachabilityFlagsTransientConnection;
	
	NSURL *testURL = [NSURL URLWithString:@"http://www.apple.com/"];
	NSURLRequest *testRequest = [NSURLRequest requestWithURL:testURL  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20.0];
	NSURLConnection *testConnection = [[NSURLConnection alloc] initWithRequest:testRequest delegate:self];
	
  return ((isReachable && !needsConnection) || nonWiFi) ? (testConnection ? YES : NO) : NO;
}


@end
