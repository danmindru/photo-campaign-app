//
//  postTableViewCell.h
//  photoCampaign
//
//  Created by Dan Mindru on 15/05/14.
//  Copyright (c) 2014 Dan Mindru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface postTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel * postAuthor;
@property (weak, nonatomic) IBOutlet UILabel * postDate;
@property (weak, nonatomic) IBOutlet UILabel * postTitle;
@property (weak, nonatomic) IBOutlet UIImageView * postImage;

@end
