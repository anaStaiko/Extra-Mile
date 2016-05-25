//
//  HeartRateViewController.m
//  Tracker_1
//
//  Created by Anastasiia Staiko on 3/23/16.
//  Copyright © 2016 Anastasiia Staiko. All rights reserved.
//

#import "HeartRateViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "PulseDetector.h"
#import "Filter.h"

typedef NS_ENUM(NSUInteger, CURRENT_STATE) {
    STATE_PAUSED,
    STATE_SAMPLING
};

#define MIN_FRAMES_FOR_FILTER_TO_SETTLE 10

@interface HeartRateViewController () <AVCaptureVideoDataOutputSampleBufferDelegate>

@property(nonatomic, strong) AVCaptureSession *session;
@property(nonatomic, strong) AVCaptureDevice *camera;
@property(nonatomic, strong) PulseDetector *pulseDetector;
@property(nonatomic, strong) Filter *filter;
@property(nonatomic, assign) CURRENT_STATE currentState;
@property(nonatomic, assign) int validFrameCounter;
@property(nonatomic, strong) IBOutlet UILabel *pulseRate;
@property(nonatomic, strong) IBOutlet UILabel *validFrames;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityInd;

- (IBAction)startBtn:(id)sender;
- (IBAction)stopBtn:(id)sender;

@end

@implementation HeartRateViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor darkGrayColor] forKey:NSForegroundColorAttributeName]];
    self.activityInd.hidden = YES;
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self resume];
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [self pause];
    [self.session stopRunning];
    self.session=nil;
    
}


// Check if camera is available and start camera capture
-(void) startCameraCapture {
    
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO)) {
        self.session = nil;
    } else {
        // Create the AVCapture Session
        self.session = [[AVCaptureSession alloc] init];
    }
    
    // Get the default camera device
    self.camera = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // switch on torch mode - can't detect the pulse without it
    if([self.camera isTorchModeSupported:AVCaptureTorchModeOn]) {
        [self.camera lockForConfiguration:nil];
        self.camera.torchMode=AVCaptureTorchModeOn;
        [self.camera unlockForConfiguration];
    }
    // Create a AVCaptureInput with the camera device
    NSError *error=nil;
    AVCaptureInput* cameraInput = [[AVCaptureDeviceInput alloc] initWithDevice:self.camera error:&error];
    if (cameraInput == nil) {
        NSLog(@"Error to create camera capture:%@",error);
    }
    
    // Set the output
    AVCaptureVideoDataOutput* videoOutput = [[AVCaptureVideoDataOutput alloc] init];
    
    // create a queue to run the capture on
    dispatch_queue_t captureQueue=dispatch_queue_create("captureQueue", NULL);
    
    // setup ourself up as the capture delegate
    [videoOutput setSampleBufferDelegate:self queue:captureQueue];
    
    // configure the pixel format
    videoOutput.videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA], (id)kCVPixelBufferPixelFormatTypeKey, nil];

    [self.camera lockForConfiguration:nil];
        // set the minimum acceptable frame rate to 10 fps
    self.camera.activeVideoMinFrameDuration =CMTimeMake(1, 10);
    
    // the size of the frames
    [self.session setSessionPreset:AVCaptureSessionPresetLow];
    
    // Add the input and output
    [self.session addInput:cameraInput];
    [self.session addOutput:videoOutput];
    
    // Start the session
    [self.session startRunning];
    
    // sampling from the camera
    self.currentState=STATE_SAMPLING;
    
    // stop the app from sleeping
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    // update our UI on a timer every 0.1 seconds
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(update) userInfo:nil repeats:YES];
}

-(void) stopCameraCapture {

    [self.session stopRunning];
    self.session=nil;
}

#pragma mark Pause and Resume of pulse detection
-(void) pause {
    if(self.currentState==STATE_PAUSED) return;
    
    // switch off the torch
    if([self.camera isTorchModeSupported:AVCaptureTorchModeOn]) {
        [self.camera lockForConfiguration:nil];
        self.camera.torchMode=AVCaptureTorchModeOff;
        [self.camera unlockForConfiguration];
    }
    self.currentState=STATE_PAUSED;
    // let the application go to sleep if the phone is idle
    [UIApplication sharedApplication].idleTimerDisabled = NO;
}

