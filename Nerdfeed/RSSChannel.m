//
//  RSSChannel.m
//  Nerdfeed
//
//  Created by Sergio Rodriguez on 17/04/17.
//  Copyright © 2017 Sergio Rodriguez. All rights reserved.
//

#import "RSSChannel.h"
#import "RSSItem.h"

@implementation RSSChannel

@synthesize items,title,infoString,parentParserDelegate;

-(id)init{

    self = [super init];
    
    if(self){
        items = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict{

    NSLog(@"\t%@ found a %@ element", self, elementName);
    
    if ([elementName isEqualToString:@"title"]) {
        
        currentString = [[NSMutableString alloc] init];
        [self setTitle:currentString];
        
    }else if([elementName isEqualToString:@"description"]){
        
        currentString = [[NSMutableString alloc] init];
        [self setInfoString:currentString];
        
    }else if ([elementName isEqualToString:@"item"]){
    
        RSSItem *entry = [[RSSItem alloc] init];
        
        [entry setParentParserDelegate:self];
        
        [parser setDelegate:entry];
        
        [items addObject:entry];
        
    }

}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{

    currentString = nil;
    
    if([elementName isEqualToString:@"channel"]){
    
        [parser setDelegate:parentParserDelegate];
    
    }

}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{

    [currentString appendString:string];
    
}

@end
