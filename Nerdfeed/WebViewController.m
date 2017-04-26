//
//  WebViewController.m
//  Nerdfeed
//
//  Created by Sergio Rodriguez on 17/04/17.
//  Copyright © 2017 Sergio Rodriguez. All rights reserved.
//

#import "WebViewController.h"
#import "RSSItem.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadView{

    
    CGRect screenFrame = [[UIScreen mainScreen] applicationFrame];
    UIWebView *wv = [[UIWebView alloc ]initWithFrame:screenFrame];
    [wv setScalesPageToFit:YES];
    [self setView:wv];

}

-(UIWebView *)webView{

    return (UIWebView *)[self view];

}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        return YES;
        return toInterfaceOrientation == UIInterfaceOrientationPortrait;

}

-(void)listViewController:(ListViewControllerTableViewController *)lvc handleObject:(id)object{

    RSSItem *entry = object;
    
    if (![entry isKindOfClass:[RSSItem class]])
        return;
    
    NSURL *url = [NSURL URLWithString:[entry link]];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [[self webView] loadRequest:req];
    
    [[self navigationItem] setTitle:[entry title]];

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
