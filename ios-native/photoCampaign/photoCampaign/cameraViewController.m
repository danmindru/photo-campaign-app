//
//  cameraViewController.m
//  photoCampaign
//
//  Created by Dan Mindru on 15/05/14.
//  Copyright (c) 2014 Dan Mindru. All rights reserved.
//

#import "cameraViewController.h"
@import CoreImage;

@interface cameraViewController ()

@end

@implementation cameraViewController

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

- (void)viewDidAppear:(BOOL)animated{
	UIImagePickerController*cameraPicker = [[UIImagePickerController alloc] init];
	cameraPicker.delegate = self;
	
	if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
		cameraPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
		cameraPicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
		cameraPicker.cameraDevice= UIImagePickerControllerCameraDeviceRear;
		cameraPicker.showsCameraControls = YES;
	}
	else{
		cameraPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	}
		cameraPicker.navigationBarHidden = NO;
	[self presentViewController:cameraPicker animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Camera methods (and gallery) - also navigation to edit scene
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
	//navigate to editing controller
	UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"mainStoryboard" bundle:nil];
	photoeditViewController *photoNavVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"photoNavVC"];
	photoNavVC.photoInfo = info;
	
	[(UINavigationController*)picker presentViewController:photoNavVC animated:YES completion:nil];
}

#pragma mark - Navigation
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
	//navigate back to feed
	UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"mainStoryboard" bundle:nil];
	homeNavController *homeNavVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"homeNavVC"];
	
	[(UINavigationController*)picker presentViewController:homeNavVC animated:YES completion:nil];
}

@end
