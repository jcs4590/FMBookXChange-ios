//
//  TableViewCell.h
//  FMBookXChange
//
//  Created by Julio Salamanca on 1/5/15.
//  Copyright (c) 2015 Julio Salamanca. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *bookTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *subjectLabel;
@property (strong, nonatomic) IBOutlet UIImageView *bookImage;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;


@end
