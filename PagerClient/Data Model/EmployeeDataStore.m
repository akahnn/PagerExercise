//
//  EmployeeDataStore.m
//  PagerClient
//
//  Created by Abdullah Kahn on 7/24/18.
//  Copyright © 2018 Sifted. All rights reserved.
//

#import "EmployeeDataStore.h"
#import "Employee.h"
#import "EmployeeListViewController.h"

@interface EmployeeDataStore () 

@property (nonatomic, strong) NSManagedObjectModel *model;
@property (nonatomic, strong) NSManagedObjectContext *context;

@end

@implementation EmployeeDataStore

- (id)init {
    if (self = [super init]) {
        [self initManagedObjectModel];
        [self initManagedObjectContext];
      
    }
    return self;
}

- (void)dataSourceUpdated: (EmployeeDataStore *) sender {
    [self.delegate dataSourceUpdated:self];
}

#pragma mark - instance methods for adding/updating managed objects

- (void)createEmployee:(NSDictionary*)employeeData {
    
    //Unarchive roles dictionary
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dictionary = [NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"rolesDictionary"]];
    NSString *role = [dictionary objectForKey:[[employeeData objectForKey:@"role"] stringValue]];

   //New employee
    Employee *newEmployee = [NSEntityDescription insertNewObjectForEntityForName:@"Employee"
                                                          inManagedObjectContext:self.context];
    
    newEmployee.name = [employeeData objectForKey:@"name"];
    newEmployee.avatarURL = [employeeData objectForKey:@"avatar"];
    newEmployee.githubHandle = [employeeData objectForKey:@"github"];
    newEmployee.gender =  [employeeData objectForKey:@"gender"];
    newEmployee.languages = [self getLanguageNameFromISOCode:[employeeData objectForKey:@"languages"]];
    newEmployee.location =  [self getCountryNameFromISOCode:[employeeData objectForKey:@"location"]];
    newEmployee.tags = [self arraytoData:[employeeData objectForKey:@"tags"]];
    newEmployee.role = role;
    
    NSError *error;
    [self save:error];
    [self dataSourceUpdated:nil];
    if (error) {
        [NSException raise:@"Couldn't Save to Persistence Store"
                    format:@"Error: %@", error.localizedDescription];
    }
}

- (void)updateEmployee:(NSDictionary*)updatedData {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Employee"];
    NSString *searchString = [updatedData objectForKey:@"user"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"githubHandle == %@",searchString];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *employees = [self.context executeFetchRequest:fetchRequest error:&error];
    
    if (employees.count != 0) {
        Employee *employee = employees.firstObject;
        employee.status = [updatedData objectForKey:@"state"];
        [self.context save:&error];
        NSLog(@"Context Saved");
        [self dataSourceUpdated:nil];
    }
}

- (NSArray *)employees {
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Employee"];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    NSError *error;
    NSArray *employees = [self.context executeFetchRequest:fetchRequest error:&error];
    
    if (error != nil) {
        [NSException raise:@"Exception on retrieving artists"
                    format:@"Error: %@", error.localizedDescription];
    }
    
    return employees;
}

- (void)save:(NSError *)error {
    [self.context save:&error];
}

#pragma mark - helper methods

-(NSData*)getLanguageNameFromISOCode:(NSArray*)arrayWithLanguageCodes {
    
    NSLocale *locale = [NSLocale localeWithLocaleIdentifier:@"en"];
    NSMutableArray *arrayWithLanguageNames = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < arrayWithLanguageCodes.count; i++) {
        NSString *languageDisplayName = [locale displayNameForKey:NSLocaleIdentifier value:arrayWithLanguageCodes[i]];
        
        if (languageDisplayName != nil) {
            [arrayWithLanguageNames addObject:languageDisplayName];
        }
    }
    
    return [self arraytoData:arrayWithLanguageNames];
}

-(NSString*)getCountryNameFromISOCode:(NSString*)countryISO{
    
    NSString *countryName = [[NSLocale systemLocale] displayNameForKey:NSLocaleCountryCode value:countryISO];
    return [[countryName stringByReplacingOccurrencesOfString:@" " withString:@"-"] lowercaseString];
}

-(NSData*)arraytoData:(NSArray*)array{
    
    return [NSKeyedArchiver archivedDataWithRootObject:array];
}

#pragma mark - static methods
+ (EmployeeDataStore *)sharedStore {
    static EmployeeDataStore *store;
    if (store == nil) {
        store = [[EmployeeDataStore alloc] init];
    }
    return store;
}

#pragma mark - private methods
- (void)initManagedObjectModel {
    NSURL *momdURL = [[NSBundle mainBundle] URLForResource:@"Team" withExtension:@"momd"];
    self.model = [[NSManagedObjectModel alloc] initWithContentsOfURL:momdURL];
}

- (void)initManagedObjectContext {
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.model];
    
    NSError *error;
    NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType
                                                 configuration:nil
                                                           URL:[self storeArchivePath]
                                                       options:nil
error:&error];
    if (store == nil || error != nil) {
        [NSException raise:@"Exception Occurred while adding persistence store"
                    format:@"Error: %@", error.localizedDescription];
    }
    
    self.context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [self.context setPersistentStoreCoordinator:psc];
}

- (NSURL *)storeArchivePath {
    NSArray *urls = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                           inDomains:NSUserDomainMask];
    return [[urls firstObject] URLByAppendingPathComponent:@"store.data"];
}


@end
