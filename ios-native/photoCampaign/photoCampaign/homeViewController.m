//
//  homeViewController.m
//  photoCampaign
//
//  Created by Dan Mindru on 10/05/14.
//  Copyright (c) 2014 Dan Mindru. All rights reserved.
//

#import "homeViewController.h"

@interface homeViewController (){
	NSMutableArray *loadedUserObject;
}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *accountButton;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
	NSString *userPlistURL = [user getPlistURL];
	loadedUserObject = [user readFromPlist:userPlistURL];
	
	[self.accountButton setTitle:[[NSString alloc] initWithFormat:@"%@ %@", [[loadedUserObject objectAtIndex:0] valueForKey:@"firstName"], [[loadedUserObject objectAtIndex:0] valueForKey:@"lastName"]]];
}

- (IBAction)touchAccountName:(id)sender {
}

- (IBAction)logoutAction:(id)sender {
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
