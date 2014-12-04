//
//  TextBoxContentViewController.h
//  ultc
//
//  Created by Matthew Shultz on 8/29/13.
//
//

#import "ContentViewController.h"

@interface TextBoxContentViewController : ContentViewController

@property (nonatomic, weak) IBOutlet UIWebView * webView;
@property (nonatomic, strong) NSString * text;

@end
