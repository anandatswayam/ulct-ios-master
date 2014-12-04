//
//  DrillDownViewController.m
//  ultc
//
//  Created by Matthew Shultz on 5/23/13.
//
//

#import "DrillDownViewController.h"
#import <MapKit/MapKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "WRUtilities.h"
#import "ContentViewController.h"
#import "SplitFinalTierViewController.h"



@interface DrillDownViewController () <MFMailComposeViewControllerDelegate>

@end

@implementation DrillDownViewController
@synthesize datatype;
@synthesize entityBrowseController;
@synthesize splitFinalTierViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    if(nibNameOrNil != nil){
        self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    } else {
        self = [super initWithNibName:@"DrillDownViewController" bundle:nibBundleOrNil];
    }
    
    if (self) {
        _isPenultimate = false;
        splitFinalTierViewController = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Any time we actually look at a page, log it as a recent
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) pushViewController: (UIViewController *) vc {
    
    // if the viewController is a DrillDownViewController then push it on the drill down nav
    if( [vc isKindOfClass:[DrillDownViewController class]]){
        DrillDownViewController * ddvc =(DrillDownViewController *) vc;
        if (ddvc.isPenultimate == TRUE &&
            [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad ) {
            
            SplitFinalTierViewController * splitvc = [[SplitFinalTierViewController alloc] init];
            splitvc.drillDownViewController = ddvc;
            ddvc.splitFinalTierViewController = splitvc;
            [splitvc addChildViewController:ddvc];
            
            [self.navigationController pushViewController:splitvc animated:YES];
            [self.navigationController addChildViewController:splitvc];
            
        } else {
         
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        
    } else if( [vc isKindOfClass:[ContentViewController class]]) {
        
        ContentViewController * cvc = (ContentViewController *) vc;
        cvc.entityBrowseController = entityBrowseController;
      
        if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad ){
            
            if(self.splitFinalTierViewController != nil){
                // if it's ipad, put it into the content view
                [[self.splitFinalTierViewController.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
                self.splitFinalTierViewController.contentViewController = (ContentViewController*) vc;
                UIView * view = [vc view];
                [self.splitFinalTierViewController.contentView addSubview: view];
                [self.splitFinalTierViewController addChildViewController:vc];
                
                CGRect frame = self.splitFinalTierViewController.contentView.frame;
                //frame.size.height = 768;
                self.splitFinalTierViewController.contentView.frame = frame;
                
                self.splitFinalTierViewController.contentViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;


            } else {
                [self.navigationController pushViewController:vc animated:YES];
                
            }
        }
        
    
        // if it's a contentViewController subclass, then display it
        else  {
         
            // if it's iphone, push it
            [self.navigationController pushViewController:vc animated:YES];
            
            
        }
    }
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    /*
    if(self.splitFinalTierViewController != nil){
        if(UIDeviceOrientationIsPortrait([[UIDevice currentDevice] orientation])){
            CGRect frame = self.splitFinalTierViewController.drillDownView.frame;
            frame.size.height = 1024;
            frame.size.width = 768 / 2;
            self.view.frame = frame;
            
        } else {
            CGRect frame = self.splitFinalTierViewController.drillDownView.frame;
            frame.size.height = 768;
            frame.size.width = 512;
            self.view.frame = frame;
            
        }
        
    }
     */
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kIdentifier];
    }
    cell.textLabel.text = @"";
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void) openAddressInMap:(NSString *) address {
    
    // Check for iOS 6
    Class mapItemClass = [MKMapItem class];
    if (mapItemClass && [mapItemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)])
    {
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder geocodeAddressString:@"address"
                     completionHandler:^(NSArray *placemarks, NSError *error) {
                         
                         // Convert the CLPlacemark to an MKPlacemark
                         // Note: There's no error checking for a failed geocode
                         CLPlacemark *geocodedPlacemark = [placemarks objectAtIndex:0];
                         MKPlacemark *placemark = [[MKPlacemark alloc]
                                                   initWithCoordinate:geocodedPlacemark.location.coordinate
                                                   addressDictionary:geocodedPlacemark.addressDictionary];
                         
                         // Create a map item for the geocoded address to pass to Maps app
                         MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
                         [mapItem setName:geocodedPlacemark.name];
                         
                         // Set the directions mode to "Driving"
                         // Can use MKLaunchOptionsDirectionsModeWalking instead
                         NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
                         
                         // Get the "Current User Location" MKMapItem
                         MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];
                         
                         // Pass the current location and destination map items to the Maps app
                         // Set the direction mode in the launchOptions dictionary
                         [MKMapItem openMapsWithItems:@[currentLocationMapItem, mapItem] launchOptions:launchOptions];
                         
                     }];
    }
    
}


- (void) callPhoneNumber:(NSString *) phoneNumber {
    NSString *usePhoneNumber = phoneNumber; // dynamically assigned
    NSString *phoneURLString = [NSString stringWithFormat:@"tel:%@", usePhoneNumber];
    NSURL *phoneURL = [NSURL URLWithString:phoneURLString];
    [[UIApplication sharedApplication] openURL:phoneURL];
    
}

- (void) composeEmail:(NSString *) emailAddress {
    
    if ([MFMailComposeViewController canSendMail]) {
        
        MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        [controller setSubject:@""];
        [controller setMessageBody:@"" isHTML:NO];
        if (controller) {
            [self presentViewController:controller animated:YES completion:nil];
        }
        
    } else {
        // Do Nothing
    }
}


- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
        //NSLog(@"It's away!");
    }
    //[self dismissModalViewControllerAnimated:YES];
}
@end
