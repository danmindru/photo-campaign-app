//
//  accountViewController.m
//  photoCampaign
//
//  Created by Dan Mindru on 14/05/14.
//  Copyright (c) 2014 Dan Mindru. All rights reserved.
//

#import "accountViewController.h"
#import "statics.h"

@interface accountViewController () {
	NSMutableArray *loadedUserObject;
}
@property (weak, nonatomic) IBOutlet UIScrollView *accountScrollView;

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
	//read user account info
	//account info should be reload from URL if internet connection available
	NSString *userPlistURL = [user getPlistURL];
	loadedUserObject = [user readFromPlist:userPlistURL];
	NSArray *allUserData = [loadedUserObject objectAtIndex:0];
	
	//define green color
	UIColor *greenColor = [[UIColor alloc] initWithRed:85/255.f green:221/225.f blue:82/225.f alpha:1];
	UIColor *lightGrayColor = [[UIColor alloc] initWithRed:0.9 green:0.9 blue:0.9 alpha:0.4];
	
	//self.profileName.text = [[NSString alloc] initWithFormat:@"%@ %@", [allUserData valueForKey:@"firstName"], [allUserData valueForKey:@"lastName"]];
	//self.profileEmail.text = [[NSString alloc] initWithFormat:@"%@", [allUserData valueForKey:@"email"]];
	//self.profileBio.text = [[NSString alloc] initWithFormat:@"%@", [allUserData valueForKey:@"bio"]];
	
	//convert date before displaying
	//convert the DB datetime into timestamp
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
	NSDate *postCreatedDate = [dateFormatter dateFromString:[allUserData valueForKey:@"created"]];
	
	
	NSDateFormatter *prettyDateFormatter = [[NSDateFormatter alloc] init];
	[prettyDateFormatter setDateStyle:NSDateFormatterLongStyle];
	[prettyDateFormatter setTimeStyle:NSDateFormatterShortStyle];
	
	NSString *postPrettyDate = [prettyDateFormatter stringFromDate:postCreatedDate];
	
	//self.profileCreatedDate.text = [[NSString alloc] initWithFormat:@"%@", postPrettyDate];
	
	
	//add label for name and surname
	UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, 280, 28)];
	[nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:34]];
	nameLabel.textColor = greenColor;
	nameLabel.text = [[NSString alloc] initWithFormat:@"%@ %@", [allUserData valueForKey:@"firstName"], [allUserData valueForKey:@"lastName"]];
	
	//add label for email
	UILabel *emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 75, 280, 20)];
	[emailLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:22]];
	emailLabel.text = [[NSString alloc] initWithFormat:@"%@", [allUserData valueForKey:@"email"]];
	
	//add "profile created" date
	UILabel *createdLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 130, 280, 30)];
	[createdLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:14]];
	createdLabel.text = [[NSString alloc] initWithFormat:@"Member since %@", postPrettyDate];
	
	//add profile image
	NSString *urlString = [[NSString alloc] initWithFormat:@"%@%@%@", REQUEST_URL, IMAGE_BASE_SLUG, [allUserData valueForKey:@"photoURL"]];
	NSURL *photoURL = [[NSURL alloc] initWithString:urlString];
	UIImage *loadedProfilePhoto = [UIImage imageWithData:[NSData dataWithContentsOfURL:photoURL]];
	
	UIImageView *profilePhotoView = [[UIImageView alloc] initWithImage:loadedProfilePhoto];
	float profilePhotoHeight = loadedProfilePhoto.size.height*320/loadedProfilePhoto.size.width;
	profilePhotoView.backgroundColor = [[UIColor alloc] initWithRed:0.9 green:0.9 blue:0.9 alpha:0.4];
	[profilePhotoView setFrame:CGRectMake(0, 170, 320, profilePhotoHeight)];

	//add UI to scrollview
	//set the background of the view first
	self.accountScrollView.backgroundColor = lightGrayColor;
	[self.accountScrollView addSubview:nameLabel];
	[self.accountScrollView addSubview:emailLabel];
	[self.accountScrollView addSubview:createdLabel];
	[self.accountScrollView addSubview:profilePhotoView];
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

#pragma mark - Navigation
- (void)segueToLoginView{
	//set the view controller as homeStoryboard
	UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"mainStoryboard" bundle:nil];
	loginViewController *loginVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"loginVC"];
	
	[(UINavigationController*)self presentViewController:loginVC animated:YES completion:nil];
}


@end
