//
//  EmployeeDataStore.h
//  PagerClient
//
//  Created by Abdullah Kahn on 7/24/18.
//  Copyright © 2018 Sifted. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Employee.h"

@class EmployeeDataStore;
@protocol EmployeeDataStoreDelegate <NSObject>
@optional

- (void)dataSourceUpdated: (EmployeeDataStore *) sender;

@end

@interface EmployeeDataStore : NSObject
@property (nonatomic, weak) id <EmployeeDataStoreDelegate> delegate;

+ (EmployeeDataStore *)sharedStore;

- (void)createEmployee:(NSDictionary*)employeeData;
- (void)updateEmployee:(NSDictionary*)updatedData;

- (NSArray *)employees;
- (void)save:(NSError *)error;

@end
