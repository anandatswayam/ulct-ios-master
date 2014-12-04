//
//  AppDelegate.m
//  ultc
//
//  Created by EllIOTTt De Aratanha on 5/1/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "EntityBrowseController.h"
#import "DrillDownViewController.h"
#import "SettingsViewController.h"
#import "TopLevelViewController.h"
#import "FavoritesTopViewController.h"
#import "LoginViewController.h"


#import "CoverImageViewController.h"


#define kLoggedInKey @"kLoggedInKey"

#define REACHABILITY_HOST @"ulctdirectory.com"
#define DATABASE_API @"http://ulctdirectory.com/api/latest?key=3pmqi8xqk1GH9xNh3108oHO68Lc096Z2"
#define LAST_UPDATED_API @"http://ulctdirectory.com/api/last_updated?key=3pmqi8xqk1GH9xNh3108oHO68Lc096Z2"

@implementation AppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;
@synthesize database;

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.database = [self openDatabase];
    
    _reachability =  [SISReachability reachabilityWithHostName:REACHABILITY_HOST ];

    
    // Override point for customization after application launch.
    EntityBrowseController *viewController1, *viewController2, *viewController3;
    //if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        viewController1 = [[EntityBrowseController alloc] initWithNibName:@"EntityBrowseController" bundle:nil];
        viewController2 = [[EntityBrowseController alloc] initWithNibName:@"EntityBrowseController" bundle:nil];
        viewController3 = [[EntityBrowseController alloc] initWithNibName:@"EntityBrowseController" bundle:nil];

    /*
    } else {
        viewController1 = [[EntityBrowseController alloc] initWithNibName:@"EntityBrowseController_iPad" bundle:nil];
        viewController2 = [[EntityBrowseController alloc] initWithNibName:@"EntityBrowseController_iPad" bundle:nil];
        viewController3 = [[EntityBrowseController alloc] initWithNibName:@"EntityBrowseController_iPad" bundle:nil];
 
    }
     */
    
    UITabBarItem * tabBarItem;
    
    // [UIColor colorWithRed:61.0/256 green:147.0/256 blue:196.0/256 alpha:0.0]
    //  [UIColor colorWithRed:235.0/255.0 green:196.0/255.0 blue:24.0/255.0 alpha:1]
    self.tabBarController = [[UITabBarController alloc] init];
    if([[UIDevice currentDevice] systemVersion].floatValue >= 7)
    {
        [[UITabBar appearance] setTintColor:[UIColor colorWithRed:235.0/255.0 green:196.0/255.0 blue:24.0/255.0 alpha:1]];

    }
    else
    {
      // Skipping this for now
      //  [[UITabBar appearance] setTintColor:[UIColor colorWithRed:255.0/256 green:22.0/256 blue:22.0/256 alpha:1.0]];
    }
    self.tabBarController.delegate = self;
    
    
    if(0)
    //    if( [[NSUserDefaults standardUserDefaults] objectForKey:@"installed_app"] )
    {
        
        //FavoritesTopViewController * d1 = [[FavoritesTopViewController alloc] init];
        //viewController1.rootDrillDownViewController = d1;
        
    }
    else
    {
        
        CoverImageViewController * d1 = [[CoverImageViewController alloc] init];
        viewController1.rootDrillDownViewController = d1;
        
        
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"installed_app"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    
    
    viewController1.view.frame = self.tabBarController.view.bounds;

    tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Home" image:[UIImage imageNamed:@"button-favorites"]  tag:1];
    [viewController1 setTabBarItem:tabBarItem];
    

    TopLevelViewController * d2 = [[TopLevelViewController alloc] init];
    viewController2.rootDrillDownViewController = d2;
    viewController2.view.frame = self.tabBarController.view.bounds;
    tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Directory" image:[UIImage imageNamed:@"button-browse"]  tag:1];
    [viewController2 setTabBarItem:tabBarItem];
    
    SettingsViewController * d3 = [[SettingsViewController alloc] init];
    viewController3.rootDrillDownViewController = d3;
    viewController3.view.frame = self.tabBarController.view.bounds;
    tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Settings" image:[UIImage imageNamed:@"button-settings"]  tag:1];
    [viewController3 setTabBarItem:tabBarItem];
    
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:viewController1, viewController2, viewController3, nil];
    
    _defaults = [NSUserDefaults standardUserDefaults];
    BOOL loggedIn =  [(NSNumber*) [_defaults objectForKey:kLoggedInKey] boolValue];
    if(loggedIn){
        self.window.rootViewController = self.tabBarController;
    } else {
        LoginViewController * vc = [[LoginViewController alloc] init];
        UINavigationController * nc = [[UINavigationController alloc] initWithRootViewController:vc];
        self.window.rootViewController = nc;
        nc.navigationBar.tintColor = [UIColor colorWithRed:61.0/256 green:147.0/256 blue:196.0/256 alpha:0.0];
        if([nc.navigationBar respondsToSelector:@selector(setBarTintColor:)]){
            nc.navigationBar.barTintColor = [UIColor colorWithRed:61.0/256 green:147.0/256 blue:196.0/256 alpha:0.0];
        }
        nc.navigationBar.translucent = NO;
    }
    [self.window makeKeyAndVisible];
    return YES;
}

