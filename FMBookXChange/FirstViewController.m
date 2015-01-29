//
//  FirstViewController.m
//  FMBookXChange
//
//  Created by Julio Salamanca on 2/28/14.
//  Copyright (c) 2014 Julio Salamanca. All rights reserved.
//

#import "FirstViewController.h"




@interface FirstViewController ()
@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;

@end

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  NSUserDefaults * userData =  [NSUserDefaults standardUserDefaults];
  _firstNameLabel.text = [userData valueForKey:@"first_name"];
  _lastNameLabel.text = [userData valueForKey:@"last_name"];
  _emailLabel.text = [userData valueForKey:@"email"];

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
