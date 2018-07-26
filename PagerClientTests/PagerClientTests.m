//
//  PagerClientTests.m
//  PagerClientTests
//
//  Created by Abdullah Kahn on 7/22/18.
//  Copyright © 2018 Sifted. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Employee.h"
#import "EmployeeDataStore.h"


@interface PagerClientTests : XCTestCase

@end

@implementation PagerClientTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testAddEmployee {
    NSArray *oldArray = [[EmployeeDataStore sharedStore] employees];

    NSMutableDictionary *newEmployee = [[NSMutableDictionary alloc]init];
    
    [newEmployee setValue:@"Alex Bussan" forKey:@"name"];
    [newEmployee setValue:@"" forKey:@"avatar"];
    [newEmployee setValue:@"abuss" forKey:@"github"];
    [newEmployee setValue:@"Male" forKey:@"gender"];
    [newEmployee setValue:@"ae" forKey:@"location"];
    [newEmployee setValue:[NSNumber numberWithInteger:1] forKey:@"role"];

    NSDictionary *dictionary = [[NSDictionary alloc]initWithDictionary:newEmployee];
    [[EmployeeDataStore sharedStore] createEmployee:dictionary];

    NSArray *updatedArray = [[EmployeeDataStore sharedStore] employees];
    XCTAssertNotEqual(oldArray.count, updatedArray.count);
}

- (void)testUpdateEmployee {
    
    NSMutableDictionary *newUpdate = [[NSMutableDictionary alloc]init];
    NSString *updatedStatus = @"Test Status";
    
    [newUpdate setValue:@"event" forKey:@"state_change"];
    [newUpdate setValue:@"oxymor0n" forKey:@"user"];
    [newUpdate setValue:updatedStatus forKey:@"state"];
    
    NSDictionary *dictionary = [[NSDictionary alloc]initWithDictionary:newUpdate];
    [[EmployeeDataStore sharedStore] updateEmployee:dictionary];
    
    NSArray *updatedArray = [[EmployeeDataStore sharedStore] employees];
    Employee *updatedEmployee = [[Employee alloc]init];
    
  for (Employee*employee in updatedArray)
  {
      if ([employee.githubHandle isEqualToString:@"oxymor0n"]) {
          updatedEmployee = employee;
      }
  }
    XCTAssertEqual(updatedEmployee.status, updatedStatus);
}


@end
