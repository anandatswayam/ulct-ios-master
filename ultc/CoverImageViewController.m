//
//  CoverImageViewController.m
//  ultc
//
//  Created by Matthew Shultz on 5/23/13.
//
//

#import "CoverImageViewController.h"
#import "HelpViewController.h"
#import "AppDelegate.h"

#import "FavoritesTopViewController.h"

@interface CoverImageViewController ()

- (IBAction)didTapLogoutButton:(id)sender;
- (IBAction)didTapClearButton:(id)sender;

@end

@implementation CoverImageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"CoverImageViewController" bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"Welcome";
        self.viewControllers = @[[[HelpViewController alloc] init]];
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

- (void) handleAdminSwipe {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Force Update" message:@"Attempting force update of database"  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    [[AppDelegate getAppDelegate] updateDatabaseFile];
}


-(IBAction)didTapLogoutButton:(id)sender {
    [(AppDelegate*) [[UIApplication sharedApplication] delegate] logUserOut];
}

- (IBAction)didTapClearButton:(id)sender {
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Recent" inManagedObjectContext:[AppDelegate getAppDelegate].managedObjectContext]];
    [request setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError * error = nil;
    NSArray * recents = [[AppDelegate getAppDelegate].managedObjectContext executeFetchRequest:request error:&error];
    //error handling goes here
    if(recents == nil){
        [WRUtilities criticalError:error];
        return;
    }
    for (NSManagedObject * recent in recents) {
        [[AppDelegate getAppDelegate].managedObjectContext deleteObject:recent];
    }
    NSError *saveError = nil;
    [[AppDelegate getAppDelegate].managedObjectContext  save:&saveError];
    if(recents == nil){
        [WRUtilities criticalError:error];
        return;
    }
    
    request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Favorite" inManagedObjectContext:[AppDelegate getAppDelegate].managedObjectContext]];
    [request setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    error = nil;
    NSArray * favorites = [[AppDelegate getAppDelegate].managedObjectContext executeFetchRequest:request error:&error];
    //error handling goes here
    if(recents == nil)
    {
        [WRUtilities criticalError:error];
        return;
    }
    
    for (NSManagedObject * favorite in favorites)
    {
        [[AppDelegate getAppDelegate].managedObjectContext deleteObject:favorite];
    }
    
    saveError = nil;
    [[AppDelegate getAppDelegate].managedObjectContext  save:&saveError];
    if(recents == nil)
    {
        [WRUtilities criticalError:error];
        return;
    }
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Cleared" message:@"All Favorites and Recents have been cleared" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    NSMutableArray * tmp = [[NSMutableArray alloc] initWithArray:[AppDelegate getAppDelegate].tabBarController.viewControllers];
    
    //
    
    EntityBrowseController *viewController1 = [[EntityBrowseController alloc] initWithNibName:@"EntityBrowseController" bundle:nil];
    
    FavoritesTopViewController * d1 = [[FavoritesTopViewController alloc] init];
    viewController1.rootDrillDownViewController = d1;
    viewController1.view.frame = self.tabBarController.view.bounds;
    
    UITabBarItem * tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Home" image:[UIImage imageNamed:@"button-favorites"]  tag:1];
    [viewController1 setTabBarItem:tabBarItem];
    
    [tmp setObject:viewController1 atIndexedSubscript:0];
    
    [AppDelegate getAppDelegate].tabBarController.viewControllers=tmp;
    
}

@end