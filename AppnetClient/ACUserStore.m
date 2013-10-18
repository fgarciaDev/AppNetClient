//
//  ACUserStore.m
//  AppnetClient
//
//  Created by Francisco Garcia on 10/16/13.
//  Copyright (c) 2013 Francisco Garcia. All rights reserved.
//

#import "ACUserStore.h"
#import "ACUser.h"


@interface ACUserStore ()
{
    NSMutableDictionary *_users;
}

- (UIImage *)setAvatarFromImage:(UIImage *)image;

@end


//----------------------------------------------------------------------------//


@implementation ACUserStore


+ (id)allocWithZone:(NSZone *)zone
{
    return [self acUserStore];
}


- (id)init
{
    self = [super init];
    if (self) {
        _users = [[NSMutableDictionary alloc] init];
    }
    return self;
}


+ (ACUserStore *)acUserStore
{
    static ACUserStore *acUserStore = nil;
    if (!acUserStore) {
        // create the singleton
        acUserStore = [[super allocWithZone:NULL] init];
    }
    return acUserStore;
}


- (void)createFromJSONObject:(NSDictionary *)jsonObject
{
    ACUser *user = [[ACUser alloc] init];
    
    // grab the user info we want out of the given jsonObject for a post
    user.userName = [jsonObject objectForKey:@"name"];
    user.userNick = [jsonObject objectForKey:@"username"];
    
    // grab the user image and set it as the avatar for this user
    NSDictionary *avatar = [jsonObject objectForKey:@"avatar_image"];
    NSString *imgURL = [avatar objectForKey:@"url"];
    
    NSURL *url = [NSURL URLWithString:imgURL];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    user.userAvatar = [self setAvatarFromImage:image];
    
    // add the user
    [_users setObject:user forKey:user.userNick];
}


- (ACUser *)getUser:(NSString *)user
{
    return [_users objectForKey:user];
}


- (UIImage *)getUserAvatar:(NSString *)user
{
    ACUser *u = [_users objectForKey:user];
    return u.userAvatar;
}


- (UIImage *)setAvatarFromImage:(UIImage *)image
{
    CGSize origImageSize = [image size];
    
    CGRect newRect = CGRectMake(0, 0, 50, 50);
    
    // scaling ration to maintain the same aspect ratio
    float ratio = MAX(newRect.size.width / origImageSize.width,
                      newRect.size.height / origImageSize.height);
    
    // transparent bitmap context with scaling factor equal to that of screen
    UIGraphicsBeginImageContextWithOptions(newRect.size, NO, 0.0);
    
    // rounded rectangle path
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:newRect
                                                    cornerRadius:5.0];
    // make all subsequent drawing clip to this rounded rect
    [path addClip];
    
    // center the image in the thumbnail rect
    CGRect projectRect;
    projectRect.size.width = ratio * origImageSize.width;
    projectRect.size.height = ratio * origImageSize.height;
    projectRect.origin.x = (newRect.size.width - projectRect.size.width) / 2.0;
    projectRect.origin.y =(newRect.size.height - projectRect.size.height) / 2.0;
    
    // draw image on it
    [image drawInRect:projectRect];
    
    // get the image and set it to our thumbnail
    UIImage *avatar = UIGraphicsGetImageFromCurrentImageContext();
    
    // clean up image context resources
    UIGraphicsEndImageContext();
    
    return avatar;
}


@end
