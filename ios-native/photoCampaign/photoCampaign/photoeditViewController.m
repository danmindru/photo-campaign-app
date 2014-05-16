//
//  photoeditViewController.m
//  photoCampaign
//
//  Created by Dan Mindru on 16/05/14.
//  Copyright (c) 2014 Dan Mindru. All rights reserved.
//

#import "photoeditViewController.h"

@interface photoeditViewController ()

@property UIImage * photo;
@property IBOutlet UIImageView * selectedPhotoView;

@end

@implementation photoeditViewController

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
	
	//use black background
	[self.view setBackgroundColor:[UIColor blackColor]];
	
	//apply photo
	self.photo = self.photoInfo[UIImagePickerControllerOriginalImage];
	//adjust the imageView to fit all photos
	[self.selectedPhotoView setContentMode:UIViewContentModeScaleAspectFill];
	//add photo to view
	[self.selectedPhotoView setImage:self.photo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden{
	return YES;
}

- (IBAction)goToPublishing:(id)sender {
}

- (IBAction)cancelEditingAction:(id)sender {
	//set the view controller as homeStoryboard
	UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"mainStoryboard" bundle:nil];
	homeNavController *homeNavVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"homeNavVC"];
	
	//animate to view controller
	[(UINavigationController*)self presentViewController:homeNavVC animated:YES completion:nil];
}

#pragma mark - Photo filters

- (IBAction)sepiaEffect:(id)sender {
	CIFilter *filter = [CIFilter filterWithName:@"CISepiaTone"];
	
	[self setFilter:filter];
}

- (IBAction)transferEffect:(id)sender {
	CIFilter *filter = [CIFilter filterWithName:@"CIPhotoEffectTransfer"];
	
	[self setFilter:filter];
}

- (IBAction)noirEffect:(id)sender {
	CIFilter *filter = [CIFilter filterWithName:@"CIPhotoEffectNoir"];
	
	[self setFilter:filter];
}


- (IBAction)tonalEffect:(id)sender {
	CIFilter *filter = [CIFilter filterWithName:@"CIPhotoEffectTonal"];
	
	[self setFilter:filter];
}

- (IBAction)fadeEffect:(id)sender {
	CIFilter *filter = [CIFilter filterWithName:@"CIPhotoEffectFade"];
	
	[self setFilter:filter];
}

- (IBAction)processEffect:(id)sender {
	CIFilter *filter = [CIFilter filterWithName:@"CIPhotoEffectProcess"];
	
	[self setFilter:filter];
}

- (IBAction)toneEffect:(id)sender {
	CIFilter *filter = [CIFilter filterWithName:@"CIPhotoEffectMono"];
	
	[self setFilter:filter];
}


- (IBAction)noEffect:(id)sender {
	[self.selectedPhotoView setImage:self.photo];
}

- (void)setFilter:(CIFilter *)filter{
	CIContext *context = [CIContext contextWithOptions:nil];
	[filter setValue:[[CIImage alloc] initWithImage:self.photo] forKey:kCIInputImageKey];
	//[filter setValue:@0.8f forKey:kCIInputIntensityKey];
	CIImage* result = [filter valueForKey:kCIOutputImageKey];
	CGRect extent = [result extent];
	CGImageRef cgImageRef = [context createCGImage:result fromRect:extent];
	UIImage* filteredPhoto = [UIImage imageWithCGImage:cgImageRef scale:1 orientation:self.photo.imageOrientation];
	[self.selectedPhotoView setImage:filteredPhoto];
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
