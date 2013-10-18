//
//  ACPost.m
//  AppnetClient
//
//  Created by Francisco Garcia on 10/16/13.
//  Copyright (c) 2013 Francisco Garcia. All rights reserved.
//

#import "ACPost.h"


//----------------------------------------------------------------------------//


@implementation ACPost


- (void)readFromJSONObject:(NSDictionary *)jsonObject
{
    // grab the user info we want out of the given jsonObject for a post
    NSDictionary *user = [jsonObject objectForKey:@"user"];
    _postUsernick = [user objectForKey:@"username"];
    
    // grab the post text
    NSString *text = [jsonObject objectForKey:@"text"];
    _postText = [[NSString alloc] initWithString:text];
    
    // grab the post date
    NSString *date = [jsonObject objectForKey:@"created_at"];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"YYYY'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
    _postDate = [format dateFromString:date];
    
    // grab post URL
    _postURL = [NSURL URLWithString:[jsonObject objectForKey:@"canonical_url"]];
}


@end
