//
//  ProfileTableViewController.m
//  FMBookXChange
//
//  Created by Julio Salamanca on 4/14/14.
//  Copyright (c) 2014 Julio Salamanca. All rights reserved.
//

#import "ProfileTableViewController.h" 
#import "globalMethods.h"

@interface ProfileTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;


@end

@implementation ProfileTableViewController
 int passwordStep = 0;
NSUserDefaults * userData;
NSString * newPassword;
- (void)viewWillAppear:(BOOL)animated {
  
  userData =  [NSUserDefaults standardUserDefaults];
  _firstNameLabel.text = [userData valueForKey:@"first_name"];
  _lastNameLabel.text = [userData valueForKey:@"last_name"];
  _emailLabel.text = [userData valueForKey:@"email"];

  }

//- (id)initWithStyle:(UITableViewStyle)style
//{
//    self = [super initWithStyle:style];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
  
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (section == 0) {
    return 3;
  }
  if (section == 2) {
    return 1;
  }
    // Return the number of rows in the section.
    return 3;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  
  CGRect frame = tableView.frame;
  UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  
  [button setTitle:@"edit" forState:UIControlStateNormal];
  button.frame = CGRectMake(200.0, -10.0, 160.0, 40.0);
  
  UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(2, 4, 100, 30)];
  if (section==0) {
    title.text = @"Your Books";
    
  }else if(section == 1)
      {
    	title.text = @"Basic Info";
    [button addTarget:self
               action:@selector(editBasicInfo)
     forControlEvents:UIControlEventTouchUpInside];
      }
  else
      {
    title.text = @"Change Password";
      }
  [title setFont:[UIFont fontWithName:@"Helvetica" size:15.0]];
  [title sizeToFit];
  
  UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
  [headerView setBackgroundColor: [globalMethods colorWithHexString:@"F7F7F7"]];
  [headerView addSubview:button];

  [headerView addSubview:title];
  
  return headerView;
}

- (void) editBasicInfo{
  [self performSegueWithIdentifier:@"toProfileEditSegue" sender:self];
  
}


//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//  long  selectedSection = [indexPath section];
//    //long selectedRow = [indexPath row];
// 
//
//  if (selectedSection == 1) {
//   
//    
//  }
//  

  //}
- (IBAction)changePasswordButton:(id)sender {
  
  UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Current Password" message:@"Please enter current Password" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
  av.alertViewStyle = UIAlertViewStyleSecureTextInput;
    [[av textFieldAtIndex:0] setPlaceholder:@"Current Password"];
    [av show];

  

    //[[av textFieldAtIndex:1]setPlaceholder:@"New Password"];
    //[[av textFieldAtIndex:2] setPlaceholder:@"Comfirm"];


}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
  if (buttonIndex == 0) {
    passwordStep = 0;

  }
  else{
  
  UITextField * alertTextField = [alertView textFieldAtIndex:0];
  if (passwordStep == 0) {
    NSMutableDictionary * userInfo = [[NSMutableDictionary alloc] init];
    userInfo[@"username"] = [userData valueForKey:@"username"];
    userInfo[@"password"]= alertTextField.text;
    
    
      //get user token
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:userInfo options:0 error:nil];
    NSString* jsonString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
    
    NSData * dataLogIn = [globalMethods postDataToUrl:@"http://www.fmbookxchange.org/api-token-auth/" with:jsonString];
    if (dataLogIn != nil) {
    	passwordStep++;
      UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"New Password" message:@"Please enter New Password" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
      av.alertViewStyle = UIAlertViewStyleSecureTextInput;
      passwordStep++;
      [[av textFieldAtIndex:0] setPlaceholder:@"New Password"];
      [av show];

    }
    else
        {
      UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Wrong password" message:@"Please enter New Password" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
      [av show];
        }

    
  }

  
    else if (passwordStep == 2)
        {
      newPassword = alertTextField.text;

      UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Comfirm Password" message:@"Please Comfirm New Password" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
      av.alertViewStyle = UIAlertViewStyleSecureTextInput;
      passwordStep++;
      [[av textFieldAtIndex:0] setPlaceholder:@"Comfirm Password"];
      
      [av show];
    
    
      }
  else if(passwordStep == 3)
      {
    
    if ([newPassword isEqualToString:alertTextField.text]) {
      NSDictionary * updatePassword = [[NSDictionary alloc] initWithObjectsAndKeys:newPassword,@"password", nil];
      NSDictionary * finalDict = [[NSDictionary alloc] initWithObjectsAndKeys:updatePassword,@"user", nil];
      
      
      NSString * url =  @"http://www.fmbookxchange.org/api-auth/UserProfile/";
      [url stringByAppendingString:[userData valueForKey:@"username"]];
      
      
      NSData * jsonData = [NSJSONSerialization dataWithJSONObject:finalDict options:0 error:nil];
      NSData * postResult = [globalMethods postDataToUrl:url with:[[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding]];
      if (postResult == nil) {
        passwordStep = 0;
        UIAlertView * finalAlert = [[UIAlertView alloc] initWithTitle:@"Password Updated" message:@"Your Password was updated succesfully" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [finalAlert show];
      }
    }
    else
        {
      UIAlertView * finalAlert = [[UIAlertView alloc] initWithTitle:@"Password didn't match" message:@"Your Password was not updated succesfully" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
      [finalAlert show];

        }
      }
  
  }
  
    // do whatever you want to do with this UITextField.
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


#pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
