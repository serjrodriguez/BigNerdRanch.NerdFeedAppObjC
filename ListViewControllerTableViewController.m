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

    xmlData = [[NSMutableData alloc] init];
    
    //NSURL *url = [NSURL URLWithString:@"http://forums.bignerdranch.com/smartfeed.php?"
                  //@"limit=1_DAY&sort_by=standard&feed_type=RSS2.0&feed_style=COMPACT"];
    
    //for apple hot news rss feed
    NSURL *url = [NSURL URLWithString:@"http://www.apple.com/pr/feeds/pr.rss"];
    
    //Put the url into a request
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //Create a connection that can exchange data from that url
    connection = [[NSURLConnection alloc] initWithRequest:request
                                                 delegate:self
                                         startImmediately:YES];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(nonnull NSData *)data{

    //Add the incoming chunk of data to the container we are keeping
    //The data always comes in the correct order
    [xmlData appendData:data];

}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{

    connection = nil;
    
    xmlData = nil;
    
    NSString *errorString = [NSString stringWithFormat:@"Fetch failed: %@", [error localizedDescription]];
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [av show];

}

-(void)connectionDidFinishLoading:(NSURLConnection *)conn{

//    NSString *xmlCheck = [[NSString alloc] initWithData:xmlData
//                                               encoding:NSUTF8StringEncoding];
//    NSLog(@"XMLCheck = %@", xmlCheck);
    
    //Create the parser object with the data collected from the web service
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmlData];
    
    [parser setDelegate:self];
    
    [parser parse];
    
    xmlData = nil;
    
    connection = nil;
    
    [[self tableView] reloadData];
    
    NSLog(@"%@\n %@\n %@\n", channel, [channel title], [channel infoString]);

}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict{

    NSLog(@"%@ found a %@ element ", self, elementName);
    
    if([elementName isEqualToString:@"channel"]){
    
        channel = [[RSSChannel alloc] init];
        
        [channel setParentParserDelegate:self];
        
        [parser setDelegate:channel];
    
    }

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


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
