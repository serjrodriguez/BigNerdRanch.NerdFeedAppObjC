//
//  ChannelViewController.m
//  Nerdfeed
//
//  Created by Sergio Rodriguez on 17/04/17.
//  Copyright © 2017 Sergio Rodriguez. All rights reserved.
//

#import "ChannelViewController.h"
#import "RSSChannel.h"

@implementation ChannelViewController

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 2;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"UITableViewCell"];
    
    if([indexPath row] == 0){
    
        [[cell textLabel] setText:@"Title"];
        [[cell detailTextLabel] setText:[channel title]];
    
    }else{
    
        [[cell textLabel] setText:@"Info"];
        [[cell detailTextLabel] setText:[channel infoString]];
    
    }
    
    return cell;

}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        return YES;
        return toInterfaceOrientation == UIInterfaceOrientationPortrait;

}

-(void)listViewController:(ListViewControllerTableViewController *)lvc handleObject:(id)object{

    if (![object isKindOfClass:[RSSChannel class]])
        return;
    
    channel = object;
    
    [[self tableView] reloadData];

}

-(void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc
{
    [barButtonItem setTitle:@"List"];
    [[self navigationItem] setLeftBarButtonItem:barButtonItem];
}

-(void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    if (barButtonItem == [[self navigationItem] leftBarButtonItem]) {
        [[self navigationItem] setLeftBarButtonItem:nil];
    }
}

@end
