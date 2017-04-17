//
//  ListViewControllerTableViewController.h
//  Nerdfeed
//
//  Created by Sergio Rodriguez on 17/04/17.
//  Copyright © 2017 Sergio Rodriguez. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RSSChannel;
@class WebViewController;

@interface ListViewControllerTableViewController : UITableViewController<NSURLConnectionDelegate, NSXMLParserDelegate>{

    NSURLConnection *connection;
    NSMutableData *xmlData;
    
    RSSChannel *channel;

}

@property (nonatomic, strong) WebViewController *webViewController;

-(void)fetchEntries;

@end

@protocol ListViewControllerDelegate

-(void)listViewController:(ListViewControllerTableViewController *)lvc handleObject:(id)object;

@end
