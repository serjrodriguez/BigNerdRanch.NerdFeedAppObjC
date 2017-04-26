//
//  BNRConnection.h
//  Nerdfeed
//
//  Created by Sergio Rodriguez on 26/04/17.
//  Copyright © 2017 Sergio Rodriguez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNRConnection : NSObject<NSURLConnectionDelegate, NSURLConnectionDataDelegate>{
    NSURLConnection *internalConnection;
    NSMutableData *container;
}

-(id)initWithRequest:(NSURLRequest *)req;

@property (nonatomic, copy) NSURLRequest *request;
@property (nonatomic, copy) void (^completionBlock)(id obj, NSError *err);
@property (nonatomic, strong) id<NSXMLParserDelegate> xmlRootObject;

-(void)start;

@end
