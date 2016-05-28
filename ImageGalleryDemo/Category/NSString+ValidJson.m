//
//  NSString+ValidJson.m
//  ImageGalleryDemo
//
//  Created by Rahul on 28/05/16.
//  Copyright © 2016 ROPOSO. All rights reserved.
//

#import "NSString+ValidJson.h"

@implementation NSString(ValidJson)

-(NSString *)convertOriginalJSONStringToValidJSONString {
  NSMutableString *str = [NSMutableString stringWithString:self];
  [str replaceOccurrencesOfString:@"/" withString:@"\\/" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [str length])];
  [str replaceOccurrencesOfString:@"\b" withString:@"\\b" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [str length])];
  [str replaceOccurrencesOfString:@"\f" withString:@"\\f" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [str length])];
  [str replaceOccurrencesOfString:@"\r" withString:@"\\r" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [str length])];
  [str replaceOccurrencesOfString:@"\\'" withString:@"'" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [str length])];
  [str replaceOccurrencesOfString:@"\\\'" withString:@"\'" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [str length])];
  return [NSString stringWithString:str];
}

@end
