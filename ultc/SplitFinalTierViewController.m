//
//  SplitFinalTierViewController.m
//  ulct
//
//  Created by Matthew Shultz on 10/26/13.
//
//

#import "SplitFinalTierViewController.h"

@interface SplitFinalTierViewController ()

@property (nonatomic) CGRect originalDrillDownViewFrame;


@end



@implementation SplitFinalTierViewController

@synthesize drillDownViewController, contentViewController, drillDownView, contentView;

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
    
    
    self.originalDrillDownViewFrame = drillDownView.frame;
    
    [self addChildViewController:drillDownViewController];
    
    /*
    CGRect frame = drillDownView.frame;
    UIView * ddView =[drillDownViewController view];
    ddView.frame = frame;
    [drillDownView addSubview:ddView];
    */
    UIView * ddView =[drillDownViewController view];
    
    CGRect frame = drillDownView.frame;
   /* if(UIDeviceOrientationIsPortrait([[UIDevice currentDevice] orientation])){
        frame.size.width = 768 / 2;
        frame.size.height = 1024;
    } else { */
        frame.size.width = 320;
        frame.size.height = 768;
    //}
    ddView.frame = frame;
    [drillDownView addSubview:ddView];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    
    UIView * ddView =[drillDownViewController view];
    CGRect frame = drillDownView.frame;
    if(UIDeviceOrientationIsPortrait([[UIDevice currentDevice] orientation])){
        frame.size.width = 320;
        frame.size.height = 1024;
    } else {
        frame.size.width = 320;
        frame.size.height = 768;
    }
    ddView.frame = frame;

    
    drillDownViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    if(UIDeviceOrientationIsLandscape(fromInterfaceOrientation)){
        drillDownView.frame = self.view.frame;
        UIView * ddView =[drillDownViewController view];
        ddView.frame = drillDownView.frame;
    } else {
        drillDownView.frame = self.originalDrillDownViewFrame;
        UIView * ddView =[drillDownViewController view];
        ddView.frame = drillDownView.frame;

    }
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
