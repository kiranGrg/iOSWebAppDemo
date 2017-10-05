
    //
    //  HottieAPI.m
    //  HottieHunterDemo
    //
    //  Created by Dil krishna Prajapati on 21/07/2014.
    //  Copyright (c) 2014 Design Offshore Nepal. All rights reserved.
    //

#import "HottieAPI.h"
#import "ServerURL+Constants.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "Countly.h"
#import "Helper.h"
static HottieAPI *_sharedHottieHTTPClient = nil;

@implementation HottieAPI

+ (HottieAPI*)sharedHottieHTTPClient
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedHottieHTTPClient = [[self alloc]initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    });
    return _sharedHottieHTTPClient;
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    
    if (self) {
        [_sharedHottieHTTPClient setResponseSerializer:[AFJSONResponseSerializer serializer]];
        [_sharedHottieHTTPClient setRequestSerializer:[AFJSONRequestSerializer serializer]];
        [_sharedHottieHTTPClient.requestSerializer setTimeoutInterval:20.0];
    }
    return self;
}

- (void)requestWithPath:(NSString*)path params:(NSDictionary*)params onCompletion:(JSONResponseBlock)completionBlock
{
    [self POST:path parameters:params success:^(NSURLSessionDataTask *task, id responseObject)
    {
        completionBlock(responseObject, nil);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        completionBlock(nil, [self getErrorMessageStringCodeForSessionDataTas:task withAssociatedError:error withPath:path]);
        
    }];
}

- (void)requestWithPath:(NSString*)path params:(NSDictionary*)params withMultiPartDataBlock:(FormDataBlock)block onCompletion:(JSONResponseBlock)completionBlock
{
    
    [self POST:path parameters:params constructingBodyWithBlock:block success:^(NSURLSessionDataTask *task, id responseObject) {
        
        completionBlock(responseObject, nil);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {

        completionBlock(nil, [self getErrorMessageStringCodeForSessionDataTas:task withAssociatedError:error withPath:path]);
        
    }];
    
}

-(NSString *)getErrorMessageStringCodeForSessionDataTas:(NSURLSessionDataTask *) task withAssociatedError:(NSError *) error withPath:(NSString *) path{
    NSString * errorMessage;
    
    if (APP_DEL.isWith_WWAN) {
        
      
        [APP_DEL showNoConnectionwithDisplayMessage:NETWORK_ERROR_MESSAGE];
          return @"Network Error.";
    }
    NSLog(@"invalid device token for :%@",[Helper GetUNIQUEID]);
    HHUserDetails *user =[[HHUserDetails alloc]init];
    NSLog(@"invalid for User id: %@",user.userid);
    NSLog(@"Error : \n%@",error.userInfo);
    NSLog(@"Error_in_Url: %@\nError_Description: %@",[NSString stringWithFormat:@"%@%@",BASE_URL,path],error.userInfo[NSLocalizedDescriptionKey]);
    

     NSString * appVersionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys: [NSString stringWithFormat:@"%@%@",BASE_URL,path], @"Bug_URL_API", appVersionString, @"HottieHunter_App_Version_iOS",[Helper currentiOSVersion],@"fromiOSVersion",nil];
    NSLog(@"info:%@",error.userInfo[NSLocalizedDescriptionKey]);
    [[Countly sharedInstance] recordEvent:@"API_SERVER_ERROR" segmentation:event count:1];
    
//    NSLog(@"HottieAPI Failure Response:");
    NSLog(@"status Code : %d\n with Info %@",(int)((NSHTTPURLResponse *)task.response).statusCode,[NSHTTPURLResponse localizedStringForStatusCode:((NSHTTPURLResponse *)task.response).statusCode]);
//
//    NSLog(@"*********** Userinfo: *************");
//    NSLog(@"Error_in_Url: %@\nError_Description: %@",error.userInfo[@"NSErrorFailingURLKey"],error.userInfo[NSLocalizedDescriptionKey]);
    
    if (error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey]) {
        
        NSDictionary * response_header = (NSDictionary *)((NSHTTPURLResponse *)task.response).allHeaderFields;
        NSLog(@"Response Header: %@",response_header.description);
        
        if (((NSHTTPURLResponse *)task.response).statusCode == 200 && [response_header[@"Content-Type"] rangeOfString:@"text/html"].location != NSNotFound) {
            errorMessage = @"(HTML)Unaccepted Content Type.";
        }
        else{
            NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
            id serializedData = [NSJSONSerialization JSONObjectWithData: errorData options:kNilOptions error: &error];

            if ([serializedData isKindOfClass:[NSDictionary class]]) {
                    errorMessage = serializedData[@"message"];
            }
            else{
                errorMessage = [NSHTTPURLResponse localizedStringForStatusCode:((NSHTTPURLResponse *)task.response).statusCode];
                if (error.userInfo[@"NSLocalizedDescription"]) {
                    errorMessage = [NSString stringWithFormat:@"%@",error.userInfo[@"NSLocalizedDescription"]];
                }
            }
        }
    }
    else{
        
        if (((NSHTTPURLResponse *)task.response).statusCode == 200 && error.userInfo[@"NSDebugDescription"]) {
            errorMessage = error.userInfo[@"NSDebugDescription"];
        }
        else{
            errorMessage = [NSHTTPURLResponse localizedStringForStatusCode:((NSHTTPURLResponse *)task.response).statusCode];
            if (error.userInfo[@"NSLocalizedDescription"]) {
                errorMessage = [NSString stringWithFormat:@"%@",error.userInfo[@"NSLocalizedDescription"]];
            }
        }

    }
    
    NSLog(@"//**************************************************//\n************** %@ *******************",errorMessage);
    if ([errorMessage isEqualToString:@"The request timed out."]) {
        NSLog(@"REQUEST TIME OUT was for URL: %@%@",BASE_URL,path);
    }
    
    return errorMessage;
}

@end
