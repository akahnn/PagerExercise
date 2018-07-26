//
//  SocketIOManager.m
//  PagerClient
//
//  Created by Abdullah Kahn on 7/24/18.
//  Copyright © 2018 Sifted. All rights reserved.
//

#define  SOCKET_HOST @"wss://ios-hiring-backend.dokku.canillitapp.com"
#define  PORT 80   //use 443 for secure connection.
#define  EMPLOYEE_UPDATED @"state_change"
#define  EMPLOYEE_ADDED @"user_new"

#import "SocketIOManager.h"

@interface SocketIOManager () <SRWebSocketDelegate>

@end

@implementation SocketIOManager

+ (SocketIOManager *)sharedSocketManager {
    static SocketIOManager *manager;
    if (manager == nil) {
        manager = [[SocketIOManager alloc] init];
    }
    return manager;
}

-(void)startSocket {
    dispatch_async(dispatch_get_main_queue(), ^{
        self->webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"wss://ios-hiring-backend.dokku.canillitapp.com"]]];
        self->webSocket.delegate = self;
        [self->webSocket open];
    });
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket{
    NSLog(@"webSocketDidOpen");
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(NSString*)message {
    
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    if ([[json objectForKey:@"event"]  isEqual:EMPLOYEE_ADDED]) {
        NSLog(@"EMPLOYEE_ADDED");
        [[EmployeeDataStore sharedStore] createEmployee:[json objectForKey:@"user"]];
    }
    else if ([[json objectForKey:@"event"]  isEqual:EMPLOYEE_UPDATED]) {
        [[EmployeeDataStore sharedStore] updateEmployee:json];
        NSLog(@"EMPLOYEE_UPDATED");
    }
     }

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error{
    NSLog(@"didFailWithError %@",error.description);
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(nullable NSString *)reason wasClean:(BOOL)wasClean {
    NSLog(@"didCloseWithCode %@",reason);
}

@end
