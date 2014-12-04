//
//  LoginViewController.m
//  ultc
//
//  Created by Matthew Shultz on 5/23/13.
//
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "nv_ios_digest.h"
#import "SHA1.h"
#import "RJSON.h"

@interface LoginViewController ()

@property(nonatomic, weak) IBOutlet UITextField * username;
@property(nonatomic, weak) IBOutlet UITextField * password;

- (IBAction)didTapLoginButton:(id)sender;
- (IBAction)didEndOnExit:(id)sender;

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Log In";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    serverAPI = [[serverAPIClass alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated./Users/anandpatel/Downloads/nv-ios-digest-master/nv-ios-digest/MD5.h
}

-(IBAction)didTapLoginButton:(id)sender {

    //verify the username and password against something
    // This is probably important
    /*FMDatabase * db = [[AppDelegate getAppDelegate] database ];
    // DW: added date_from to query
    
    NSString * saltedPass = [NSString stringWithFormat:@"sprinkle%@", _password.text];
    SHA1 * sha1 = [SHA1 sha1WithString:saltedPass];
    NSString *sha1String = [sha1 description];

    NSString * sql = [NSString stringWithFormat:@"SELECT * FROM users WHERE email = '%@' and password = '%@'", _username.text , sha1String];
    FMResultSet * s = [ db executeQuery:sql];
    while ([s next]) {
        // if it's cool, log them in:
        [(AppDelegate*) [[UIApplication sharedApplication] delegate] userLoggedIn];
        return;
    }*/
    
    NSMutableString *userArray=[[NSMutableString alloc]init];
    
    //NSString *params =  [NSString stringWithFormat:@"authenticate_user?key=3pmqi8xqk1GH9xNh3108oHO68Lc096Z2&email=%@&password=%@",_username.text,_password.text] ;
    NSString *params =  [NSString stringWithFormat:@"authenticate_user?key=3pmqi8xqk1GH9xNh3108oHO68Lc096Z2&email=%@&password=%@",_username.text,_password.text] ;
    
    
    //SendWebURL11
    NSString *posts = [serverAPI SendWebURLwithjson1:params SendWebPostData:Nil];
    //NSString *posts = [serverAPI SendWebURL:params SendWebPostData:nil];
    NSDictionary *Data = [posts JSONValue];
    userArray=[Data valueForKey:@"success"];
    NSLog(@"-->%@",userArray);
    
    if([userArray isEqualToString:@"true"]){
        [(AppDelegate*) [[UIApplication sharedApplication] delegate] userLoggedIn];
    }
    else
    {
        [(AppDelegate*) [[UIApplication sharedApplication] delegate] userLoggedIn];
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Login Failed" message:@"Username and password combination is invalid." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }

}

- (IBAction)didEndOnExit:(id)sender {
    if(sender == self.username){
        [self.password becomeFirstResponder];
    } else {
        [sender resignFirstResponder];
    }
}
@end
