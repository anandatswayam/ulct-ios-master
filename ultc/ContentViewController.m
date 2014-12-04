//
//  ContentViewController.m
//  ultc
//
//  Created by Matthew Shultz on 5/23/13.
//
//

#import "ContentViewController.h"
#import "Recent.h"
#import "Favorite.h"
#import <MessageUI/MessageUI.h>
#import "NSString+URLEncoding.h"

@interface ContentViewController ()  <MFMailComposeViewControllerDelegate>

@end

@implementation ContentViewController

@synthesize itemId;
@synthesize saveAsRecent;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if(nibNameOrNil != nil)
    {
        self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    }
    else
    {
        //self = [super initWithNibName:@"ContentViewController" bundle:nibBundleOrNil];
    }
    
    if (self)
    {
        saveAsRecent = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(saveAsRecent)
    {
        NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"Recent"];
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"itemId = %@ AND viewController = %@", itemId, NSStringFromClass([self class])];
        [request setPredicate:predicate];
        NSError * error;
        NSArray * results = [[AppDelegate getAppDelegate].managedObjectContext executeFetchRequest:request error:&error];
        if(results == nil)
        {
            [WRUtilities criticalError:error];
            return;
        }
        
        if([results count] > 0)
        {
            Recent * recent = [results objectAtIndex:0];
            recent.accessDate = [NSDate date];
            
            NSError * error;
            bool rval = [[AppDelegate getAppDelegate].managedObjectContext save:&error];
            if(!rval)
            {
                [WRUtilities criticalError:error];
            }
        }
        else
        {
            Recent * recent = [NSEntityDescription
                               insertNewObjectForEntityForName:@"Recent"
                               inManagedObjectContext:[AppDelegate getAppDelegate].managedObjectContext];
            recent.itemId = itemId;
            recent.title = self.title;
            recent.viewController = NSStringFromClass([self class]);
            recent.accessDate = [NSDate date];
            
            NSError * error;
            bool rval = [[AppDelegate getAppDelegate].managedObjectContext save:&error];
            if(!rval)
            {
                [WRUtilities criticalError:error];
            }
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma TitleTableViewCellDelegate
-(void)didToggleFavorite:(BOOL)selected
{
    
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"Favorite"];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"itemId = %@ AND viewController = %@", self.itemId, NSStringFromClass([self class])];
    [request setPredicate:predicate];
    NSError * error;
    NSArray * results = [[AppDelegate getAppDelegate].managedObjectContext executeFetchRequest:request error:&error];
    if(results == nil)
    {
        [WRUtilities criticalError:error];
        return;
    }
    
    if(selected)
    {
        // set selected
        
        if([results count] > 0)
        {
            
            Favorite * favorite = [results objectAtIndex:0];
            favorite.accessDate = [NSDate date];
            
            NSError * error;
            bool rval = [[AppDelegate getAppDelegate].managedObjectContext save:&error];
            if(!rval)
            {
                [WRUtilities criticalError:error];
            }
            
        }
        else
        {
            Favorite * favorite = [NSEntityDescription
                                   insertNewObjectForEntityForName:@"Favorite"
                                   inManagedObjectContext:[AppDelegate getAppDelegate].managedObjectContext];
            favorite.itemId = itemId;
            favorite.title = self.title;
            favorite.viewController = NSStringFromClass([self class]);
            favorite.accessDate = [NSDate date];
            
            NSError * error;
            bool rval = [[AppDelegate getAppDelegate].managedObjectContext save:&error];
            if(!rval)
            {
                [WRUtilities criticalError:error];
            }
            
        }
    }
    else
    {
        // set deselected
        if([results count] > 0)
        {
            Favorite * favorite = [results objectAtIndex:0];
            [[AppDelegate getAppDelegate].managedObjectContext deleteObject:favorite];
        }
    }
}

- (void) pushViewController: (UIViewController *) vc
{
    // if it's a contentViewController subclass, then display it
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        // if it's iphone, push it
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    else if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        // if it's ipad, put it into the content view
        [self.entityBrowseController placeIntoContentView:vc]; // not implemented
        
    }
}

- (void) callPhone: (NSString *) phoneNumber
{
    NSString *phoneURLString = [NSString stringWithFormat:@"tel://%@", phoneNumber];
    NSURL *phoneURL = [NSURL URLWithString:phoneURLString];
    [[UIApplication sharedApplication] openURL:phoneURL];
}

- (void) sendEmail: (NSString *) emailAddress
{
    if(emailAddress == nil)
    {
        return;
    }
    
    NSArray *emails = [emailAddress componentsSeparatedByString:@","];
    NSMutableArray *emailsPrepared = [NSMutableArray array];
    for(NSString * email in emails)
    {
        NSString * preparedEmail = [email stringByReplacingOccurrencesOfString:@"," withString:@""];
        preparedEmail = [preparedEmail stringByReplacingOccurrencesOfString:@" " withString:@""];
        [emailsPrepared addObject:preparedEmail];
    }
    
    // Email Subject
    NSString *emailTitle = @"Greetings";
    // To address
    NSArray *toRecipents = emailsPrepared;
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    //[self presentViewController:mc animated:YES completion:NULL];
    
    [self presentViewController:mc animated:YES completion:NULL];
    
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void) openUrl: (NSString*) urlString
{
    NSRange isRange = [urlString rangeOfString:@"http://" options:NSCaseInsensitiveSearch];
    if(isRange.location == NSNotFound)
    {
        urlString = [NSString stringWithFormat:@"%@%@", @"http://", urlString];
    }
    NSURL *url = [NSURL URLWithString:urlString];
    
    if (![[UIApplication sharedApplication] openURL:url])
    {
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
    }
}

- (void) openMapAtAddress: (NSString *) fullAddress
{
    fullAddress = [fullAddress urlEncodeUsingEncoding:NSUTF8StringEncoding];
    
    NSString * url = [NSString stringWithFormat:@"%@%@",@"http://maps.apple.com?q=",fullAddress];
    if (![[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]])
    {
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
    }
}

@end