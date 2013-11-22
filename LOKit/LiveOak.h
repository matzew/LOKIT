/*
 * Copyright 2013 Red Hat, Inc. and/or its affiliates.
 *
 * Licensed under the Eclipse Public License version 1.0, available at http://www.eclipse.org/legal/epl-v10.html
 */

#import <Foundation/Foundation.h>

@interface LiveOak : NSObject {
    // nothing
}

// NOTE: path is an argument on the ctor/factory:
-(id) initWith:(NSString *) host port:(NSUInteger) port path:(NSString *)path secure:(BOOL)secure;
+(id) oakWith:(NSString *) host port:(NSUInteger) port path:(NSString *)path secure:(BOOL)secure;

#pragma mark - STOMP related hooks

-(void) connect:(void (^)(void))callback;
-(void) subscribe:(NSString *) path callback:(void (^)(id data))callback;

#pragma mark - CRUD/REST related hooks

// unlike in JS: no path here....
-(void) create:(id) data;
-(void) read:(void (^)(id data))callback;
-(void) update:(id) data;
-(void) remove; // delete is ObjC keyword

@end
