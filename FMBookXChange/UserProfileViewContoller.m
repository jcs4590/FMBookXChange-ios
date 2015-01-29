//
//  UserProfileViewContoller.m
//  FMBookXChange
//
//  Created by Julio Salamanca on 3/13/14.
//  Copyright (c) 2014 Julio Salamanca. All rights reserved.
//

#import "UserProfileViewContoller.h"
#import "globalMethods.h"

@interface UserProfileViewContoller ()
@property (weak, nonatomic) IBOutlet UILabel *noBooksLabel;
@property (weak, nonatomic) IBOutlet UIImageView * profileImage;
@property (weak, nonatomic) IBOutlet UILabel *myBooksTabLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableDictionary * _userInfo;
@property (weak, nonatomic) IBOutlet UICollectionView *bookCollectionView;
@property (strong,nonatomic) NSMutableArray * bookImages;
@property(strong,nonatomic) NSUserDefaults *userData;
@property(strong,nonatomic) NSData * userBookData;
@property (strong,nonatomic)	NSMutableDictionary * userBookDict;
@property (weak, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@end

@implementation UserProfileViewContoller


@synthesize profileImage,bookImages, userData, userBookData, userBookDict, noBooksLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)profileOptions:(id)sender {
  
  UISegmentedControl *  segmentControl = (UISegmentedControl *)sender;
	int selectedaTab = [segmentControl selectedSegmentIndex];
  
  if (selectedaTab == 0) {
    [_tableView setHidden:true];
    [_bookCollectionView setHidden:false];
  }
  if (selectedaTab == 1) {
    [_tableView setHidden:false];
    [_bookCollectionView setHidden:true];
  }
  
  
}

- (void)viewDidLoad
{

    [super viewDidLoad];
 
  	bookImages= [[NSMutableArray alloc] init];
  noBooksLabel.hidden = YES;

  
  userBookData = [globalMethods getDataFromUrl:@"http://www.fmbookxchange.org/api-auth/getUserBooks/" with:nil];
  
  userData = [NSUserDefaults standardUserDefaults];

  _fullNameLabel.text = [NSString stringWithFormat:@"%@ %@", [userData valueForKey:@"first_name"],[userData valueForKey:@"last_name"]];
  
  
  _userNameLabel.text = [userData valueForKey:@"username"];

  if (userBookData != nil) {
    userBookDict = [NSJSONSerialization JSONObjectWithData:userBookData options:nil error:nil ];
  
    for (int i = 0; i < [userBookDict count]; i++) {
      [bookImages addObject:[[userBookDict valueForKey:@"book"] valueForKey:@"our_image"][i]];

    }
    
    
  }
  
  
  [_bookCollectionView setHidden:false];
  [_tableView setHidden:true];


	
  
  profileImage.layer.cornerRadius = profileImage.frame.size.width / 2;
  profileImage.clipsToBounds = YES;
  
  profileImage.layer.borderWidth = 3.0f;
  profileImage.layer.borderColor = [UIColor blueColor].CGColor;
  
  

  
}
-(void)getUserBooks
{

  NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.fmbookxchange.org/api-auth/getUserBooks/"]];
  NSHTTPURLResponse * requestResponse = [[NSHTTPURLResponse alloc] init];
  NSString * tokenString = [NSString stringWithFormat:@"Token %@",[userData valueForKey:@"token"]];
  NSLog(@"yesss   %@",[userData valueForKey:@"token"]);
  
  
  
  [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
  [request setHTTPMethod:@"GET"];
  [request setValue: tokenString forHTTPHeaderField:@"Authorization"];

  
  
 
  
  if ([requestResponse valueForKey:@"statusCode"] != 200)
      {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Server Error" message:[NSString stringWithFormat:@"An Error has occured! Please try again! If it persists pease contact me %@",[requestResponse valueForKey:@"statusCode"] ] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
  
    [alert show];
      }
  else
      {
    
      UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"NICE Error" message:@"An Awesomess has occured! Please come again! If it persists pease contact me" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    
      }
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  static NSString *CellIdentifier = @"TableCell";


  UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  cell.textLabel.text = @"nowww";
  return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 3;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
  return 1;
}




  //collection views

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

  return 3;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
  if ([bookImages count] == 0) {
    noBooksLabel.hidden = NO;
    return 0;
  }
  else if ([bookImages count] <= 3) {
    return 1;
  }
  return (([bookImages count]/3)+1);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
  
  static NSString *identifier = @"Cell";
  
  UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
 
  UIImageView *bookImageView = (UIImageView *)[cell viewWithTag:100];
  
  
  NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:[bookImages objectAtIndex:indexPath.row]]];
  
  [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]  completionHandler:^(NSURLResponse * response,NSData * dataImage ,NSError * error)
   {
 
 if (!error) {
   
   bookImageView.image =  [UIImage imageWithData:dataImage]; 
 }
 else
     {
   			
     }
   }];
  
  
  

  
  

  
  return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
 
}

@end
