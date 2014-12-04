//
//  TextBoxContentViewController.m
//  ultc
//
//  Created by Matthew Shultz on 8/29/13.
//
//

#import "TextBoxContentViewController.h"

@interface TextBoxContentViewController ()

@end

@implementation TextBoxContentViewController

@synthesize webView;
@synthesize text;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if(nibNameOrNil != nil){
        self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    } else {
        self = [super initWithNibName:@"TextBoxContentViewController" bundle:nibBundleOrNil];
    }
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [webView loadHTMLString: text baseURL:[NSURL URLWithString:@""]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
