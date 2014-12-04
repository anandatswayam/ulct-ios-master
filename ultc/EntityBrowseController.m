//
//  EntityBrowseController.m
//  ultc
//
//  Created by Matthew Shultz on 5/23/13.
//
//

#import "EntityBrowseController.h"

@interface EntityBrowseController ()

@property(nonatomic, weak) IBOutlet UIView * navControllerContainer;
@property(nonatomic, weak) IBOutlet UIView * contentContainer;

@end

@implementation EntityBrowseController
@synthesize navController;
@synthesize rootDrillDownViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    navController = [[UINavigationController alloc] initWithRootViewController:rootDrillDownViewController];
    [self.navControllerContainer addSubview:navController.view];

    navController.navigationBar.tintColor = [UIColor whiteColor];
    navController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor : [UIColor whiteColor]};
    if([navController.navigationBar respondsToSelector:@selector(setBarTintColor:)])
    {
        navController.navigationBar.barTintColor = [UIColor colorWithRed:61.0/256 green:147.0/256 blue:196.0/256 alpha:0.0];
    }
    else
    {
        navController.navigationBar.tintColor = [UIColor colorWithRed:61.0/256 green:147.0/256 blue:196.0/256 alpha:0.0];
    }
    navController.navigationBar.translucent = NO;

    if([[UIDevice currentDevice] systemVersion].floatValue < 7)
    {
        navController.view.frame = self.view.bounds;
    }
    else if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        navController.view.frame = self.view.bounds;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) placeIntoContentView: (UIViewController *) vc{
    NSLog(@"%@", @"Abstract function not imlpemented");
}
- (void) clearContentView{
    NSLog(@"%@", @"Abstract function not imlpemented");
}

@end
