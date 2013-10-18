//
//  ACUser.h
//  AppnetClient
//
//  Created by Francisco Garcia on 10/16/13.
//  Copyright (c) 2013 Francisco Garcia. All rights reserved.
//

#import <Foundation/Foundation.h>


//----------------------------------------------------------------------------//


@interface ACUser : NSObject

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userNick;
@property (nonatomic, strong) UIImage *userAvatar;

@end
