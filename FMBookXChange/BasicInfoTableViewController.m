//
//  BasicInfoTableViewController.m
//  FMBookXChange
//
//  Created by Julio Salamanca on 4/21/14.
//  Copyright (c) 2014 Julio Salamanca. All rights reserved.
//

#import "BasicInfoTableViewController.h"
#import <Foundation/Foundation.h>
#import "globalMethods.h"
@interface BasicInfoTableViewController ()
@property (weak, nonatomic) IBOutlet UITextField *firstNameBox;
@property (weak, nonatomic) IBOutlet UITextField *lastNameBox;
@property (weak, nonatomic) IBOutlet UITextField *emailBox;
@property(weak,nonatomic) NSUserDefaults * userData;
@end

@implementation BasicInfoTableViewController
- (IBAction)saveUserInfoButton:(id)sender {
	NSString * username = [_userData valueForKey:@"username"];
  if(_firstNameBox.text.length == 0 || _lastNameBox.text.length == 0 || _emailBox.text.length == 0)
      {
    UIAlertView *noEmptyBoxAlert = [[UIAlertView alloc] initWithTitle:@"All Fields Must Be Filled" message:@"Please Check all the fields." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [noEmptyBoxAlert show];
      }
  else
      {
    NSString * url =  @"http://www.fmbookxchange.org/api-auth/UserProfile/";
    [url stringByAppendingString:username];
    NSMutableDictionary * newuserInfo = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * userInfoUpdate = [[NSMutableDictionary alloc] init];
	
    
    
    [userInfoUpdate setValue:_firstNameBox.text forKey:@"first_name"];
    [userInfoUpdate setValue:_lastNameBox.text forKey:@"last_name"];
    [userInfoUpdate setValue:_emailBox.text forKey:@"email"];
    [newuserInfo setValue:userInfoUpdate forKey:@"user"];

    
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:newuserInfo options:0 error:nil];
    NSData * postResult = [globalMethods postDataToUrl:url with:[[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding]];
    if (postResult == nil) {
      [_userData setObject:_firstNameBox.text forKey:@"first_name"];
      [_userData setObject:_lastNameBox.text forKey:@"last_name"];
      [_userData setObject:_emailBox.text forKey:@"email"];


      [self.navigationController popViewControllerAnimated:YES];
      UIAlertView *noEmptyBoxAlert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Your profile was succefully Updated! " delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
      [noEmptyBoxAlert show];
      
    }
    else
        {
      UIAlertView *noEmptyBoxAlert = [[UIAlertView alloc] initWithTitle:[[NSString alloc] initWithData:postResult encoding:NSUTF8StringEncoding] message:@"Error occured. Please Try Again Later. If problem persists please contact me." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
      [noEmptyBoxAlert show];
        }
    
      }
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
  _userData = [NSUserDefaults standardUserDefaults];
  _firstNameBox.text = [_userData valueForKey:@"first_name"];
  _lastNameBox.text = [_userData valueForKey:@"last_name"];
  _emailBox.text = [_userData valueForKey:@"email"];
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 3;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
