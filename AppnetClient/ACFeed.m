//
//  ACFeed.m
//  AppnetClient
//
//  Created by Francisco Garcia on 10/16/13.
//  Copyright (c) 2013 Francisco Garcia. All rights reserved.
//

#import "ACFeed.h"
#import "ACPost.h"
#import "ACUserStore.h"


//----------------------------------------------------------------------------//


@implementation ACFeed


-(id)init
{
    self = [super init];
    if (self) {
        _posts = [[NSMutableArray alloc] init];
    }
    return self;
}


- (void)readFromJSONObject:(NSDictionary *)jsonObject
{
    for (NSDictionary *post in [jsonObject objectForKey:@"data"]) {
        // for each post in the jsonObject, create a post object
        ACPost *p = [[ACPost alloc] init];
        [p readFromJSONObject:post];
        [_posts addObject:p];
        
        // get the user for this post
        NSDictionary *userData = [post objectForKey:@"user"];
        NSString *userNick = [userData objectForKey:@"username"];
        
        // check if this user is in the user store
        ACUser *user = [[ACUserStore acUserStore] getUser:userNick];
        
        if (!user) {
            // user doesn't exist, add the user
            [[ACUserStore acUserStore] createFromJSONObject:userData];
        }
    }
}


- (NSString *)usernickForPostAtIndex:(NSInteger)index
{
    return [[_posts objectAtIndex:index] postUsernick];
}


- (NSString *)textForPostAtIndex:(NSInteger)index
{
    return [[_posts objectAtIndex:index] postText];
}


- (NSDate *)dateForPostAtIndex:(NSInteger)index
{
    return [[_posts objectAtIndex:index] postDate];
}


- (NSString *)dateStringForPostAtIndex:(NSInteger)index
{
    // return a local time zone string format of the date
    NSDate *date = [[_posts objectAtIndex:index] postDate];
    
    NSTimeZone *tz = [NSTimeZone defaultTimeZone];
    NSInteger seconds = [tz secondsFromGMTForDate:date];
    NSDate *newDate = [NSDate dateWithTimeInterval:seconds sinceDate:date];
    
    NSString *dateString = [NSDateFormatter
                            localizedStringFromDate:newDate
                                          dateStyle:NSDateFormatterShortStyle
                                          timeStyle:NSDateFormatterMediumStyle];
    return dateString;
}


- (UIImage *)userAvatarForPostAtIndex:(NSInteger)index
{
    NSString *usernick = [[_posts objectAtIndex:index] postUsernick];
    return [[ACUserStore acUserStore] getUserAvatar:usernick];
}


- (NSURL *)urlForPost:(NSInteger)index
{
    return [[_posts objectAtIndex:index] postURL];
}


- (void)clearCache
{
    [_posts removeAllObjects];
}


@end
