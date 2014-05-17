//
//  photoeditViewController.m
//  photoCampaign
//
//  Created by Dan Mindru on 16/05/14.
//  Copyright (c) 2014 Dan Mindru. All rights reserved.
//

#import "photoeditViewController.h"
#import "post.h"

@interface photoeditViewController (){
	CIContext *currentContext;
	CIImage *filterResult;
	UIImage *filteredUIImage;
}

@property UIImage * photo;
@property IBOutlet UIImageView * selectedPhotoView;
@property NSMutableArray * allImages;

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
	
	//apply photo (resized to half)
	self.photo = self.photoInfo[UIImagePickerControllerOriginalImage];
	UIImage *resizedPhoto = [post imageWithImage:self.photo scaledToSize:CGSizeMake(self.photo.size.width/2, self.photo.size.height/2)];
	self.photo = resizedPhoto;
	
	//adjust the imageView to fit all photos
	[self.selectedPhotoView setContentMode:UIViewContentModeScaleAspectFill];
	//add photo to view
	[self.selectedPhotoView setImage:self.photo];
	
	//move all images types into a dictionary
	//define filtered images
	UIImage *tonalImage = [UIImage new];
	UIImage *noirImage = [UIImage new];
	UIImage *fadeImage = [UIImage new];
	UIImage *processImage = [UIImage new];
	UIImage *monoImage = [UIImage new];
	UIImage *transferImage = [UIImage new];
	UIImage *sepiaImage = [UIImage new];
	self.allImages = [[NSMutableArray alloc] initWithArray:	@[tonalImage, noirImage, fadeImage, processImage, monoImage, transferImage, sepiaImage]];
	
	//load all the other photo variations
	[self loadPhotosWithEffects];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden{
	return YES;
}

#pragma mark - Photo filters

- (IBAction)sepiaEffect:(id)sender {
	[self.selectedPhotoView setImage:[self.allImages objectAtIndex:6]];
}

- (IBAction)transferEffect:(id)sender {
	[self.selectedPhotoView setImage:[self.allImages objectAtIndex:5]];
}

- (IBAction)noirEffect:(id)sender {
	[self.selectedPhotoView setImage:[self.allImages objectAtIndex:1]];
}


- (IBAction)tonalEffect:(id)sender {
	[self.selectedPhotoView setImage:[self.allImages objectAtIndex:0]];
}

- (IBAction)fadeEffect:(id)sender {
	[self.selectedPhotoView setImage:[self.allImages objectAtIndex:2]];
}

- (IBAction)processEffect:(id)sender {
	[self.selectedPhotoView setImage:[self.allImages objectAtIndex:3]];
}

- (IBAction)monoEffect:(id)sender {
	[self.selectedPhotoView setImage:[self.allImages objectAtIndex:4]];
}


- (IBAction)noEffect:(id)sender {
	[self.selectedPhotoView setImage:self.photo];
}

- (void)loadPhotosWithEffects{
	CIFilter *sepiaFilter = [CIFilter filterWithName:@"CISepiaTone"];
	CIFilter *transferFilter = [CIFilter filterWithName:@"CIPhotoEffectTransfer"];
	CIFilter *noirFilter = [CIFilter filterWithName:@"CIPhotoEffectNoir"];
	CIFilter *tonalFilter = [CIFilter filterWithName:@"CIPhotoEffectTonal"];
	CIFilter *fadeFilter = [CIFilter filterWithName:@"CIPhotoEffectFade"];
	CIFilter *processFilter = [CIFilter filterWithName:@"CIPhotoEffectProcess"];
	CIFilter *monoFilter = [CIFilter filterWithName:@"CIPhotoEffectMono"];

	NSArray *allFilters = [[NSArray alloc] initWithObjects: tonalFilter, noirFilter, fadeFilter, processFilter, monoFilter, transferFilter, sepiaFilter, nil];
	
	//run async image load
	dispatch_queue_t queue = dispatch_queue_create("com.photoCampaign.postImageQueue", NULL);
	int filterPosition = 0;
	for(CIFilter *filter in allFilters){
		dispatch_async(queue, ^{
			[self.allImages setObject:[self setFilter:filter] atIndexedSubscript:filterPosition];
		});
		
		filterPosition ++;
	}
}

- (UIImage *)setFilter:(CIFilter*)currentFilter{
	currentContext = [CIContext contextWithOptions:nil];
	[currentFilter setValue:[[CIImage alloc] initWithImage:self.photo] forKey:kCIInputImageKey];
	//[filter setValue:@0.8f forKey:kCIInputIntensityKey];
	filterResult = [currentFilter valueForKey:kCIOutputImageKey];
	CGRect extent = [filterResult extent];
	CGImageRef cgImageRef = [currentContext createCGImage:filterResult fromRect:extent];
	filteredUIImage = [UIImage imageWithCGImage:cgImageRef scale:1 orientation:self.photo.imageOrientation];
	return filteredUIImage;
}

#pragma mark - Navigation

- (IBAction)cancelEditingAction:(id)sender {
	//set the view controller as homeStoryboard
	UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"mainStoryboard" bundle:nil];
	homeNavController *homeNavVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"homeNavVC"];
	
	//animate to view controller
	[(UINavigationController*)self presentViewController:homeNavVC animated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
	if([[segue identifier] isEqualToString:@"publishPost"]){
		photopublishViewController *ppv = [segue destinationViewController];
		//get the selected image and pass the UIImage
		ppv.editedImage = self.selectedPhotoView.image;
	}
}

@end
