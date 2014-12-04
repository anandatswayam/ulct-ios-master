//
//  serverAPIClass.m
//  Greetings
//
//  Created by Anand Patel on 05/09/12.
//  Copyright (c) 2012 anandconcious@gmail.com. All rights reserved.
//

#import "serverAPIClass.h"

@implementation serverAPIClass
@synthesize base_server;

-(id)init{
    self.base_server = @"http://ulctdirectory.com/api/";
    
    return self;
}


//Get
-(NSString*)SendWebURL:(NSString*) posturl SendWebPostData:(NSString*) post1
{
    posturl = [NSString stringWithFormat:@"%@%@",self.base_server,posturl] ;
    NSData *postData = [posturl dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    
	NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    NSLog(@"URL:%@",posturl);
    
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:[NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@",posturl]]];
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setHTTPBody:postData];
    
    NSError *error=nil;
	NSURLResponse *response=nil;
	NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSString *data=[[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
    NSLog(@"data:%@",data);
    return data;
}
//Get
-(NSString*)SendWebURL11:(NSString*) posturl SendWebPostData:(NSString*) post1
{
    posturl = [NSString stringWithFormat:@"%@%@",self.base_server,posturl] ;
    NSData *postData = [posturl dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    
	NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    NSLog(@"URL:%@",posturl);
    
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:[NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@",posturl]]];
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setHTTPBody:postData];
    
    NSError *error;
	NSURLResponse *response;
	NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSString *data=[[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
    return data;
}
-(NSString*)SendWebURLwithjson1:(NSString*)functionname SendWebPostData:(NSMutableDictionary*)jsondata
{
//    Reachability *reach = [Reachability reachabilityForInternetConnection];
//    NetworkStatus netStatus = [reach currentReachabilityStatus];
//    
//    if (netStatus != NotReachable)
//    {
        NSLog(@"Connection available");
        NSString *posturl =[NSString stringWithFormat:@"%@%@",self.base_server,functionname];
        NSLog(@"url====%@",posturl);
//        SBJsonWriter *jsonwriter = [[SBJsonWriter alloc] init];
//        NSString *requestString = [jsonwriter stringWithObject:jsondata];
//        
//        NSData *postData = [requestString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    NSData *postData = [posturl dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@",posturl]]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        NSError *error;
        NSURLResponse *response;
        NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSString *data=[[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
        
        return data;
//    }
//    else
//    {
//        
//        UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Warning!" message:@"Can not connect to internet!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//        [alert show];
//    }
    //return NULL;
}


-(NSString *)SendWebURLWithImageVideo:(NSString*)urlString withImage1:(UIImageView*)imageView withVideo:(NSURL *)VideoData othersnm:(NSArray*)params_names othersvl:(NSArray*)params_values
{
    
    
    urlString = [NSString stringWithFormat:@"%@%@",self.base_server,urlString];
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"POST"];
	
    
	NSString *boundary = [NSString stringWithFormat:@"---------------------------14737809831466499882746641449"];
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
	[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
	NSMutableData *body = [NSMutableData data];
    if(imageView.image != nil){
        NSData *imageData = UIImageJPEGRepresentation(imageView.image, 90);
        
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"picphony_file\"; filename=\"iphone.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Type: image/jpg\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:imageData]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    /* if(VideoData != NULL)
     {
     
     [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
     [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"music_file\"; filename=\"iphone.caf\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
     [body appendData:[[NSString stringWithFormat:@"Content-Type: video/quicktime\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
     [body appendData:[NSData dataWithContentsOfURL:VideoData]];
     [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
     }*/
    
    NSString *param_value=@"";
    NSString *param_name = @"";
	if(params_names)
    {
        for(int i=0;i<[params_names count];i++)
        {
            param_name = [params_names objectAtIndex:i];
            param_value = [params_values objectAtIndex:i];
            
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",param_name] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithString:param_value] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
	// setting the body of the post to the reqeust
	[request setHTTPBody:body];
	
	// now lets make the connection to the web
    NSError *error;
	NSURLResponse *response;
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	//NSLog(@"HelloooRet=%@",returnString);
	return returnString;
    
    
}
@end
