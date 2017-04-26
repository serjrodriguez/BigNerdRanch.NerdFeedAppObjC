//
//  BNRConnection.m
//  Nerdfeed
//
//  Created by Sergio Rodriguez on 26/04/17.
//  Copyright © 2017 Sergio Rodriguez. All rights reserved.
//

#import "BNRConnection.h"

static NSMutableArray *sharedConnectionList = nil;

@implementation BNRConnection
@synthesize request, completionBlock, xmlRootObject;

-(id)initWithRequest:(NSURLRequest *)req
{
    self = [super init];
    if (self) {
        [self setRequest:req];
    }
    return self;
}

-(void)start
{
    //Initialize container for data collected from NSURLConnection
    container = [[NSMutableData alloc] init];
    //Spawn collection
    internalConnection = [[NSURLConnection alloc] initWithRequest:[self request]
                                                         delegate:self startImmediately:YES];
    
    //If this is the first connection started, create the array
    if (!sharedConnectionList)
        sharedConnectionList = [[NSMutableArray alloc] init];
    
    //Add the connection to the array so it doesn´t get destroyed
    [sharedConnectionList addObject:self];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [container appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //If there is a root object
    if ([self xmlRootObject]) {
        //Create an object with the incoming data and let the root object parse its content
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:container];
        [parser setDelegate:[self xmlRootObject]];
        [parser parse];
    }
    
    //Then, pass the root object to the completion block - remember - this is the block that the controller supplied
    if ([self completionBlock])
        [self completionBlock]([self xmlRootObject], nil);
        
    //now destroy this connection
    [sharedConnectionList removeObject:self];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    //Pass the error from the connection to the completion block
    if ([self completionBlock])
        [self completionBlock](nil,error);
    
    //Destroy this connection
    [sharedConnectionList removeObject:self];
    
}
@end
