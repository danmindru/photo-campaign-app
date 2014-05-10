//
//  homeViewController.m
//  photoCampaign
//
//  Created by Dan Mindru on 10/05/14.
//  Copyright (c) 2014 Dan Mindru. All rights reserved.
//

#import "homeViewController.h"

@interface homeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;

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
	self.welcomeLabel.text = [[NSString alloc] initWithFormat:@"Welcome %@", [[self.userObject objectAtIndex:0] valueForKey:@"firstName"]];
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
