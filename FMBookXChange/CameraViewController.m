//
//  CameraViewController.m
//  FMBookXChange
//
//  Created by Julio Salamanca on 3/25/14.
//  Copyright (c) 2014 Julio Salamanca. All rights reserved.
//

#import "CameraViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <QuartzCore/QuartzCore.h>
#import "SecondViewController.h"
@interface CameraViewController ()



@property AVCaptureSession *session;
@property AVCaptureDevice *device;
@property AVCaptureDeviceInput *input;
@property AVCaptureMetadataOutput *output;
@property AVCaptureVideoPreviewLayer *prevLayer;
@property UIButton * closeCameraButton;
@property AVCaptureStillImageOutput * imageOutput;

@property UIView *_highlightView;
@property UIView * buttonLayers;
@property NSString *detectionString;

@property IBOutlet UILabel *isbnLabel;
  //@property CameraFocusSquare * camFocus;


@property (nonatomic) dispatch_queue_t sessionQueue; // Communicate with the session and other session objects on this queue.



@end

@implementation CameraViewController

@synthesize delegate;

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
  
  [self.tabBarController.tabBar setHidden:YES];


  _session = [[AVCaptureSession alloc] init];

  _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
  NSError * error;
  _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:&error];
  if (_input) {
    [_session addInput:_input];
  } else {
    NSLog(@"Error: %@", error);
  }
  
    //Set session up outputs
  _output = [[AVCaptureMetadataOutput alloc] init];
  [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
  [_session addOutput:_output];
  _output.metadataObjectTypes = [_output availableMetadataObjectTypes];
  
  _imageOutput = [[AVCaptureStillImageOutput alloc]init];
  if ([_session canAddOutput:_imageOutput])
      {
    [_imageOutput setOutputSettings:@{AVVideoCodecKey : AVVideoCodecJPEG}];
    [_session addOutput:_imageOutput];
      }


  _prevLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
  _prevLayer.frame = self.view.bounds;
  _prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
  [self.view.layer addSublayer:_prevLayer];
  _buttonLayers.frame = self.view.bounds;
  [self.view.layer insertSublayer:_prevLayer atIndex:0];

  

  [_session startRunning];
  
  
    
}


- (IBAction)snapStillImage:(id)sender
{
      // Update the orientation on the still image output video connection before capturing.
      //[[[self imageOutput] connectionWithMediaType:AVMediaTypeVideo] setVideoOrientation:[[(AVCaptureVideoPreviewLayer *)[[self prevLayer] layer] connection] videoOrientation]];
		
      // Flash set to Auto for Still Capture
      //[AVCamViewController setFlashMode:AVCaptureFlashModeAuto forDevice:[[self videoDeviceInput] device]];
		
      // Capture a still image.
		[[self imageOutput] captureStillImageAsynchronouslyFromConnection:[[self imageOutput] connectionWithMediaType:AVMediaTypeVideo] completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
			
			if (imageDataSampleBuffer)
          {
				NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
				UIImage *image = [[UIImage alloc] initWithData:imageData];
				[[[ALAssetsLibrary alloc] init] writeImageToSavedPhotosAlbum:[image CGImage] orientation:(ALAssetOrientation)[image imageOrientation] completionBlock:nil];
          }
		}];

}



- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
  CGRect highlightViewRect = CGRectZero;
  AVMetadataMachineReadableCodeObject *barCodeObject;
  _detectionString = nil;
  NSArray *barCodeTypes = @[AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code,
                            AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code,
                            AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode];
  
  for (AVMetadataObject *metadata in metadataObjects) {
    for (NSString *type in barCodeTypes) {
      if ([metadata.type isEqualToString:type])
          {
        barCodeObject = (AVMetadataMachineReadableCodeObject *)[_prevLayer transformedMetadataObjectForMetadataObject:(AVMetadataMachineReadableCodeObject *)metadata];
        highlightViewRect = barCodeObject.bounds;
        _detectionString = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
        break;
          }
    }
    
    if (_detectionString != nil)
        {
      _isbnLabel.text = _detectionString;
      NSLog(@"%@ blah",_detectionString);
      [_session stopRunning];
      
        [self.navigationController popViewControllerAnimated:YES];
      

      

      break;
        }
    else
      _isbnLabel.text = @"(none)";
  }
  
  _isbnLabel.frame = highlightViewRect;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


-(void)viewWillDisappear:(BOOL)animated
{
  [delegate sendDataToA:_detectionString];
  [self.tabBarController.tabBar setHidden:NO];

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  NSLog(@"yo");
  SecondViewController * vc = segue.destinationViewController;
  
  vc.isbn = _isbnLabel.text;
}
@end
