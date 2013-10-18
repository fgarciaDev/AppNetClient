//
//  ACPost.h
//  AppnetClient
//
//  Created by Francisco Garcia on 10/16/13.
//  Copyright (c) 2013 Francisco Garcia. All rights reserved.
//

#import <Foundation/Foundation.h>


//----------------------------------------------------------------------------//


@class ACUser;

@interface ACPost : NSObject

@property (nonatomic, strong) NSString *postUsernick;
@property (nonatomic, strong) NSString *postText;
@property (nonatomic, strong) NSDate *postDate;
@property (nonatomic, strong) NSURL *postURL;

- (void)readFromJSONObject:(NSDictionary *)jsonObject;

@end
