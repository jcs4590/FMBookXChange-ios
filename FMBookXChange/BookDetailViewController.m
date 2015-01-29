//
//  BookDetailViewController.m
//  FMBookXChange
//
//  Created by Julio Salamanca on 3/17/14.
//  Copyright (c) 2014 Julio Salamanca. All rights reserved.
//

#import "BookDetailViewController.h"
#import "globalMethods.h"

@interface BookDetailViewController ()
@property (weak, nonatomic) IBOutlet UINavigationItem *BookTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelAuthor;
@property (weak, nonatomic) IBOutlet UILabel *labelISBN;
@property (weak, nonatomic) IBOutlet UILabel *labelSubject;
@property (weak, nonatomic) IBOutlet UILabel *labelRelatedCourse;
@property (weak, nonatomic) IBOutlet UILabel *labelDescription;
@property (weak, nonatomic) IBOutlet UITextField *textBoxPrice;

@property (weak, nonatomic) IBOutlet UIImageView *bookImage;



@end

@implementation BookDetailViewController

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
  
  _labelAuthor.text = [[_bookData valueForKey:@"book"] valueForKey:@"author"];

    _labelISBN.text = [[_bookData valueForKey:@"book"] valueForKey:@"isbn"];
 		_labelRelatedCourse.text = [[_bookData valueForKey:@"book"] valueForKey:@"related_course"];
  _labelDescription.text = [[_bookData valueForKey:@"book"] valueForKey:@"description"];
  _labelSubject.text = [[_bookData valueForKey:@"book"] valueForKey:@"subject"];
  
  NSURL * urlImage = [NSURL URLWithString: [[_bookData valueForKey:@"book"] valueForKey:@"our_image"]];
  UIImage * img = [[UIImage alloc] initWithData:[[NSData alloc] initWithContentsOfURL:urlImage] ];
  _bookImage.image = img;
  _textBoxPrice.text = [[_bookData valueForKey:@"book"] valueForKey:@"price"];

  [self.navigationItem setTitle:[[_bookData valueForKey:@"book"] valueForKey:@"title"]];

  

                        }




- (IBAction)submitOffer:(id)sender {
  NSUserDefaults * userData = [NSUserDefaults standardUserDefaults];
  
  NSDictionary * offerDetails = @{
                                  @"subject" : @" ",
                                  @"body" : @" ",
                                  @"sender" : [userData valueForKey:@"id"] ,
                                  @"recipient" : @1,
                                  @"price": _textBoxPrice.text
                                  };
  
  NSData* jsonData = [NSJSONSerialization dataWithJSONObject:offerDetails options:0 error:nil];
  NSString* jsonString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
  NSData * data = [globalMethods postDataToUrl:[NSString stringWithFormat:@"http://www.fmbookxchange.org/api-auth/SumbitOffer/%@/",[_bookData valueForKey:@"postingID"]] with:jsonString];
  if (data == nil) {
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error Posting Offer" message:@"There was an error posting your offer. Please try again. If this problem persist please email fmbookxchange@gmail.com" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
    [alert show];
  }
  else{
  
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Your Offer was sent" message:[NSString stringWithFormat:@"Your offer for this book was sent to %@" , [[_bookData valueForKey:@"user"] valueForKey:@"username"]] delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
    [alert show];
      //switch view controller to main
    UIStoryboard * myStoryBoard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    UIViewController * vc = [myStoryBoard instantiateViewControllerWithIdentifier:@"mainView"];
  	[self presentViewController:vc animated:YES completion:nil];
  
  }

  
  
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //Headerview
  UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 300.0, 20.0)] ;
  UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
  [button setFrame:CGRectMake(275.0, 5.0, 30.0, 30.0)];
  button.tag = section;
  button.hidden = NO;
  [button setBackgroundColor:[UIColor clearColor]];
  [button addTarget:self action:@selector(insertParameter:) forControlEvents:UIControlEventTouchDown];
  [myView addSubview:button];
  return myView;
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
