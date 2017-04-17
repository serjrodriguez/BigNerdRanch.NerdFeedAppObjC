//
//  ChannelViewController.h
//  Nerdfeed
//
//  Created by Sergio Rodriguez on 17/04/17.
//  Copyright © 2017 Sergio Rodriguez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ListViewControllerTableViewController.h"

@class RSSChannel;

@interface ChannelViewController : UITableViewController<ListViewControllerDelegate>{

    RSSChannel *channel;

}

@end
