/*
 * Copyright 2013 Red Hat, Inc. and/or its affiliates.
 *
 * Licensed under the Eclipse Public License version 1.0, available at http://www.eclipse.org/legal/epl-v10.html
 */

#import "LiveOak.h"
#import "AeroGear.h"
#import "StompKit.h"

@implementation LiveOak {
    
    id<AGPipe> _oakPipe;
    STOMPClient *_stompClient;
}

-(id) initWith:(NSString *) host port:(NSUInteger)port path:(NSString *)path secure:(BOOL)secure{
    self = [super init];
    if (self) {

        // odd parsing required:
        NSString *httpURL = [@"http://" stringByAppendingString:[host stringByAppendingFormat:@":%i", port]];

        AGPipeline *pipeline = [AGPipeline pipelineWithBaseURL:[NSURL URLWithString:httpURL]];

        _oakPipe = [pipeline pipe:^(id<AGPipeConfig> config) {
            config.name = @"OakPipe"; // must have a name...
            config.endpoint = path;
        }];

        _stompClient = [[STOMPClient alloc] initWithHost:host port:port];
    }

    return self;
}

+(id) oakWith:(NSString *) host port:(NSUInteger) port path:(NSString *)path secure:(BOOL)secure{
    return [[self alloc] initWith:host port:port path:path secure:secure];
}

#pragma mark - STOMP related hooks

-(void) subscribe:(NSString *) path callback:(void (^)(id data))callback {
    [_stompClient subscribeTo:path messageHandler:^(STOMPMessage *message) {
        if (callback) {
            callback(message.body);
        }
    }];
}

-(void) connect:(void (^)(void))callback {

    [_stompClient connectWithHeaders:@{} completionHandler:^(STOMPFrame *connectedFrame, NSError *error) {
        if (callback) {
            callback();
        }
    }];
}

#pragma mark - CRUD/REST related hooks

-(void) create:(id) data {
    [_oakPipe save:((NSDictionary *) data) success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
}

-(void) read:(void (^)(id data))callback {
    
    [_oakPipe read:^(id responseObject) {
        if (callback) {
            callback(responseObject);
        }
        
    } failure:^(NSError *error) {
        if (callback) {
            callback(error);
        }
    }];
}

-(void) update:(id) data {
    // no-op...
}
-(void) remove{
    // no-op...
}


@end