-(void) resume {
    if(self.currentState!=STATE_PAUSED) return;
    
    // switch on the torch
    if([self.camera isTorchModeSupported:AVCaptureTorchModeOn]) {
        [self.camera lockForConfiguration:nil];
        self.camera.torchMode=AVCaptureTorchModeOn;
        [self.camera unlockForConfiguration];
    }
    self.currentState=STATE_SAMPLING;
    // stop the app from sleeping
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

// r,g,b values are from 0 to 1 // h = [0,360], s = [0,1], v = [0,1]
//	if s == 0, then h = -1 (undefined)
void RGBtoHSV( float r, float g, float b, float *h, float *s, float *v ) {
    float min, max, delta;
    min = MIN( r, MIN(g, b ));
    max = MAX( r, MAX(g, b ));
    *v = max;
    delta = max - min;
    if( max != 0 )
        *s = delta / max;
    else {
        // r = g = b = 0
        *s = 0;
        *h = -1;
        return;
    }
    if( r == max )
        *h = ( g - b ) / delta;
    else if( g == max )
        *h=2+(b-r)/delta;
    else
        *h=4+(r-g)/delta;
    *h *= 60;
    if( *h < 0 )
        *h += 360;
}

// process the frame of video
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    // if we're paused don't do anything
    if(self.currentState==STATE_PAUSED) {
        // reset our frame counter
        self.validFrameCounter=0;
        return;
    }

    // image buffer
    CVImageBufferRef cvimgRef = CMSampleBufferGetImageBuffer(sampleBuffer);
    // lock the image buffer
    CVPixelBufferLockBaseAddress(cvimgRef,0);
    // access the data
    size_t width=CVPixelBufferGetWidth(cvimgRef);
    size_t height=CVPixelBufferGetHeight(cvimgRef);
    // get the raw image bytes
    uint8_t *buf=(uint8_t *) CVPixelBufferGetBaseAddress(cvimgRef);
    size_t bprow=CVPixelBufferGetBytesPerRow(cvimgRef);
    // and pull out the average rgb value of the frame
    float r=0,g=0,b=0;
    for(int y=0; y<height; y++) {
        for(int x=0; x<width*4; x+=4) {
            b+=buf[x];
            g+=buf[x+1];
            r+=buf[x+2];
        }
        buf+=bprow;
    }
    r/=255*(float) (width*height);
    g/=255*(float) (width*height);
    b/=255*(float) (width*height);
    // convert from rgb to hsv colourspace
    float h,s,v;
    RGBtoHSV(r, g, b, &h, &s, &v);
    // check to see if a finger is placed over the camera
    if(s>0.5 && v>0.5) {
        // increment the valid frame count
        self.validFrameCounter++;

        // filter the hue value
        float filtered=[self.filter processValue:h];
 
        if(self.validFrameCounter > MIN_FRAMES_FOR_FILTER_TO_SETTLE) {
            // add the new value to the pulse detector
            [self.pulseDetector addNewValue:filtered atTime:CACurrentMediaTime()];
        }
    } else {
        self.validFrameCounter = 0;
        // clear the pulse detector
        [self.pulseDetector reset];
    }
}



-(void) update {
    
    self.validFrames.text = [NSString stringWithFormat:@"Processing: %d%%", MIN(100, (100 * self.validFrameCounter)/MIN_FRAMES_FOR_FILTER_TO_SETTLE)];
    
    if (self.validFrameCounter != 0) {
        self.activityInd.hidden = NO;
        [self.activityInd startAnimating];
    } else {
        self.activityInd.hidden = YES;
        [self.activityInd stopAnimating];
    }
    
    // if paused then there's nothing to do
    if(self.currentState==STATE_PAUSED) return;
    
    // get the average period of the pulse rate from the pulse detector
    float avePeriod=[self.pulseDetector getAverage];
    if(avePeriod==INVALID_PULSE_PERIOD) {
        // no value available
        self.pulseRate.text=@"--";
           } else {
        // got a value so show it
        float pulse=60.0/avePeriod;
        self.pulseRate.text=[NSString stringWithFormat:@"%0.0f", pulse];
        self.activityInd.hidden = YES;
        [self.activityInd stopAnimating];
    }
}


- (IBAction)startBtn:(id)sender {
    
    self.filter=[[Filter alloc] init];
    self.pulseDetector=[[PulseDetector alloc] init];
    [self startCameraCapture];
}

- (IBAction)stopBtn:(id)sender {
    
    [self.session stopRunning];
    self.session=nil;
}




@end
