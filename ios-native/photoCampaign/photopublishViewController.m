//
//  photopublishViewController.m
//  photoCampaign
//
//  Created by Dan Mindru on 16/05/14.
//  Copyright (c) 2014 Dan Mindru. All rights reserved.
//

#import "photopublishViewController.h"
#import "AFNetworking.h"
#import "accountTextField.h"
#import "statics.h"
#import "user.h"
#import "post.h"

@interface photopublishViewController () {
	NSMutableArray *loadedUserObject;
}

@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (weak, nonatomic) IBOutlet UITextView *postDescription;
@property (weak, nonatomic) IBOutlet accountTextField *postTitle;
@property (weak, nonatomic) IBOutlet UIView *activityIndicatorView;

@end

@implementation photopublishViewController

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
	
	// Hide activity indicator
	[self.activityIndicatorView setAlpha:0.0];
	
	//load user data in array
	NSString *userPlistURL = [user getPlistURL];
	loadedUserObject = [user readFromPlist:userPlistURL];
	
	//set the edited image in the image view
	[self.postImage setImage:self.editedImage];
	[self.postImage setContentMode:UIViewContentModeScaleAspectFill];
	[self.postImage setClipsToBounds:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden{
	return YES;
}

- (IBAction)publishPost:(id)sender {
	if([self.postTitle.text length] != 0 && [self.postDescription.text length] != 0){
		// show activity indicator
		[self.activityIndicatorView setAlpha:0.8];
		//hide keyboard
		[self resignInputResponders];
		
		NSArray *allUserData = [loadedUserObject objectAtIndex:0];
		
		NSString *urlString = [NSString stringWithFormat:@"%@%@", REQUEST_URL, POST_CREATE_SLUG];
		NSDictionary *params = @{@"title": self.postTitle.text,
								 @"description": self.postDescription.text,
								 @"iOSToken": [allUserData valueForKey:@"loginToken"],
								 @"_id": [allUserData valueForKey:@"_id"],
								 @"isiOS": @1};

		//make image even smaller for web? (optional)
		UIImage *resizedImage = [post imageWithImage:self.postImage.image scaledToSize:CGSizeMake(self.postImage.image.size.width/1.2, self.postImage.image.size.height/1.2)];
		NSData *imageData = UIImageJPEGRepresentation(resizedImage, 1);
		AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
		
		[manager POST:urlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
			[formData appendPartWithFileData:imageData name:@"postPhoto" fileName:[NSString stringWithFormat:@"%@iOSphoto.jpg", [allUserData valueForKey:@"_id"]] mimeType:@"image/jpeg"];
		} success:^(AFHTTPRequestOperation *operation, id responseObject) {
			//success
			// Hide activity indicator
			[self.activityIndicatorView setAlpha:0.0];
			[self navigateToPostFeed];
			//NSLog(@"%@", responseObject);
		} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
			//failuire
			UIAlertView *postError = [[UIAlertView alloc] initWithTitle:@"There was a problem posting" message:@"Please make sure you have an active internet connection and try again" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
			// Hide activity indicator
			[self.activityIndicatorView setAlpha:0.0];
			[postError show];
			//NSLog(@"%@", error);
		}];
	}
	else{
		UIAlertView *postError = [[UIAlertView alloc] initWithTitle:@"Title and description required" message:@"Please type the description and title of the post" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
		[postError show];
	}
}

#pragma mark - Keyboard methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	if(textField == self.postTitle){
		[textField resignFirstResponder];
		[self publishPost:nil];
	}
	else{
		//go to the title input
		[self.postDescription resignFirstResponder];
		[self.postTitle becomeFirstResponder];
	}
	
	return YES;
}

//hide keyboard on background touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.postTitle isFirstResponder] && [touch view] != self.postTitle) {
        [self.postTitle resignFirstResponder];
    }
	else if([self.postDescription isFirstResponder] && [touch view] != self.postDescription) {
        [self.postDescription resignFirstResponder];
	}
	
    [super touchesBegan:touches withEvent:event];
}

- (void)resignInputResponders{
	[self.postDescription resignFirstResponder];
	[self.postTitle resignFirstResponder];
}

#pragma mark - Navigation

- (IBAction)cancelPublishAction:(id)sender {
	[self navigateToPostFeed];
}

- (void)navigateToPostFeed{
	UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"mainStoryboard" bundle:nil];
	homeNavController *homeNavVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"homeNavVC"];
	
	[(UINavigationController*)self presentViewController:homeNavVC animated:YES completion:nil];
}

@end
