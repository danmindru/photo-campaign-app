//
//  homeViewController.m
//  photoCampaign
//
//  Created by Dan Mindru on 10/05/14.
//  Copyright (c) 2014 Dan Mindru. All rights reserved.
//

#import "homeViewController.h"
#import "AFNetworking.h"
#import "DateTools.h"
#import "postTableViewCell.h"
#import "statics.h"

@interface homeViewController (){
	NSMutableArray *loadedUserObject;
	NSMutableArray *loadedPostObjects;
}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *accountButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *photoButton;
@property CGPoint lastContentOffset;

@end

@implementation homeViewController

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
	
	//setup refresh
	UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
	[refresh addTarget:self action:@selector(httpLoadPostData) forControlEvents:UIControlEventValueChanged];
	self.refreshControl = refresh;
	
	//additional table view setup
	[self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
	//read the user and change the text of the top left account button
	NSString *userPlistURL = [user getPlistURL];
	loadedUserObject = [user readFromPlist:userPlistURL];
	NSArray *allUserData = [loadedUserObject objectAtIndex:0];
	
	[self.accountButton setTitle:[[NSString alloc] initWithFormat:@"%@ %@", [allUserData valueForKey:@"firstName"], [allUserData valueForKey:@"lastName"]]];
	
	//load posts
	[self httpLoadPostData];
}

#pragma mark - Table View methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return [loadedPostObjects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	//setup cell identifier and init cell
	static NSString *CellIdentifier = @"defaultPostCell";
	postTableViewCell *oneCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	//load the corresponding post data
	post *currentPost = [loadedPostObjects objectAtIndex:indexPath.row];
	
	//cancel the cell selected background
	oneCell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	//create image view and load the post image (and the rest of the data) in a separate thread for smooth scrolling
	//set a image placeholder before the async call will be performed
	UIImage *placeholderPhoto = [UIImage imageNamed:@"image-placeholder"];
	[oneCell.postImage setImage:placeholderPhoto];
	
	//run async block
	dispatch_queue_t queue = dispatch_queue_create("com.photoCampaign.postImageQueue", NULL);
	dispatch_async(queue, ^{
		//load the image from photocampaign.net
		NSString *urlString = [[NSString alloc] initWithFormat:@"%@%@%@", REQUEST_URL, IMAGE_BASE_SLUG, [currentPost photoURL]];
		NSURL *photoURL = [[NSURL alloc] initWithString:urlString];
		UIImage *loadedPostPhoto = [UIImage imageWithData:[NSData dataWithContentsOfURL:photoURL]];
		
		//update UI after image load
		dispatch_async(dispatch_get_main_queue(), ^{
			//update the UI on the main thread
			[oneCell.postImage setClipsToBounds:YES];
			[oneCell.postImage setImage:loadedPostPhoto];
			//set imageview to scale image to it's frame
			[oneCell.postImage setContentMode:UIViewContentModeScaleAspectFill];
			
			//trigger display update
			[oneCell.postImage setNeedsDisplay];
			[oneCell.postImage setNeedsLayout];
		});
	});
	
	//update post author label
	oneCell.postAuthor.text = [NSString stringWithFormat:@"%@ %@", [currentPost authorFirstName], [currentPost authorLastName]];
	
	//load relative time of post
		//convert the JSON date first
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
		NSDate *postCreatedDate = [dateFormatter dateFromString:[currentPost created]];
		//convert to relative post date
		NSString *relativePostDate = postCreatedDate.timeAgoSinceNow;
	//update label
	oneCell.postDate.text = relativePostDate;
	
	//update title of the post
	oneCell.postTitle.text = [currentPost title];
		
	return oneCell;
}

//set cell height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	//cell height defined in IB
	return  390;
}

- (void) httpLoadPostData{
	//load post data
	NSString *loginString = [[NSString alloc] initWithFormat:@"%@%@", REQUEST_URL, POST_FEED];
	
	NSArray *allUserData = [loadedUserObject objectAtIndex:0];
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	NSDictionary *params = @{@"campaignObject":[allUserData valueForKey:@"campaign"]};
	
	[manager GET:loginString parameters:params
		 success:^(AFHTTPRequestOperation *operation, id responseObject) {
			 //save post data and then trigger child table view population method
			 for(NSArray* onePost in responseObject){
				 //instantiate post object
				 post* postToSave = [[post alloc] initWithId:[onePost valueForKey:@"_id"] andCampaignIdentifier:[[onePost valueForKey:@"campaignObject" ] valueForKey:@"identifier"] andTitle:[onePost valueForKey:@"title"] andDescription:[onePost valueForKey:@"description"]  andPhotoURL:[onePost valueForKey:@"photoURL"] andCreated:[onePost valueForKey:@"created"] andAuthorFirstName:[[onePost valueForKey:@"owner"] valueForKey:@"firstName"] andAuthorLastName:[[onePost valueForKey:@"owner"] valueForKey:@"lastName"]];
				 
				 //get post url
				 NSString* postPlistURL = [post getPlistURL];
				 [postToSave saveToPlist:postPlistURL];
			 }
			 
			 [self reloadPostFeed];
			 
			 //log JSON response
			 //NSLog(@"Campaign success JSON: %@", responseObject);
		 }
		 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
			 UIAlertView *accountAlert = [[UIAlertView alloc] initWithTitle:@"Problem reading feed" message:@"Cannot read the campaign post feed. Please make sure there is an active internet connection" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
			 
			 [accountAlert show];
			 
			 //NSLog(@"Campaign feed Error: %@", error);
		 }
	 ];

}

- (void) reloadPostFeed{
	//initialize the loaded posts array
	loadedPostObjects = [[NSMutableArray alloc] init];
	NSString *postURL = [post getPlistURL];
	loadedPostObjects = [post readFromPlist:postURL];
	
	//sort elements by 'created' date
	NSSortDescriptor *sortDescriptor;
	sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"created"
												 ascending:NO];
	NSMutableArray *sortDescriptors = [NSMutableArray arrayWithObject:sortDescriptor];
	NSArray *sortedArray;
	sortedArray = [loadedPostObjects sortedArrayUsingDescriptors:sortDescriptors];
	NSMutableArray *finalPostData = [[NSMutableArray alloc] initWithArray:sortedArray];
	loadedPostObjects = finalPostData;
	
	//populate table view
	[self.tableView reloadData];
	
	//stop refresh animation
	[self.refreshControl endRefreshing];
}

@end
