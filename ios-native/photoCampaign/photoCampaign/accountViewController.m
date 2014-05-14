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

- (IBAction)logoutAction:(id)sender {
	//remove post data from plist
	NSString* postPlistURL = [post getPlistURL];
	[post removeAllPosts:postPlistURL];
	
	//additionally, a request can be sent to remove the user's iOS token from the DB
	NSString *userPlistURL = [user getPlistURL];
	[user removeFromPlist:userPlistURL];
	
	[self segueToLoginView];
}

- (void)viewWillAppear:(BOOL)animated{
	NSString *userPlistURL = [user getPlistURL];
	loadedUserObject = [user readFromPlist:userPlistURL];
	NSArray *allUserData = [loadedUserObject objectAtIndex:0];
	
	self.profileName.text = [[NSString alloc] initWithFormat:@"%@ %@", [allUserData valueForKey:@"firstName"], [allUserData valueForKey:@"lastName"]];
	self.profileEmail.text = [[NSString alloc] initWithFormat:@"%@", [allUserData valueForKey:@"email"]];
	self.profileBio.text = [[NSString alloc] initWithFormat:@"%@", [allUserData valueForKey:@"bio"]];
	
	//convert date before displaying
	//convert the DB datetime into timestamp
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
	NSDate *postCreatedDate = [dateFormatter dateFromString:[allUserData valueForKey:@"created"]];
	
	
	NSDateFormatter *prettyDateFormatter = [[NSDateFormatter alloc] init];
	[prettyDateFormatter setDateStyle:NSDateFormatterLongStyle];
	[prettyDateFormatter setTimeStyle:NSDateFormatterShortStyle];
	
	NSString *postPrettyDate = [prettyDateFormatter stringFromDate:postCreatedDate];
	
	self.profileCreatedDate.text = [[NSString alloc] initWithFormat:@"%@", postPrettyDate];
	
	NSString *urlString = [[NSString alloc] initWithFormat:@"%@%@%@", REQUEST_URL, IMAGE_BASE_SLUG, [allUserData valueForKey:@"photoURL"]];
	NSURL *photoURL = [[NSURL alloc] initWithString:urlString];
	UIImage *loadedProfilePhoto = [UIImage imageWithData:[NSData dataWithContentsOfURL:photoURL]];
	[self.profileImage setImage:loadedProfilePhoto];
	self.profileImage.frame = CGRectMake(0, 0, loadedProfilePhoto.size.height, loadedProfilePhoto.size.width);
	[self.profileImage setBounds:CGRectMake(0, -100, loadedProfilePhoto.size.height, loadedProfilePhoto.size.width)];

}


#pragma mark - Navigation
- (void)segueToLoginView{
	//set the view controller as homeStoryboard
	UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"mainStoryboard" bundle:nil];
	loginViewController *loginVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"loginVC"];

	[(UINavigationController*)self presentViewController:loginVC animated:YES completion:nil];
}

@end
