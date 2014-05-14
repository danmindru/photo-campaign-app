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

- (void)viewDidAppear:(BOOL)animated{
	NSString *userPlistURL = [user getPlistURL];
	NSArray *plistUserData = [user readFromPlist:userPlistURL];
	
	if([plistUserData count] > 0){
		NSArray *loadedUserObject = [[NSArray alloc] initWithArray:plistUserData];
		
		if(loadedUserObject != nil){
			if([loadedUserObject objectAtIndex:0] != nil){
				//user is already signed in from a previous session
				//login for many iOS devices can be implemented here
				[self segueToHomeView];
			}
		}
	}
}

#pragma mark - Account login methods
- (IBAction)signInAction:(id)sender {
	//check if password and email are set
	if([self.emailInput.text length] != 0 && [self.passwordInput.text length] != 0){
		//set up connection request
		NSString *loginString = [[NSString alloc] initWithFormat:@"%@%@", REQUEST_URL, LOGIN_SLUG];
		
		AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
		NSDictionary *params = @{@"email": self.emailInput.text,
								 @"password": self.passwordInput.text,
								 @"isiOS": @1};
		
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
				NSLog(@"Login success JSON: %@", responseObject);
			}
			failure:^(AFHTTPRequestOperation *operation, NSError *error) {
				UIAlertView *accountAlert = [[UIAlertView alloc] initWithTitle:@"Cannot sign in" message:@"Make sure you have an active internet connection and you have typed the correct email and password" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
				
				[accountAlert show];
				
				NSLog(@"loign Error: %@", error);
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
	user *jsonUser = [[user alloc] initWithId:(NSString *)responseJSON[@"_id"] andEmail:responseJSON[@"email"] andFirstName:responseJSON[@"firstName"] andLastName:responseJSON[@"lastName"] andBio:responseJSON[@"bio"] andLevel:responseJSON[@"level"] andPhotoURL:responseJSON[@"photoURL"] andProvider:responseJSON[@"provider"] andUpdated:responseJSON[@"updated"] andCreated:responseJSON[@"created"] andCampaign:responseJSON[@"campaignObject"] andLoginToken:responseJSON[@"iOSToken"]];
	[jsonUser saveToPlist:userPlistURL];
}

- (IBAction)signUpAction:(id)sender {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://photocampaign.net/#!/signup"]];
}

#pragma mark - Keyboard methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	if(textField == self.emailInput){
		[self.passwordInput becomeFirstResponder];
	}
	else{
		[textField resignFirstResponder];
		//call sign in IBAction
		[self signInAction:nil];
	}
	
	return YES;
}

//hide keyboard on background touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.emailInput isFirstResponder] && [touch view] != self.emailInput) {
        [self.emailInput resignFirstResponder];
    }
	else if([self.passwordInput isFirstResponder] && [touch view] != self.passwordInput) {
        [self.passwordInput resignFirstResponder];
	}
	
    [super touchesBegan:touches withEvent:event];
}


#pragma mark - Navigation
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

@end
