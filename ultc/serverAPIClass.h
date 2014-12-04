//
//  serverAPIClass.h
//  Greetings
//
//  Created by Anand Patel on 05/09/12.
//  Copyright (c) 2012 anandconcious@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface serverAPIClass : NSObject{
    
}
@property(nonatomic, retain) NSString *base_server;

-(id)init;
-(NSString*)SendWebURL11:(NSString*) posturl SendWebPostData:(NSString*) post1;
-(NSString*)SendWebURL:(NSString*) posturl SendWebPostData:(NSString*) post1;
//-(NSString *)SendWebURLWithImage:(NSString*)urlString withImage1:(UIImageView*)imageView withExt:(NSString *)ext othersnm:(NSArray*)params_names othersvl:(NSArray*)params_values;

-(NSString *)SendWebURLWithImageVideo:(NSString*)urlString withImage1:(UIImageView*)imageView withVideo:(NSString *)VideoData othersnm:(NSArray*)params_names othersvl:(NSArray*)params_values;

//-(NSString*)getHtmlData:(NSString*) posturl SendWebPostData:(NSString*) post1;
-(NSString*)SendWebURLwithjson1:(NSString*)functionname SendWebPostData:(NSMutableDictionary*)jsondata;
@end
