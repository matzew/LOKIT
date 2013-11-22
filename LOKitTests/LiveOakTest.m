/*
 * Copyright 2013 Red Hat, Inc. and/or its affiliates.
 *
 * Licensed under the Eclipse Public License version 1.0, available at http://www.eclipse.org/legal/epl-v10.html
 */

#import <XCTest/XCTest.h>
#import "LOKit.h"

@interface LiveOakTest : XCTestCase

@end

@implementation LiveOakTest {
    // test ivars goes here...
    LiveOak *_liveOak;
    
    
    BOOL _finishRunLoop;
}

- (void)setUp {
    [super setUp];

    _liveOak = [LiveOak oakWith:@"127.0.0.1" port:8080 path:@"/storage/chat" secure:NO];
}

- (void)tearDown {
    
    [super tearDown];
}

- (void)testExample {

    [_liveOak connect:^{

        [_liveOak subscribe:@"/storage/chat" callback:^(id data) {
            NSLog(@"got message: %@", data);
            
            // 'latch'
            _finishRunLoop = YES;
        }];
        

        // read all 'existing' data
        [_liveOak read:^(id data) {
            NSLog(@"%@", data);
        }];
        
    }];
    
    // POST some JSON:
    [_liveOak create:@{@"name": @"Matthias-iOS",@"text": @"Hello from iOS!"}];

    while(!_finishRunLoop) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
}

@end
