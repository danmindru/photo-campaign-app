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
	
	//convert date before displaying
	//convert the DB datetime into timestamp
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
	NSDate *postCreatedDate = [dateFormatter dateFromString:[allUserData valueForKey:@"created"]];
	
	
	NSDateFormatter *prettyDateFormatter = [[NSDateFormatter alloc] init];
	[prettyDateFormatter setDateStyle:NSDateFormatterLongStyle];
	[prettyDateFormatter setTimeStyle:NSDateFormatterShortStyle];
	
	NSString *postPrettyDate = [prettyDateFormatter stringFromDate:postCreatedDate];
	
	//add label for name and surname
	UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 260, 280, 28)];
	[nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:34]];
	[nameLabel setTextColor:[UIColor whiteColor]];
	nameLabel.text = [[NSString alloc] initWithFormat:@"%@ %@", [allUserData valueForKey:@"firstName"], [allUserData valueForKey:@"lastName"]];
	
	//add label for email
	UILabel *emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 315, 280, 20)];
	[emailLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:22]];
	[emailLabel setTextColor:[UIColor whiteColor]];
	emailLabel.text = [[NSString alloc] initWithFormat:@"%@", [allUserData valueForKey:@"email"]];
	
	//add "profile created" date
	UILabel *createdLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 340, 280, 30)];
	[createdLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:14]];
	[createdLabel setTextColor:[UIColor lightGrayColor]];
	createdLabel.text = [[NSString alloc] initWithFormat:@"Member since %@", postPrettyDate];
	
	//add profile image
	NSString *urlString = [[NSString alloc] initWithFormat:@"%@%@%@", REQUEST_URL, IMAGE_BASE_SLUG, [allUserData valueForKey:@"photoURL"]];
	NSURL *photoURL = [[NSURL alloc] initWithString:urlString];
	UIImage *loadedProfilePhoto = [UIImage imageWithData:[NSData dataWithContentsOfURL:photoURL]];
	
	UIImageView *profilePhotoView = [[UIImageView alloc] initWithImage:loadedProfilePhoto];
	//set imageview to scale image to it's frame
	[profilePhotoView setContentMode:UIViewContentModeScaleAspectFill];
	[profilePhotoView setClipsToBounds:YES];
	profilePhotoView.backgroundColor = [UIColor whiteColor];
	[profilePhotoView setFrame:CGRectMake(0, 0, 320, 240)];

	//add UI to scrollview
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
