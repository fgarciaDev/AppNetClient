//
//  ACFeed.h
//  AppnetClient
//
//  Created by Francisco Garcia on 10/16/13.
//  Copyright (c) 2013 Francisco Garcia. All rights reserved.
//

#import <Foundation/Foundation.h>


//----------------------------------------------------------------------------//


@interface ACFeed : NSObject

@property (nonatomic, strong) NSMutableArray *posts;

- (void)readFromJSONObject:(NSDictionary *)jsonObject;
- (NSString *)usernickForPostAtIndex:(NSInteger)index;
- (NSString *)textForPostAtIndex:(NSInteger)index;
- (NSDate *)dateForPostAtIndex:(NSInteger)index;
- (NSString *)dateStringForPostAtIndex:(NSInteger)index;
- (UIImage *)userAvatarForPostAtIndex:(NSInteger)index;
- (NSURL *)urlForPost:(NSInteger)index;

- (void)clearCache;

@end
