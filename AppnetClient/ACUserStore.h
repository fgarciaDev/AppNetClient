//
//  ACUserStore.h
//  AppnetClient
//
//  Created by Francisco Garcia on 10/16/13.
//  Copyright (c) 2013 Francisco Garcia. All rights reserved.
//

#import <Foundation/Foundation.h>


@class ACUser;


//----------------------------------------------------------------------------//


@interface ACUserStore : NSObject

+ (ACUserStore *)acUserStore;

- (void)createFromJSONObject:(NSDictionary *)jsonObject;
- (ACUser *)getUser:(NSString *)user;
- (UIImage *)getUserAvatar:(NSString *)user;

@end
