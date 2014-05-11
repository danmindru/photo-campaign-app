//
//  accountViewController.m
//  photoCampaign
//
//  Created by Dan Mindru on 10/05/14.
//  Copyright (c) 2014 Dan Mindru. All rights reserved.
//

#import "accountViewController.h"
#import "statics.h"

@interface accountViewController (){
	NSMutableArray *loadedUserObject;
}
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *profileName;
@property (weak, nonatomic) IBOutlet UILabel *profileEmail;
@property (weak, nonatomic) IBOutlet UITextView *profileBio;
@property (weak, nonatomic) IBOutlet UILabel *profileCreatedDate;

@end

@implementation accountViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
	NSString *userPlistURL = [user getPlistURL];
	loadedUserObject = [user readFromPlist:userPlistURL];
	
	self.profileName.text = [[NSString alloc] initWithFormat:@"%@ %@", [[loadedUserObject objectAtIndex:0] valueForKey:@"firstName"], [[loadedUserObject objectAtIndex:0] valueForKey:@"lastName"]];
	self.profileEmail.text = [[NSString alloc] initWithFormat:@"%@", [[loadedUserObject objectAtIndex:0] valueForKey:@"email"]];
	self.profileBio.text = [[NSString alloc] initWithFormat:@"%@", [[loadedUserObject objectAtIndex:0] valueForKey:@"bio"]];
	self.profileCreatedDate.text = [[NSString alloc] initWithFormat:@"%@", [[loadedUserObject objectAtIndex:0] valueForKey:@"created"]];
	
	NSString *urlString = [[NSString alloc] initWithFormat:@"%@%@%@", REQUEST_URL, IMAGE_BASE_SLUG, [[loadedUserObject objectAtIndex:0] valueForKey:@"photoURL"]];
	NSURL *photoURL = [[NSURL alloc] initWithString:urlString];
	UIImage *loadedProfilePhoto = [UIImage imageWithData:[NSData dataWithContentsOfURL:photoURL]];
	[self.profileImage setImage:loadedProfilePhoto];
	self.profileImage.frame = CGRectMake(0, 0, loadedProfilePhoto.size.height, loadedProfilePhoto.size.width);
	[self.profileImage setBounds:CGRectMake(0, -100, loadedProfilePhoto.size.height, loadedProfilePhoto.size.width)];

}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
