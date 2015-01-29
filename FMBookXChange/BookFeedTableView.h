//
//  BookFeedTableView.h
//  FMBookXChange
//
//  Created by Julio Salamanca on 3/13/14.
//  Copyright (c) 2014 Julio Salamanca. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookFeedTableView : UITableViewController

@property (strong,nonatomic) NSMutableDictionary * bookPosting;
@property (strong,nonatomic) NSMutableDictionary * completeBookPosting;
@property (strong,nonatomic) NSMutableArray * books;
@property (strong,nonatomic) NSArray * bookData;





@end
