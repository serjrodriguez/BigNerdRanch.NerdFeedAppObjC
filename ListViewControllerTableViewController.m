//
//  ListViewControllerTableViewController.m
//  Nerdfeed
//
//  Created by Sergio Rodriguez on 17/04/17.
//  Copyright © 2017 Sergio Rodriguez. All rights reserved.
//

#import "ListViewControllerTableViewController.h"
#import "RSSChannel.h"
#import "RSSItem.h"
#import "WebViewController.h"
#import "ChannelViewController.h"
#import "BNRFeedStore.h"

@interface ListViewControllerTableViewController ()

@end

@implementation ListViewControllerTableViewController

@synthesize webViewController;

-(id)initWithStyle:(UITableViewStyle)style{

    self = [super initWithStyle:style];
    
    if(self){
        
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithTitle:@"Info"
                                                                style:UIBarButtonItemStyleBordered
                                                               target:self action:@selector(showInfo:)];
        
        [[self navigationItem] setRightBarButtonItem:bbi];
        
        UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"BNR", @"Apple", nil]];
        
        [segmentedControl setSelectedSegmentIndex:0];
        [segmentedControl setSegmentedControlStyle:UISegmentedControlStyleBar];
        [segmentedControl addTarget:self
                             action:@selector(changeType:)
                   forControlEvents:UIControlEventValueChanged];
        [[self navigationItem] setTitleView:segmentedControl];
        
        [self fetchEntries];
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)fetchEntries{
    //initiate the request
    void (^completionBlock)(RSSChannel *obj, NSError *err) =
    ^(RSSChannel *obj, NSError *err){
        //when the request completes, this block will be called
        if (!err) {
            //if everything went ok, grab the channel object and reload the table
            channel = obj;
            [[self tableView] reloadData];
        }else{
            //If things went bad show an alert view
            NSString *errorString = [NSString stringWithFormat:@"Fetch failed: %@", [err localizedDescription]];
            
            //Create a show an alertview with the error displayed
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error"
                                                         message:errorString
                                                        delegate:nil
                                               cancelButtonTitle:@"Ok"
                                               otherButtonTitles:nil, nil];
            
            [av show];
        }
    };
    
    //initiate the request
    if (rssType == ListViewControllerRSSTypeBNR)
        [[BNRFeedStore sharedStore] fetchRSSFeedWithCompletion:completionBlock];
    else if (rssType == ListViewControllerRSSTypeApple)
             [[BNRFeedStore sharedStore] fetchTopSongs:10 withCompletion:completionBlock];
    
//    [[BNRFeedStore sharedStore] fetchRSSFeedWithCompletion:^(RSSChannel *obj, NSError *err) {
//        if (!err) {
//            channel = obj;
//            [[self tableView] reloadData];
//        }else{
//        
//            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error"
//                                                         message:[err localizedDescription]
//                                                        delegate:nil cancelButtonTitle:@"Ok"
//                                               otherButtonTitles:nil, nil];
//            [av show];
//        }
//    }];
    
    //    xmlData = [[NSMutableData alloc] init];
    //
    //    //NSURL *url = [NSURL URLWithString:@"http://forums.bignerdranch.com/smartfeed.php?"
    //                  //@"limit=1_DAY&sort_by=standard&feed_type=RSS2.0&feed_style=COMPACT"];
    //
    //    //for apple hot news rss feed
    //    NSURL *url = [NSURL URLWithString:@"http://www.apple.com/pr/feeds/pr.rss"];
    //
    //    //Put the url into a request
    //    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //
    //    //Create a connection that can exchange data from that url
    //    connection = [[NSURLConnection alloc] initWithRequest:request
    //                                                 delegate:self
    //                                         startImmediately:YES];
}

-(void)changeType:(id)sender
{
    rssType = [sender selectedSegmentIndex];
    [self fetchEntries];
}

-(void)showInfo:(id)sender{

    //Create the channel view controller
    ChannelViewController *channelViewController = [[ChannelViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
    if([self splitViewController]){
    
        UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:channelViewController];
        
        NSArray *vcs = [NSArray arrayWithObjects:[self navigationController], nvc, nil];
        
        [[self splitViewController] setViewControllers:vcs];
        
        [[self splitViewController] setDelegate:channelViewController];
        
        NSIndexPath *selectedRow = [[self tableView] indexPathForSelectedRow];
        
        if (selectedRow)
            [[self tableView] deselectRowAtIndexPath:selectedRow animated:YES];
    }else{
    
        [[self navigationController] pushViewController:channelViewController animated:YES];
    
    }
    
    [channelViewController listViewController:self handleObject:channel];

}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{

    if([[UIDevice currentDevice] userInterfaceIdiom] ==UIUserInterfaceIdiomPad)
        return YES;
        return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    //return 0;
    return [[channel items] count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if(![self splitViewController])
    [[self navigationController] pushViewController:webViewController animated:YES];
    
    else{
    
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:webViewController];
        
        NSArray *vcs = [NSArray arrayWithObjects:[self navigationController], nav, nil];
        
        [[self splitViewController] setViewControllers:vcs];
        
        [[self splitViewController] setDelegate:webViewController];
    
    }
    
    RSSItem *entry = [[channel items] objectAtIndex:[indexPath row]];
    
//    NSURL *url = [NSURL URLWithString:[entry link]];
//    NSURLRequest *req = [NSURLRequest requestWithURL:url];
//    [[webViewController webView] loadRequest:req];
//    [[webViewController navigationItem] setTitle:[entry title]];
    
    [webViewController listViewController:self handleObject:entry];

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    // Configure the cell...
    if (cell == nil){
    
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    
    }
    
    RSSItem *item = [[channel items] objectAtIndex:[indexPath row]];
    
    [[cell textLabel] setText:[item title]];
    
    return cell;
}

//-(void)connection:(NSURLConnection *)connection didReceiveData:(nonnull NSData *)data{
//
//    //Add the incoming chunk of data to the container we are keeping
//    //The data always comes in the correct order
//    [xmlData appendData:data];
//
//}

//-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
//
//    connection = nil;
//
//    xmlData = nil;
//
//    NSString *errorString = [NSString stringWithFormat:@"Fetch failed: %@", [error localizedDescription]];
//
//    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//
//    [av show];
//
//}

//-(void)connectionDidFinishLoading:(NSURLConnection *)conn{
//
////    NSString *xmlCheck = [[NSString alloc] initWithData:xmlData
////                                               encoding:NSUTF8StringEncoding];
////    NSLog(@"XMLCheck = %@", xmlCheck);
//
//    //Create the parser object with the data collected from the web service
//    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmlData];
//
//    [parser setDelegate:self];
//
//    [parser parse];
//
//    xmlData = nil;
//
//    connection = nil;
//
//    [[self tableView] reloadData];
//
//    NSLog(@"%@\n %@\n %@\n", channel, [channel title], [channel infoString]);
//
//}

//-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict{
//
//    NSLog(@"%@ found a %@ element ", self, elementName);
//
//    if([elementName isEqualToString:@"channel"]){
//
//        channel = [[RSSChannel alloc] init];
//
//        [channel setParentParserDelegate:self];
//
//        [parser setDelegate:channel];
//
//    }
//
//}

@end
