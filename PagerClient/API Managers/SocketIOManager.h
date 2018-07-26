//
//  SocketIOManager.h
//  PagerClient
//
//  Created by Abdullah Kahn on 7/24/18.
//  Copyright © 2018 Sifted. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRWebSocket.h"
#import "EmployeeDataStore.h"

@interface SocketIOManager : NSObject {
    SRWebSocket *webSocket;
}

+ (SocketIOManager *)sharedSocketManager;

- (void)startSocket;

@end
