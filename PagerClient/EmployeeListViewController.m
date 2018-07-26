//
//  EmployeeListViewController.m
//  PagerClient
//
//  Created by Abdullah Kahn on 7/24/18.
//  Copyright © 2018 Sifted. All rights reserved.
//

#define  ROW_HEIGHT 130
#define  CELL_IDENTIFIER @"employeeCell"

#import "EmployeeListViewController.h"
#import "EmployeeTableViewCell.h"
#import "EmployeeDetailsViewController.h"
#import "EmployeeDataStore.h"
#import "HTTPSAPIManager.h"
#import "SocketIOManager.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface EmployeeListViewController () <UITableViewDataSource,
UITableViewDelegate, EmployeeDataStoreDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)  NSArray *employees;

@end

@implementation EmployeeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self dataSourceUpdated:nil];
    [EmployeeDataStore sharedStore].delegate = self;

    SocketIOManager *manager = [SocketIOManager sharedSocketManager];
    [manager startSocket];
}

- (void)dataSourceUpdated: (EmployeeListViewController *) sender {
    self.employees = nil;
    self.employees = [[EmployeeDataStore sharedStore] employees];
    [self.tableView reloadData];
    
    if (self.employees.count == 0) {
        HTTPSAPIManager *apiManager = [HTTPSAPIManager sharedAPIManager];
        [apiManager initDataSource];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView
{
    return 1;
}
- (IBAction)addEmployee:(id)sender {
    [self performSegueWithIdentifier:@"addEmployee" sender:nil];
}

- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section
{
    return self.employees.count;
}

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = CELL_IDENTIFIER;
    
    EmployeeTableViewCell *cell = (EmployeeTableViewCell *)[theTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[EmployeeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    Employee *employee = [self.employees objectAtIndex:indexPath.row];

    NSString *headline = [NSString stringWithFormat:@"%@ (@%@)",employee.name,employee.githubHandle];
    NSString *employeeRole = [NSString stringWithFormat:@" |  %@",employee.role];
    
    cell.employeeName.text = headline;
    cell.employeeRole.text = employeeRole;
    cell.employeeStatus.text = employee.status;
        
    cell.counryFlagImage.image = [UIImage imageNamed:employee.location];
    [cell.profileImage sd_setImageWithURL:[NSURL URLWithString:employee.avatarURL]
                 placeholderImage:[UIImage imageNamed:@"profilePlaceHolder"]];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"showDetails" sender:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ROW_HEIGHT;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showDetails"]) {
        EmployeeDetailsViewController *detailsView = (EmployeeDetailsViewController *)segue.destinationViewController;
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Employee *employee = [self.employees objectAtIndex:indexPath.row];
        detailsView.employee = employee;
    }
}


@end
