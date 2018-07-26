//
//  HTTPSAPIManager.h
//  PagerClient
//
//  Created by Abdullah Kahn on 7/24/18.
//  Copyright © 2018 Sifted. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTTPSAPIManager : NSObject {}

+ (HTTPSAPIManager *)sharedAPIManager;
-(void)initDataSource;
-(void)postToServer:(NSMutableDictionary*)employeeData;

@end




