//
//  AppDelegate.h
//  ultc
//
//  Created by Elliott De Aratanha on 5/1/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"
#import "SISReachability.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITabBarController *tabBarController;

@property (strong, nonatomic) NSUserDefaults * defaults;

@property( strong, nonatomic) FMDatabase * database;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, strong) SISReachability * reachability;


+ (AppDelegate *) getAppDelegate;

- (void) userLoggedIn;
- (void) logUserOut;

- (void) updateDatabaseFile;


@end
