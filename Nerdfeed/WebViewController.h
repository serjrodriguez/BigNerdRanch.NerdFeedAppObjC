//
//  WebViewController.h
//  Nerdfeed
//
//  Created by Sergio Rodriguez on 17/04/17.
//  Copyright © 2017 Sergio Rodriguez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListViewControllerTableViewController.h"

@interface WebViewController : UIViewController<UIWebViewDelegate, ListViewControllerDelegate, UISplitViewControllerDelegate>

@property (nonatomic, readonly) UIWebView *webView;

@end