- (void) userLoggedIn
{
    NSNumber * number = [NSNumber numberWithBool:YES];
    [_defaults setObject:number forKey:kLoggedInKey];
    [_defaults synchronize];
    
    self.window.rootViewController = self.tabBarController;
}

- (void) logUserOut
{
    NSNumber * number = [NSNumber numberWithBool:NO];
    [_defaults setObject:number forKey:kLoggedInKey];
    [_defaults synchronize];
    LoginViewController * vc = [[LoginViewController alloc] init];
    UINavigationController * nc = [[UINavigationController alloc] initWithRootViewController:vc];
    nc.navigationBar.tintColor = [UIColor colorWithRed:61.0/256 green:147.0/256 blue:196.0/256 alpha:0.0];
    if([nc.navigationBar respondsToSelector:@selector(setBarTintColor:)])
    {
        nc.navigationBar.barTintColor = [UIColor colorWithRed:61.0/256 green:147.0/256 blue:196.0/256 alpha:0.0];
    }
    nc.navigationBar.translucent = NO;
    
    self.window.rootViewController = nc;
}

- (FMDatabase *)openDatabase
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *documents_dir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *db_path = [documents_dir stringByAppendingPathComponent:[NSString stringWithFormat:@"ulct.newsqlite"]];
    NSString *template_path = [[NSBundle mainBundle] pathForResource:@"ulct" ofType:@"sqlite"];
    
    if (![fm fileExistsAtPath:db_path]) {
        [fm copyItemAtPath:template_path toPath:db_path error:nil];
    }
    FMDatabase *db = [FMDatabase databaseWithPath:db_path];
    if (![db open])
        NSLog(@"Failed to open database!");
    return db;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
    
    [self refreshDatabaseFileIfAvailable];

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}


// Optional UITabBarControllerDelegate method.
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    
    if(viewController == tabBarController.selectedViewController){
        UINavigationController * navController = ((EntityBrowseController *) viewController).navController;
        [navController popToRootViewControllerAnimated:NO];
        return NO;
    }
    return YES;
}


/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

+ (AppDelegate *) getAppDelegate {
    return (AppDelegate*) [[UIApplication sharedApplication] delegate];
}


#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ultc" withExtension:@"mom"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ultc.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


#pragma - update the database

- (void) refreshDatabaseFileIfAvailable {
    
    if([_reachability currentReachabilityStatus] == NotReachable){
        return;
        
    } else {
        NSDate * lastUpdatedDatabase = (NSDate *) [[NSUserDefaults standardUserDefaults] objectForKey:@"lastUpdatedDatabase"];
        NSTimeInterval sinceLastUpdate = [lastUpdatedDatabase timeIntervalSinceNow];
        if(sinceLastUpdate > 24*60*60 * 30){ // Every month
           
            [self performSelectorInBackground:@selector(updateDatabaseFile) withObject:nil];

        }
        
    }
    
}

- (void) updateDatabaseFile {
    //This is synchronous, should happen in the background.
    NSString *stringURL = @"http://ulctdirectory.com/api/latest?key=3pmqi8xqk1GH9xNh3108oHO68Lc096Z2";
    NSURL  *url = [NSURL URLWithString:stringURL];
    
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    if ( urlData )
    {
        
        NSString *documents_dir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *db_path = [documents_dir stringByAppendingPathComponent:[NSString stringWithFormat:@"ulct.newsqlite"]];
        [urlData writeToFile:db_path atomically:YES];
        self.database = [self openDatabase];
        
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"lastUpdatedDatabase"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Update Complete" message:@"The database has been updated." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    
    
    
}




@end
