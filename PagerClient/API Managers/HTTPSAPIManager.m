//
//  HTTPSAPIManager.m
//  PagerClient
//
//  Created by Abdullah Kahn on 7/24/18.
//  Copyright © 2018 Sifted. All rights reserved.
//

#define  BASE_URL @"http://ios-hiring-backend.dokku.canillitapp.com/"
#define  ROLES_ENDPOINT @"roles"
#define  EMPLOYEES_ENDPOINT @"team"

#import "HTTPSAPIManager.h"
#import "AFNetworking.h"
#import "EmployeeDataStore.h"
#import "Employee.h"

@interface HTTPSAPIManager ()

@end

@implementation HTTPSAPIManager

+ (HTTPSAPIManager *)sharedAPIManager {
    static HTTPSAPIManager *manager;
    if (manager == nil) {
        manager = [[HTTPSAPIManager alloc] init];
    }
    return manager;
}

-(void)initDataSource
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dictionary = [NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"rolesDictionary"]];
    
    if (dictionary == nil) {
        [self getFromServer:ROLES_ENDPOINT];
    } else {
        [self getFromServer:EMPLOYEES_ENDPOINT];
    }
}


-(void)getFromServer:(NSString *) parameter
{
    //SSL Certificate Expired
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    [securityPolicy setValidatesDomainName:NO];
    
    //Request
    NSURL *baseURL = [NSURL URLWithString:BASE_URL];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.securityPolicy = securityPolicy;
    
    [manager GET:parameter parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([parameter  isEqual:ROLES_ENDPOINT]) {
            
            NSDictionary *rolesDictionary = responseObject;
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:rolesDictionary];
            
            //Save to user defaults
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:data forKey:@"rolesDictionary"];
            [defaults synchronize];
            
            [self getFromServer:EMPLOYEES_ENDPOINT];
        }
        else if([parameter  isEqual:EMPLOYEES_ENDPOINT]) {
            NSArray *array = responseObject;
            
            for (int i = 0; i < array.count; i++) {
                NSDictionary *employeeData = array[i];
                [[EmployeeDataStore sharedStore] createEmployee:employeeData];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error == %@",error.description);
    }];
}


-(void)postToServer:(NSMutableDictionary*)employeeData
{
    NSString *jsonString = [self stringFromDictionary:employeeData];
    
    //SSL Certificate Expired
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    [securityPolicy setValidatesDomainName:NO];
    
    //Request
    NSURL *baseURL = [NSURL URLWithString:BASE_URL];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.securityPolicy = securityPolicy;
    
    [manager POST:EMPLOYEES_ENDPOINT parameters:jsonString progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"POST response == %@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}


-(NSString*)stringFromDictionary:(NSDictionary*)dictionary {
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    }
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
