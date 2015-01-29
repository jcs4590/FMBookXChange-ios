//
//  BookFeedTableView.m
//  FMBookXChange
//
//  Created by Julio Salamanca on 3/13/14.
//  Copyright (c) 2014 Julio Salamanca. All rights reserved.
//

#import "BookFeedTableView.h"
#import "globalMethods.h"
#import "FeedTableViewCell.h"
#import "BookDetailViewController.h"


@interface BookFeedTableView ()
@property (strong, nonatomic) IBOutlet UITableView *booksTableView;
@property int nextPage,selectedBookIndex;
@property (weak,nonatomic) UILabel* loadMore;
@property BOOL  isLastPage;

@end

@implementation BookFeedTableView

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
  [[UIBarButtonItem appearance] setTintColor:[UIColor redColor]];

  _nextPage = 2;
  _selectedBookIndex =0;
  _isLastPage = NO;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

  NSData * data = [globalMethods getDataFromUrl:[NSString stringWithFormat:@"http://www.fmbookxchange.org/api-auth/BookPosting/?page=%d",1]with:nil];
  
  if (data == nil) {
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error Fetching Books" message:@"There was an error fetching our data. Please try again. If this problem persist please email fmbookxchange@gmail.com" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
    [alert show];
  }
  else{

  _books = [[NSMutableArray alloc] initWithArray:[[NSJSONSerialization JSONObjectWithData: data options:0 error:nil]valueForKey:@"results" ]];
  
  
  [self.booksTableView reloadData];
  }

  
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

    return self.books.count + 1;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TableCell";
    FeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
  
    
    // Configure the cell...
  int row = [indexPath row];
  if (([_books count]) == row) {
    
    cell.bookTitleLabel.text = nil;
    cell.bookUserLabel.text = nil;
    cell.bookPriceLabel.text = nil;
    cell.bookDescriptionLabel.text = nil;
    cell.bookSubjectLabel.text = nil;
    cell.bookTimePostedLabel.text = nil;
    cell.bookImage.image = nil;

    _loadMore =[[UILabel alloc]initWithFrame: CGRectMake(0,0,362,73)];
    cell.loadMore.textColor = [UIColor blackColor];
    cell.loadMore.highlightedTextColor = [UIColor darkGrayColor];
    cell.loadMore.backgroundColor = [UIColor clearColor];
    cell.loadMore.font=[UIFont fontWithName:@"Verdana" size:20];
    cell.loadMore.textAlignment=UITextAlignmentCenter;
    cell.loadMore.font=[UIFont boldSystemFontOfSize:20];
    cell.loadMore.text=@"Load More..";
    cell.userNameIMG.image =nil;
;
    cell.userTimeIMG.image = nil;
    cell.userSubjectIMG.image = nil;

  }
  else{
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    NSDate *date = [formatter dateFromString:[[_books objectAtIndex:row] valueForKey:@"posted_date"]];

    
    [formatter setDateFormat:@"MM-dd-yyyy"];

    
    cell.loadMore.text = nil;
  cell.bookTitleLabel.text = [[[_books objectAtIndex:row] valueForKey:@"book"] valueForKey:@"title"];
  cell.bookUserLabel.text = [[[_books objectAtIndex:row] valueForKey:@"user"] valueForKey:@"username"];
  cell.bookPriceLabel.text = [[[_books objectAtIndex:row] valueForKey:@"book"] valueForKey:@"price"];
  cell.bookDescriptionLabel.text = [[[_books objectAtIndex:row] valueForKey:@"book"] valueForKey:@"description"];
  cell.bookSubjectLabel.text = [[[_books objectAtIndex:row] valueForKey:@"book"] valueForKey:@"subject"];
    cell.bookTimePostedLabel.text = [formatter stringFromDate:date];
    cell.userNameIMG.image = [UIImage imageNamed:@"red-user-icon.png"];
    cell.userTimeIMG.image = [UIImage imageNamed:@"red-clock-icon.png"];
    cell.userSubjectIMG.image =[UIImage imageNamed:@"red-address-book-icon.png"];
  
    NSURL * urlImage = [NSURL URLWithString: [[[_books objectAtIndex:row] valueForKey:@"book"] valueForKey:@"our_image"]];
  [self downloadImageWithURL:urlImage completionBlock:^(BOOL succeeded, UIImage *image) {
    if (succeeded) {
      cell.bookImage.image = image;
    }

  }];
  }
  
    return cell;
}


- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
  [NSURLConnection sendAsynchronousRequest:request
                                     queue:[NSOperationQueue mainQueue]
                         completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                           if ( !error )
                               {
                             UIImage *image = [[UIImage alloc] initWithData:data];
                             completionBlock(YES,image);
                               } else{
                                 completionBlock(NO,nil);
                               }
                         }];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
       if (indexPath.section == 0) {
    if (indexPath.row == ([_books count])) {
      return 40;
    }
  }
  return 180;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if(indexPath.row == [_books count])
      {

    NSDictionary * pagesData = [NSJSONSerialization JSONObjectWithData:[globalMethods getDataFromUrl:[NSString stringWithFormat:@"http://www.fmbookxchange.org/api-auth/BookPosting/?page=%d",_nextPage]with:nil] options:0 error:nil];
    
    
    if ([pagesData valueForKey:@"next"] != [NSNull null]) {
      _nextPage ++;
      [_books addObjectsFromArray:[pagesData valueForKey:@"results" ]];
      [self.booksTableView reloadData];
    }
    else if(!(_isLastPage))
        {
      _isLastPage =YES;
      [_books addObjectsFromArray:[pagesData valueForKey:@"results" ]];
      [self.booksTableView reloadData];

        }
    
      }
  else
      {
    _selectedBookIndex = [indexPath row];
    
      //switch view controller to main
  
    [self  performSegueWithIdentifier:@"BookDetail" sender:self];

      }

}







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
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
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

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  BookDetailViewController * vc = segue.destinationViewController;
  vc.bookData = [_books objectAtIndex:_selectedBookIndex];
}

 

@end
