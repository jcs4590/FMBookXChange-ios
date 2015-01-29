//
//  ViewController-LogIn.m
//  FMBookXChange
//
//  Created by Julio Salamanca on 3/12/14.
//  Copyright (c) 2014 Julio Salamanca. All rights reserved.
//

#import "UserProfileViewContoller.h"
#import "ViewController-LogIn.h"
#import "globalMethods.h"

@interface ViewController_LogIn ()
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property NSMutableDictionary * userInfo;

@end

@implementation ViewController_LogIn




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	_userInfo = [[NSMutableDictionary alloc] init];
  [[self view] setBackgroundColor:[globalMethods colorWithHexString:@"1D77EF"]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






- (IBAction)processLogIN:(id)sender {
  
  _userInfo[@"username"] = _username.text.lowercaseString;
  _userInfo[@"password"] = _password.text;
  
  NSUserDefaults * userData = [NSUserDefaults standardUserDefaults];

    //get user token
  NSData* jsonData = [NSJSONSerialization dataWithJSONObject:_userInfo options:0 error:nil];
  NSString* jsonString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];

  NSData * dataLogIn = [globalMethods postDataToUrl:@"http://www.fmbookxchange.org/api-token-auth/" with:jsonString];
  if (dataLogIn != nil) {
    NSDictionary * tempUser = [NSJSONSerialization JSONObjectWithData:dataLogIn options:0 error:nil] ;

    
    
      _userInfo[@"token"] = [tempUser valueForKey:@"token"];
    [userData setObject:[_userInfo valueForKey:@"token"] forKey:@"token"];

      [_userInfo removeObjectForKey:@"password"];
      
        //get user profile
      jsonData = [NSJSONSerialization dataWithJSONObject:_userInfo options:0 error:nil];
      jsonString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
    dataLogIn = [globalMethods getDataFromUrl:[NSString stringWithFormat:@"http://www.fmbookxchange.org/api-auth/User/%@",_userInfo[@"username"]] with:jsonString];
  
      tempUser = [NSJSONSerialization JSONObjectWithData:dataLogIn options:0 error:nil];
      [userData setObject:[tempUser valueForKey:@"first_name"] forKey:@"first_name"];
      [userData setObject:[tempUser valueForKey:@"last_name"] forKey:@"last_name"];
      [userData setObject:[tempUser valueForKey:@"id"] forKey:@"id"];
      [userData setObject:[tempUser valueForKey:@"email"] forKey:@"email"];
    [userData setObject:[tempUser valueForKey:@"username"] forKey:@"username"];
      [userData synchronize];
      
        //switch view controller to main
      UIStoryboard * myStoryBoard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
      UIViewController * vc = [myStoryBoard instantiateViewControllerWithIdentifier:@"mainView"];
      [self presentViewController:vc animated:YES completion:nil];
      
      
  }
  
    else
        {
      UIAlertView * alert = [[UIAlertView alloc ] initWithTitle:@"Invalid Credintials" message:@"Your Email or Password are incorrect" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
      [alert show];
        }
    
    

    
  }






@end
