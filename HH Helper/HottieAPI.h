//
//  HottieAPI.h
//  HottieHunterDemo
//
//  Created by Dil krishna Prajapati on 21/07/2014.
//  Copyright (c) 2014 Design Offshore Nepal. All rights reserved.
//

#import "AFHTTPSessionManager.h"

typedef void (^JSONResponseBlock)(NSDictionary *json, NSString *errorMessage);
typedef void (^FormDataBlock)(id <AFMultipartFormData> formData);

@interface HottieAPI : AFHTTPSessionManager

+ (HottieAPI*)sharedHottieHTTPClient;

/* Normal post action */
- (void)requestWithPath:(NSString*)path params:(NSDictionary*)params onCompletion:(JSONResponseBlock)completionBlock;

/* Post action with Multi-part form data */
- (void)requestWithPath:(NSString*)path params:(NSDictionary*)params withMultiPartDataBlock:(FormDataBlock)block onCompletion:(JSONResponseBlock)completionBlock;

@end
