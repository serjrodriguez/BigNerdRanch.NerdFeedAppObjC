//
//  RSSChannel.h
//  Nerdfeed
//
//  Created by Sergio Rodriguez on 17/04/17.
//  Copyright © 2017 Sergio Rodriguez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSSChannel : NSObject<NSXMLParserDelegate>{

    NSMutableString *currentString;

}

@property (nonatomic, weak) id parentParserDelegate;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *infoString;
@property (nonatomic, strong) NSMutableArray *items;

-(void)trimItemTitles;

@end
