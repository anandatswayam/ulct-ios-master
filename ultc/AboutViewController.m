//
//  AboutViewController.m
//  ultc
//
//  Created by Matthew Shultz on 8/29/13.
//
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"About ULCT";
    }
    
    FMDatabase * db = [[AppDelegate getAppDelegate] database ];
    NSString * sqlString = @"SELECT * FROM info";
    FMResultSet * s = [ db executeQuery:sqlString];
    if([s next]){
        
        NSString * text = [s stringForColumn:@"ulct_about"];
        
        NSString * head = @"<HEAD><LINK href=\"style.css\" rel=\"stylesheet\" type=\"text/css\"></HEAD>";
        
        self.text = [NSString stringWithFormat:@"%@ %@", head, text];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
