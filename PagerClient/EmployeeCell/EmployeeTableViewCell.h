//
//  EmployeeTableViewCell.h
//  PagerClient
//
//  Created by Abdullah Kahn on 7/24/18.
//  Copyright © 2018 Sifted. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmployeeTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) IBOutlet UILabel *employeeName;
@property (strong, nonatomic) IBOutlet UILabel *employeeRole;
@property (strong, nonatomic) IBOutlet UILabel *employeeStatus;
@property (strong, nonatomic) IBOutlet UIImageView *counryFlagImage;

@end
