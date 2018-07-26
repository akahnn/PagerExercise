//
//  EmployeeDetailsViewController.m
//  PagerClient
//
//  Created by Abdullah Kahn on 7/24/18.
//  Copyright © 2018 Sifted. All rights reserved.
//

#import "EmployeeDetailsViewController.h"

@interface EmployeeDetailsViewController ()

@end

@implementation EmployeeDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpView];
}

-(void)setUpView {
    self.navigationItem.title = @"Details";

    self.employeeName.text = self.employee.name;
    self.employeeStatus.text = self.employee.status;
    self.employeeGithub.text= self.employee.githubHandle;
    self.employeeRole.text = self.employee.role;
    
    NSArray *languagesArray = [NSKeyedUnarchiver unarchiveObjectWithData:self.employee.languages];
    NSArray *skillsArray = [NSKeyedUnarchiver unarchiveObjectWithData:self.employee.tags];
    
    self.employeeSkills.text = [skillsArray componentsJoinedByString:@" , "];
    self.employeeLanguages.text = [languagesArray componentsJoinedByString:@" , "];
    
    self.profileImage.layer.cornerRadius = 65;
    self.profileImage.layer.masksToBounds = YES;
    self.countryFlag.image = [UIImage imageNamed:self.employee.location];
    
    [self.profileImage sd_setImageWithURL:[NSURL URLWithString:self.employee.avatarURL]
                         placeholderImage:[UIImage imageNamed:@"profilePlaceHolder"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
