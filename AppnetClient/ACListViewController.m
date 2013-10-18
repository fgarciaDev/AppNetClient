//
//  ACListViewController.m
//  AppnetClient
//
//  Created by Francisco Garcia on 10/16/13.
//  Copyright (c) 2013 Francisco Garcia. All rights reserved.
//

#import "ACListViewController.h"
#import "ACFeed.h"


@interface ACListViewController () <NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData *jsonData;
@property (nonatomic, strong) ACFeed *feed;

- (void)fetchFeed;

@end


//----------------------------------------------------------------------------//


@implementation ACListViewController


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
        // kickoff the feed fetch once our listviewcontroller is created
        [self fetchFeed];
    }
    
    UINavigationItem *navItem = self.navigationItem;
    [navItem setTitle:@"App.net"];
    
    return self;
}


- (void)viewDidLoad
{
    // setup the pull-down refresh config
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to refresh"];
    [refresh addTarget:self
                action:@selector(refreshFeed:)
      forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
}


- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    // return the number of posts in the feed
    return [_feed.posts count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger i = [indexPath row];
    NSString *date = [_feed dateStringForPostAtIndex:i];
    NSString *text = [_feed textForPostAtIndex:i];
    // tag on the post date to the end of the post text
    text = [text stringByAppendingFormat:@"\n%@",date];
    NSString *usernick = [_feed usernickForPostAtIndex:i];
    UIImage *avatar = [_feed userAvatarForPostAtIndex:i];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];
    }
    
    cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.detailTextLabel.font =
        [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    // set no limit to the number of lines in the detail (post) text
    cell.detailTextLabel.numberOfLines = 0;
    
    [cell.textLabel setText:usernick];
    [cell.detailTextLabel setText:text];
    [cell.imageView setImage:avatar];
    
    return cell;
}


- (CGFloat)textViewHeightForAttributedText:(NSAttributedString*)text
                                  andWidth:(CGFloat)width
{
    // estimate the height of the cell for the text string in a post
    UITextView *calculationView = [[UITextView alloc] init];
    [calculationView setAttributedText:text];
    CGSize size = [calculationView sizeThatFits:CGSizeMake(width, FLT_MAX)];
    CGFloat PADDING = 10;
    CGFloat h = PADDING + size.height + PADDING;
    return h;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // override the default height of a table cell
    NSInteger i = [indexPath row];
    NSString *text = [_feed textForPostAtIndex:i];
    NSMutableAttributedString *aString = [[NSMutableAttributedString alloc] initWithString:text];
    [aString addAttribute:NSFontAttributeName value:[UIFont preferredFontForTextStyle:UIFontTextStyleCaption1] range:NSMakeRange(0, text.length)];
    
    // return the estimated height of the cell for the text in this post
    return [self textViewHeightForAttributedText:aString andWidth:200];
}


- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // setup a new view with a basic webview of the selected post and puts
    // it in the nav controller stack so we have an easy way back
    NSInteger i = [indexPath row];
    NSURL *url = [_feed urlForPost:i];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    UIViewController *webVC = [[UIViewController alloc] init];
    webVC.view = webView;
    
    [self.navigationController pushViewController:webVC animated:YES];
}


- (void)fetchFeed
{
    // fetch App.net json feed
    
    // show the status bar netwrok activity indicator so the user has
    // visual feedback that we are fetching data
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    _jsonData = [[NSMutableData alloc] init];
    
    NSString *requestString = @"https://alpha-api.app.net/stream/0/posts/stream/global";
    NSURL *url = [NSURL URLWithString:requestString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}


- (void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)data
{
    // add chunks of incoming data to our json container
    [_jsonData appendData:data];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)conn
{
    // dictionize our json data
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:_jsonData
                                                               options:0
                                                                 error:nil];
    // parse the data into our feed
    ACFeed *c = [[ACFeed alloc] init];
    [c readFromJSONObject:jsonObject];
    _feed = c;
    
    // stop the status bar network activity indicator and reload the table
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self.tableView reloadData];
}


- (void)connection:(NSURLConnection *)conn didFailWithError:(NSError *)error
{
    // we have no internet connection or the server is down. alert the
    // user to the failed connection.
    
    // clear out our objects for this failed request
    _connection = nil;
    _jsonData = nil;
    
    // get the error description
    NSString *errString = [error localizedDescription];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Failure: Check internet connection"
                                                    message:errString
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
    [alert show];
}


- (void)refreshFeed:(UIRefreshControl *)refreshControl
{
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Updating..."];

    //refresh feed
    [self fetchFeed];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MMM d, h:mm a"];
    NSString *updated = [NSString stringWithFormat:@"Last update: %@", [format stringFromDate:[NSDate date]]];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:updated];
    [refreshControl endRefreshing];
}


@end
