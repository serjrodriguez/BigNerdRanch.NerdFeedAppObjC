//
//  RSSItem.m
//  Nerdfeed
//
//  Created by Sergio Rodriguez on 17/04/17.
//  Copyright © 2017 Sergio Rodriguez. All rights reserved.
//

#import "RSSItem.h"

@implementation RSSItem

@synthesize title, link, parentParserDelegate;

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict{

    NSLog(@"\t\t%@ found a %@ element", self, elementName);
    
    if ([elementName isEqualToString:@"title"]){
        
        currentString = [[NSMutableString alloc] init];
        [self setTitle:currentString];
        
    }else if ([elementName isEqualToString:@"link"]){
        
        currentString = [[NSMutableString alloc] init];
        [self setLink:currentString];
        
    }

}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{

    [currentString appendString:string];

}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{

    currentString = nil;
    
    if([elementName isEqualToString:@"item"]){
    
        [parser setDelegate:parentParserDelegate];

    }
}

@end
