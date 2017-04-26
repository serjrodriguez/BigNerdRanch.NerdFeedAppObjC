//
//  BNRFeedStore.h
//  Nerdfeed
//
//  Created by Sergio Rodriguez on 26/04/17.
//  Copyright © 2017 Sergio Rodriguez. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RSSChannel;

@interface BNRFeedStore : NSObject

+(BNRFeedStore *)sharedStore;

-(void)fetchTopSongs:(int)count withCompletion:(void (^)(RSSChannel *obj, NSError *err))block;
-(void)fetchRSSFeedWithCompletion:(void (^)(RSSChannel *obj, NSError *err))block;

@end
