//
//  loginViewController.m
//  photoCampaign
//
//  Created by Dan Mindru on 09/05/14.
//  Copyright (c) 2014 Dan Mindru. All rights reserved.
//

#import "loginViewController.h"
#import "AFNetworking.h"
#import "statics.h"

@interface loginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailInput;
@property (weak, nonatomic) IBOutlet UITextField *passwordInput;

@end

@implementation loginViewController

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

#pragma mark - account login and logout methods
- (IBAction)signInAction:(id)sender {
	//check if password and email are set
	if([self.emailInput.text length] != 0 && [self.passwordInput.text length] != 0){
		//set up connection request
		NSString *loginString = [[NSString alloc] initWithFormat:@"%@%@", REQUEST_URL, LOGIN_SLUG];
		
		AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
		NSDictionary *params = @{@"email": self.emailInput.text,
								 @"password": self.passwordInput.text};
		
		[manager POST:loginString parameters:params
			success:^(AFHTTPRequestOperation *operation, id responseObject) {
				//save logged in user
				[self signInUser:responseObject];
				
				//initialize user from plist
				//NSString *userPlistURL = [user getPlistURL];
				//loadedUserObject = [user readFromPlist:userPlistURL];
				
				//segue to the home view with user data
				[self segueToHomeView];
				
				//user can be loaded from plist, but can also be loaded from the response object
				//here it will be loaded from plist for consistency
				//NSString *userPlistURL = [user getPlistURL];
				//loadedUserObject = [user readFromPlist:userPlistURL];
				//self.userWelcome.text = [[NSString alloc] initWithFormat:@"Hi %@ %@", [[loadedUserObject objectAtIndex:0] valueForKey:@"firstName"], [[loadedUserObject objectAtIndex:0] valueForKey:@"lastName"]];
				
				//log JSON response
				//NSLog(@"JSON: %@", responseObject);
			}
			failure:^(AFHTTPRequestOperation *operation, NSError *error) {
				NSLog(@"Error: %@", error);
			}
		];

	}
	else{
		UIAlertView *accountAlert = [[UIAlertView alloc] initWithTitle:@"Email and password required" message:@"Please provide your email and password" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
		
		[accountAlert show];
	}
}

- (void)signInUser:(id)responseJSON{
	//get user plist url
	NSString *userPlistURL = [user getPlistURL];
	
	//store user data in plist
	user *jsonUser = [[user alloc] initWithId:(NSString *)responseJSON[@"_id"] andEmail:responseJSON[@"email"] andFirstName:responseJSON[@"firstName"] andLastName:responseJSON[@"lastName"] andBio:responseJSON[@"bio"] andLevel:responseJSON[@"level"] andPhotoURL:responseJSON[@"photoURL"] andProvider:responseJSON[@"provider"] andUpdated:responseJSON[@"updated"] andCreated:responseJSON[@"created"]];
	[jsonUser saveToPlist:userPlistURL];
}

- (void)segueToHomeView{
	//set the view controller as homeStoryboard
	UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"mainStoryboard" bundle:nil];
	homeNavController *homeNavVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"homeNavVC"];
	
	//the user object could be passed, or instantiated directly
	//homeViewController *homeVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"homeVC"];
	//homeNavVC.userObject = loadedUserObject;
	
	//animate to view controller
	//[(UINavigationController*)self presentViewController:homeVC animated:YES completion:nil];
	[(UINavigationController*)self presentViewController:homeNavVC animated:YES completion:nil];

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
