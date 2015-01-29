//
//  FeedTavleViewCell.h
//  FMBookXChange
//
//  Created by Julio Salamanca on 3/14/14.
//  Copyright (c) 2014 Julio Salamanca. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedTableViewCell : UITableViewCell

@property (strong,nonatomic) IBOutlet UILabel * bookTitleLabel;
@property (strong,nonatomic) IBOutlet UILabel * bookSubjectLabel;
@property (strong,nonatomic) IBOutlet UILabel * bookTimePostedLabel;
@property (strong,nonatomic) IBOutlet UILabel * bookUserLabel;
@property (strong,nonatomic) IBOutlet UILabel * bookPriceLabel;
@property (strong,nonatomic) IBOutlet UILabel * bookDescriptionLabel;
@property (strong,nonatomic) IBOutlet UIImageView * bookImage;
@property (strong,nonatomic) IBOutlet UILabel * loadMore;

@property (weak, nonatomic) IBOutlet UIImageView *userNameIMG;
@property (weak, nonatomic) IBOutlet UIImageView *userSubjectIMG;
@property (weak, nonatomic) IBOutlet UIImageView *userTimeIMG;







@end
