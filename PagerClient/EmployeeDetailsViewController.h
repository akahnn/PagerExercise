//
//  EmployeeDetailsViewController.h
//  PagerClient
//
//  Created by Abdullah Kahn on 7/24/18.
//  Copyright © 2018 Sifted. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Employee.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface EmployeeDetailsViewController : UIViewController

@property (nonatomic,strong) Employee *employee;

@property (strong, nonatomic) IBOutlet UIImageView *countryFlag;
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) IBOutlet UILabel *employeeName;
@property (strong, nonatomic) IBOutlet UILabel *employeeRole;
@property (strong, nonatomic) IBOutlet UILabel *employeeStatus;
@property (strong, nonatomic) IBOutlet UILabel *employeeSkills;
@property (strong, nonatomic) IBOutlet UILabel *employeeLanguages;
@property (strong, nonatomic) IBOutlet UILabel *employeeGithub;

@end
