//
//  globalMethods.h
//  FMBookXChange
//
//  Created by Julio Salamanca on 3/13/14.
//  Copyright (c) 2014 Julio Salamanca. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface globalMethods : NSObject
+(NSData *) postDataToUrl:(NSString* )urlString with:(NSString*)jsonString;
+(NSData *)getDataFromUrl:(NSString* )urlString with:(NSString*)jsonString;
+(UIColor*)colorWithHexString:(NSString*)hex;

@end
