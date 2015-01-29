//
//  CameraViewController.h
//  FMBookXChange
//
//  Created by Julio Salamanca on 3/25/14.
//  Copyright (c) 2014 Julio Salamanca. All rights reserved.
//
@protocol senddataProtocol <NSObject>

-(void)sendDataToA:(NSString *)myStringData; //I am thinking my data is NSArray , you can use another object for store your information.

@end
#import <UIKit/UIKit.h>

@interface CameraViewController : UIViewController
@property(nonatomic,assign)id delegate;

@end
