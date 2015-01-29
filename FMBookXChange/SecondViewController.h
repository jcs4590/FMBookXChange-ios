//
//  SecondViewController.h
//  FMBookXChange
//
//  Created by Julio Salamanca on 2/28/14.
//  Copyright (c) 2014 Julio Salamanca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


@interface SecondViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate,AVCaptureMetadataOutputObjectsDelegate>
-(void)processGoogle:(NSString *) isbn;
@property NSString * isbn;


@end
