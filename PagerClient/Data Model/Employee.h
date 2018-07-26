//
//  Employee.h
//  PagerClient
//
//  Created by Abdullah Kahn on 7/24/18.
//  Copyright © 2018 Sifted. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Employee : NSManagedObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *avatarURL;
@property (nonatomic, retain) NSString *githubHandle;
@property (nonatomic, retain) NSString *role;
@property (nonatomic, retain) NSString *gender;
@property (nonatomic, retain) NSData *languages;
@property (nonatomic, retain) NSData *tags;
@property (nonatomic, retain) NSString *location;
@property (nonatomic, retain) NSString *status;

@end
