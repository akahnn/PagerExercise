//
//  AppDelegate.h
//  PagerClient
//
//  Created by Abdullah Kahn on 7/23/18.
//  Copyright © 2018 Sifted. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;

@end

