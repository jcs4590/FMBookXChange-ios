//
//  globalMethods.m
//  FMBookXChange
//
//  Created by Julio Salamanca on 3/13/14.
//  Copyright (c) 2014 Julio Salamanca. All rights reserved.
//

#import "globalMethods.h"

@interface globalMethods ()


@end

@implementation globalMethods



+(NSData *)postDataToUrl:(NSString* )urlString with:(NSString*)jsonString
{
  NSData* responseData = nil;
  NSURL *url=[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
  responseData = [NSMutableData data] ;
  
  NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
  NSString *bodydata=[NSString stringWithFormat:@"%@",jsonString];
  NSData *req=[NSData dataWithBytes:[bodydata UTF8String] length:[bodydata length]];
  
  NSUserDefaults * userData = [NSUserDefaults standardUserDefaults];
  if ([userData objectForKey:@"token"]!=nil) {
    NSLog(@"djdhdhd");
    NSString * tokenString = [NSString stringWithFormat:@"Token %@",[userData valueForKey:@"token"]];
    
    [request setValue: tokenString forHTTPHeaderField:@"Authorization"];
  }
  [request setHTTPMethod:@"POST"];
  [request setHTTPBody:req];
  [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
  
  NSURLResponse* response;
  NSError* error = nil;
  responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    //NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
  NSLog(@"%@",[response valueForKey:@"statusCode"]);
	if ([[response valueForKey:@"statusCode"]  isEqual: @400] || [[response valueForKey:@"statusCode"]  isEqual: @201]) {
    return nil;
  }
  return responseData;
}

+(NSData *)getDataFromUrl:(NSString* )urlString with:(NSString*)jsonString
{
  NSData* responseData = nil;
  NSURL *url=[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
  responseData = [NSMutableData data] ;
  
  NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
  NSUserDefaults * userData = [NSUserDefaults standardUserDefaults];

  NSString * tokenString = [NSString stringWithFormat:@"Token %@",[userData valueForKey:@"token"]];
  
  
  
  [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
  [request setHTTPMethod:@"GET"];
  [request setValue: tokenString forHTTPHeaderField:@"Authorization"];
  
  
  NSURLResponse* response;
  NSError* error = nil;
  responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    //NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
  
	if ([[response valueForKey:@"statusCode"]   isEqual: @200] || [[response valueForKey:@"statusCode"]   isEqual: @201]) {
    return responseData;
  }
  return nil;
  }
+(UIColor*)colorWithHexString:(NSString*)hex
{
  NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
  
    // String should be 6 or 8 characters
  if ([cString length] < 6) return [UIColor grayColor];
  
    // strip 0X if it appears
  if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
  
  if ([cString length] != 6) return  [UIColor grayColor];
  
    // Separate into r, g, b substrings
  NSRange range;
  range.location = 0;
  range.length = 2;
  NSString *rString = [cString substringWithRange:range];
  
  range.location = 2;
  NSString *gString = [cString substringWithRange:range];
  
  range.location = 4;
  NSString *bString = [cString substringWithRange:range];
  
    // Scan values
  unsigned int r, g, b;
  [[NSScanner scannerWithString:rString] scanHexInt:&r];
  [[NSScanner scannerWithString:gString] scanHexInt:&g];
  [[NSScanner scannerWithString:bString] scanHexInt:&b];
  
  return [UIColor colorWithRed:((float) r / 255.0f)
                         green:((float) g / 255.0f)
                          blue:((float) b / 255.0f)
                         alpha:1.0f];
}



@end
