//
//  SettingsViewController.m
//  ultc
//
//  Created by Matthew Shultz on 5/23/13.
//
//

#import "SettingsViewController.h"
#import "HelpViewController.h"
#import "AppDelegate.h"

@interface SettingsViewController ()

- (IBAction)didTapLogoutButton:(id)sender;
- (IBAction)didTapClearButton:(id)sender;

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"SettingsViewController" bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Settings";
        self.viewControllers = @[
                                 [[HelpViewController alloc] init]
        ];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleAdminSwipe)];
    [swipe setDirection:UISwipeGestureRecognizerDirectionUp];
    [swipe setDelaysTouchesBegan:YES];
    [swipe setNumberOfTouchesRequired:2];
    [[self view] addGestureRecognizer:swipe];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) handleAdminSwipe
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Force Update" message:@"Attempting force update of database"  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    [[AppDelegate getAppDelegate] updateDatabaseFile];
}


-(IBAction)didTapLogoutButton:(id)sender
{
    [(AppDelegate*) [[UIApplication sharedApplication] delegate] logUserOut];
}

- (IBAction)didTapClearButton:(id)sender
{
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Recent" inManagedObjectContext:[AppDelegate getAppDelegate].managedObjectContext]];
    [request setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError * error = nil;
    NSArray * recents = [[AppDelegate getAppDelegate].managedObjectContext executeFetchRequest:request error:&error];
    //error handling goes here
    if(recents == nil)
    {
        [WRUtilities criticalError:error];
        return;
    }
    for (NSManagedObject * recent in recents)
    {
        [[AppDelegate getAppDelegate].managedObjectContext deleteObject:recent];
    }
    NSError *saveError = nil;
    [[AppDelegate getAppDelegate].managedObjectContext  save:&saveError];
    if(recents == nil)
    {
        [WRUtilities criticalError:error];
        return;
    }
    
    request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Favorite" inManagedObjectContext:[AppDelegate getAppDelegate].managedObjectContext]];
    [request setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    error = nil;
    NSArray * favorites = [[AppDelegate getAppDelegate].managedObjectContext executeFetchRequest:request error:&error];
    //error handling goes here
    if(recents == nil){
        [WRUtilities criticalError:error];
        return;
    }
    for (NSManagedObject * favorite in favorites) {
        [[AppDelegate getAppDelegate].managedObjectContext deleteObject:favorite];
    }
    saveError = nil;
    [[AppDelegate getAppDelegate].managedObjectContext  save:&saveError];
    if(recents == nil){
        [WRUtilities criticalError:error];
        return;
    }
    
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Cleared" message:@"All Favorites and Recents have been cleared" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

@end
