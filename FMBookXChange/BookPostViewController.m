//
//  BookPostViewController.m
//  FMBookXChange
//
//  Created by Julio Salamanca on 3/5/14.
//  Copyright (c) 2014 Julio Salamanca. All rights reserved.
//

#import "BookPostViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "globalMethods.h"

@interface BookPostViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textFieldTitle;
@property (weak,nonatomic) NSMutableDictionary* bookInfo;
@property (weak, nonatomic) IBOutlet UITextField *textFieldAuthor;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPrice;
@property (weak, nonatomic) IBOutlet UITextField *textFieldCourseNum;
@property (weak, nonatomic) IBOutlet UITextView *textFieldDescription;
@property (weak, nonatomic) IBOutlet UIImageView *bookImage;
@property (weak, nonatomic) IBOutlet UITextField *textFieldISBN;
@property (weak, nonatomic) IBOutlet UITextField *textFieldSubject;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property NSUserDefaults * userData;
@end

@implementation BookPostViewController

@synthesize textFieldTitle;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)verifyButton:(id)sender {
}

- (void)viewDidLoad
{    [super viewDidLoad];
	self.bookInfo =self.passingDict;
  
  _textFieldPrice.delegate=self;
  _textFieldCourseNum.delegate=self;
  _textFieldAuthor.delegate=self;
  textFieldTitle.delegate=self;
  _textFieldDescription.delegate=self;
  _textFieldDescription.layer.cornerRadius=8.0f;
  _textFieldDescription.layer.masksToBounds=YES;
  _textFieldDescription.layer.borderColor=[[UIColor redColor]CGColor];
  _textFieldDescription.layer.borderWidth= 1.0f;
  
    _userData = [NSUserDefaults standardUserDefaults];
  
  if ([_bookInfo valueForKey:@"our_image"] != nil) {
    NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: [_bookInfo valueForKey:@"our_image"]]];
    if (imageData != nil) {
      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Is This Your Book?!" message:[_bookInfo valueForKey:@"title"] delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"NO", nil];
      UIImage *yourImage = [[UIImage alloc] initWithData:imageData];
      UIImageView *imageView = [[UIImageView alloc] initWithImage:yourImage];
      [alert setValue:imageView forKey:@"accessoryView"];
      [alert show];

  }
  
  }
  [_textFieldISBN setText:[_bookInfo valueForKey:@"isbn"]];
  [_textFieldSubject setText:[_bookInfo valueForKey:@"subject"]];

  

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backButton:(id)sender {
  
  if ([_backButton.currentTitle  isEqual: @"Back"]) {
    UIStoryboard * myStoryBoard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    UIViewController * vc = [myStoryBoard instantiateViewControllerWithIdentifier:@"mainView"];
  	[self presentViewController:vc animated:YES completion:nil];
    
    
      }
  else if([_backButton.currentTitle  isEqual: @"Make Changes"])
      {
    [_confirmButton setTitle:@"Submit" forState:UIControlStateNormal];
    [_backButton setTitle:@"Back" forState:UIControlStateNormal];
    [_textFieldSubject setEnabled:YES];
    [_textFieldPrice setEnabled:YES];
    [_textFieldISBN setEnabled:YES];
    [_textFieldDescription setEditable:YES];
    [_textFieldCourseNum setEnabled:YES];
    [_textFieldAuthor setEnabled:YES];
    [textFieldTitle setEnabled:YES];
         }
  

}



-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
  
  [textField resignFirstResponder];
  return YES;
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{

  if([text isEqualToString:@"\n"])
    [_textFieldDescription resignFirstResponder];
  return YES;
}

- (IBAction)confirmButton:(id)sender {
  if ([_confirmButton.currentTitle  isEqual: @"Submit"]) {
    [_confirmButton setTitle:@"Confirm" forState:UIControlStateNormal];
    [_backButton setTitle:@"Make Changes" forState:UIControlStateNormal];
    [_textFieldSubject setEnabled:NO];
    [_textFieldPrice setEnabled:NO];
    [_textFieldISBN setEnabled:NO];
    [_textFieldDescription setEditable:NO];
    [_textFieldCourseNum setEnabled:NO];
    [_textFieldAuthor setEnabled:NO];
    [textFieldTitle setEnabled:NO];
  }
  else if([_confirmButton.currentTitle  isEqual: @"Confirm"])
      {
    
    	_bookInfo[@"related_course"] = _textFieldCourseNum.text;
      _bookInfo[@"price"] = _textFieldPrice.text;
    	_bookInfo[@"description"] = _textFieldDescription.text;
      _bookInfo[@"image"] = @"";

    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:_bookInfo options:0 error:nil];
    NSString* jsonString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
    
    if([globalMethods postDataToUrl:@"http://www.fmbookxchange.org/api-auth/Books" with:jsonString] == nil)
        {
      UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error Posting Book" message:@"There was an error posting your book. Please try again. If this problem persist please email fmbookxchange@gmail.com" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
      [alert show];

        }
    else{
      //switch view controller to main
    UIStoryboard * myStoryBoard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    UIViewController * vc = [myStoryBoard instantiateViewControllerWithIdentifier:@"mainView"];
  	[self presentViewController:vc animated:YES completion:nil];
      }
    }
  
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 0) {
    
    NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: [_bookInfo valueForKey:@"our_image"]]];
    UIImage *yourImage = [[UIImage alloc] initWithData:imageData];

    [textFieldTitle setText:[self.bookInfo valueForKey:@"title"]];
    [_textFieldAuthor setText: [self.bookInfo valueForKey:@"author"]];
    


    

    [_bookImage setImage:yourImage];
  }

}


@end
