//
//  AddEmployeeViewController.m
//  PagerClient
//
//  Created by Abdullah Kahn on 7/25/18.
//  Copyright © 2018 Sifted. All rights reserved.
//

#import "AddEmployeeViewController.h"
#import "XLFormViewController.h"
#import "AFNetworking.h"
#import "HTTPSAPIManager.h"

@interface AddEmployeeViewController ()

@end

@implementation AddEmployeeViewController
static NSString *const XLFormRowDescriptorTypeText = @"text";
static NSString *const XLFormRowDescriptorTypeSelectorActionSheet = @"selectorActionSheet";
static NSString *const XLFormRowDescriptorTypeButton = @"button";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
        [self initializeForm];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self){
        [self initializeForm];
    }
    return self;
}

- (void)initializeForm {
    
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    form = [XLFormDescriptor formDescriptorWithTitle:@"Add Event"];
  
    // First section
    section = [XLFormSectionDescriptor formSection];
    section.title = @"Add New Employee";

    [form addFormSection:section];
    
    // Name
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"name" rowType:XLFormRowDescriptorTypeText];
    [row.cellConfigAtConfigure setObject:@"Name" forKey:@"textField.placeholder"];
    [section addFormRow:row];
    
    // Github
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"github" rowType:XLFormRowDescriptorTypeText];
    [row.cellConfigAtConfigure setObject:@"Github" forKey:@"textField.placeholder"];
    [section addFormRow:row];

    // Second Section
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    // Gender
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeSelectorActionSheet title:@"Gender"];
    row.noValueDisplayText = @"select";
    row.selectorOptions = @[@"Male", @"Female"];
    [section addFormRow:row];
    
    // Role
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeSelectorActionSheet title:@"Role"];
    row.noValueDisplayText = @"select";
    row.selectorOptions = @[@"Engineering Manager", @"iOS Engineering", @"Senior Software Engineer", @"JS Engineering", @"Backend Engineering",@"Machine Learning Engineering"];
    [section addFormRow:row];
    
    // Third Section
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    // Button
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"Button" rowType:XLFormRowDescriptorTypeButton title:@"Submit"];
    row.action.formSelector = @selector(didTouchButton:);
    [row.cellConfigAtConfigure setObject:[UIColor darkGrayColor] forKey:@"backgroundColor"];
    [row.cellConfig setObject:[UIColor whiteColor] forKey:@"textLabel.color"];
    [row.cellConfig setObject:[UIFont fontWithName:@"Helvetica" size:17] forKey:@"textLabel.font"];
    [section addFormRow:row];
    
    self.form = form;
}

-(void)didTouchButton:(XLFormRowDescriptor *)sender {
    
    NSArray *array = [[NSArray alloc]initWithObjects:@"object1",@"object2",@"object3", nil];
    
    NSMutableDictionary *newEmployee = [[NSMutableDictionary alloc]init];
    [newEmployee setValue:@"New User" forKey:@"name"];
    [newEmployee setValue:@"avatarURL" forKey:@"avatar"];
    [newEmployee setValue:@"newuser" forKey:@"github"];
    [newEmployee setValue:[NSNumber numberWithInt:1] forKey:@"role"];
    [newEmployee setValue:@"Male" forKey:@"gender"];
    [newEmployee setValue:@"us" forKey:@"location"];
    [newEmployee setValue:array forKey:@"languages"];
    [newEmployee setValue:array forKey:@"roles"];
    
    HTTPSAPIManager *apiManager = [HTTPSAPIManager sharedAPIManager];
    [apiManager postToServer:newEmployee];
    
    [self dismissViewControllerAnimated:true completion:nil];
}

@end
