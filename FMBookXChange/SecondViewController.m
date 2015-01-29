//
//  SecondViewController.m
//  FMBookXChange
//
//  Created by Julio Salamanca on 2/28/14.
//  Copyright (c) 2014 Julio Salamanca. All rights reserved.
//

#import "SecondViewController.h"
#import "BookPostViewController.h"
  //#import "CameraFocusSquare.h"
#import <Foundation/Foundation.h>
#import "CameraViewController.h"



@interface SecondViewController ()

@property NSArray * subjects;
@property NSString * GOOGLE_BOOK_KEY;
@property (nonatomic, strong) NSMutableArray * jsonData;
@property (weak, nonatomic) IBOutlet UITextField *textBoxISBN;


@property NSMutableDictionary * postingBookInfo;


@end

@implementation SecondViewController


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
  if ([segue.identifier  isEqual: @"SendInfo"]) {
    BookPostViewController * destViewController = segue.destinationViewController;
    destViewController.passingDict = _postingBookInfo;
  }
  
		}

-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{return 1;}
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
  return _subjects.count;
}
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
  return _subjects[row];
}

- (void)viewDidLoad
{
  _GOOGLE_BOOK_KEY	= @"AIzaSyCEneNnmW23TTTIDix4-hdZ0n6GIskHVxk";
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
   _subjects =  @[@"Accounting",
                          @"Anthropology",@"Art",
                          @"Astronomy",
                          @"Biological Sciences",
                          @"Business",
                          @"Chemistry",
                          @"Communication",
                          @"Computer Science",
                          @"Dance",
                          @"Economics",
                          @"Engineering",
                          @"English",
                          @"Financing",
                          @"History",
                          @"Languages",
                          @"Law",
                          @"Mathematics",
                          @"Medical School",
                          @"Music",
                          @"Nursing",
                          @"Other",
                          @"Philosophy",
                          @"Photography",
                          @"Physics",
                          @"Political Science",
                          @"Psychology",
                          @"Real Estate",
                          @"Sociology" ];
  
  _postingBookInfo = [[NSMutableDictionary alloc] init];
  [_postingBookInfo setObject:_subjects[0] forKey:@"subject"];
  NSLog(@"%@",_isbn);
  if (_isbn != nil) {
    _textBoxISBN.text = _isbn;
  }
  

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	
  [_textBoxISBN resignFirstResponder];


}



-(void)processGoogle:(NSString *) isbn
{
  
  
	NSString * url = [NSString stringWithFormat:@"https://www.googleapis.com/books/v1/volumes?q=isbn:%@ &key=AIzaSyCEneNnmW23TTTIDix4-hdZ0n6GIskHVxk &country=US", isbn ];
 
  NSString * formatedURL = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  
  
  
  NSURL * googleURL = [[NSURL alloc] initWithString:formatedURL];
  NSURLRequest * request = [[NSURLRequest alloc] initWithURL:googleURL];
  NSError * requestError = nil;
  NSURLResponse * response = nil;
  NSData * dataRequest = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&requestError];
  NSDictionary * dataReceived = [NSJSONSerialization JSONObjectWithData:dataRequest options:0 error:&requestError];
  NSDictionary *bookdata;
  
  bookdata =   [[dataReceived valueForKey:@"items"] valueForKey:@"volumeInfo"];
  if ([bookdata valueForKey:@"title"][0] != nil) {
   
    
    [_postingBookInfo setObject:[bookdata valueForKey:@"title"][0] forKey:@"title"];
    [_postingBookInfo setObject:[bookdata valueForKey:@"authors"][0][0] forKey:@"author"];
    [_postingBookInfo setObject:[[bookdata valueForKey:@"imageLinks"][0] valueForKey:@"thumbnail"] forKey:@"our_image"];
    

  }
  


  


}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{

	_postingBookInfo[@"subject"] = _subjects[row];
  
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  [self.textBoxISBN resignFirstResponder];
	return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
  
}


- (IBAction)isbnButton:(id)sender {
  
  	[self processGoogle: [_textBoxISBN text]];
  _postingBookInfo[@"isbn"] = [_textBoxISBN text];
 

}


-(IBAction)gotoBViewController:(id)sender
{
  NSLog(@"pressed");
  CameraViewController * bController=[[CameraViewController alloc] init];
  bController.delegate=self;
  [self.navigationController pushViewController:bController animated:YES];
  
  
}
-(void)sendDataToA:(NSString *)stringISBN
{
  _textBoxISBN.text= stringISBN;
}




@end
