//
//  ViewController.m
//  ChaiOne
//
//  Created by prerna chavan on 19/01/15.
//  Copyright (c) 2015 Synerzip. All rights reserved.
//

#import "ViewController.h"
#import "PostCell.h"
#import "AFNetworking.h"
#import "Reachability.h"
#import "UIRefreshControl+AFNetworking.h"
#import "Constant.h"

static NSString* const postCellIdentifier = @"PostCellIdentifier";

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (nonatomic, strong) NSMutableArray *posts;
@property (nonatomic, strong) Reachability *reachability;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Check for the internet connection notifications
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNetworkChange:) name:kReachabilityChangedNotification object:nil];
    
    self.reachability = [Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];
   
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    
    [self.listTableView addSubview:self.refreshControl];
    
    [self showLoading];
    [self refresh:self.refreshControl];
    
}

#pragma mark Network Change Notification

- (void) handleNetworkChange:(NSNotification *)notification
{
    [self isConnectedToInternet];
}

#pragma mark Helper Methods

// Hide table and show Loading text till table gets populated
-(void)showLoading
{
    [self.listTableView setHidden:YES];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicator.transform = CGAffineTransformMakeScale(2.0, 2.0);
    self.activityIndicator.hidesWhenStopped = YES;
    self.activityIndicator.center = self.view.center;
    [self.view addSubview:self.activityIndicator];
    [self.activityIndicator startAnimating];
}

-(void)hideLoading
{
    [self.listTableView setHidden:NO];

    [self.activityIndicator stopAnimating];
}

-(BOOL)isConnectedToInternet
{
    NetworkStatus remoteHostStatus = [self.reachability currentReachabilityStatus];
    
    if(remoteHostStatus == NotReachable)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:kNoInternetAlertTitle message:kNoInternetAlertMessage delegate:nil cancelButtonTitle:kCancel otherButtonTitles: nil];
        [alert show];
        
        return NO;
    }
    else
    {
        return YES;
    }
}

- (void)refresh:(UIRefreshControl *) refreshControl
{
    [refreshControl endRefreshing];
    
    // If no internet connection is present then show alert and dont pull new data
    
    if([self isConnectedToInternet] == NO)
    {
        [self.activityIndicator stopAnimating];

        return;
    }
    
    // Create request to fetch data

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:kPostURL parameters:nil success: ^(AFHTTPRequestOperation *operation, id responseObject) {
      
        NSError *error = nil;
        
        [self hideLoading];
        
        NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:& error];
        NSArray *array = [dataDictionary objectForKey:@"data"];
        self.posts = [NSMutableArray array];

        for(NSDictionary * postAttributes in array)
        {
            Post *post = [[Post alloc] initWithAtrributes:postAttributes];
            [self.posts addObject:post];
        }
        
        // Sort the list by createdDate as key
        
        NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"createdDate" ascending:YES];
        NSArray *sortedArray = [[self.posts sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]]mutableCopy];
        self.posts = [NSMutableArray arrayWithArray:sortedArray];
        
        
        // Table view reload is important to display new data

        [self.listTableView reloadData];
    }

     failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
        DebugLog(@"Error: %@", error.localizedDescription);
         
         [self.activityIndicator stopAnimating];

         UIAlertView *alert = [[UIAlertView alloc]initWithTitle:kCannotLoadPostsAlertTitle message:kCannotLoadPostsAlertMessage delegate:nil cancelButtonTitle:kCancel otherButtonTitles: nil];
         [alert show];

    }

    ];
    
}

#pragma mark UITableView Delegates

- (CGFloat)tableView:(UITableView *) tableView heightForRowAtIndexPath:(NSIndexPath *) indexPath
{
    // Calculate dynamic height for the cell
    return [PostCell heightForCellForPost:[self.posts objectAtIndex:indexPath.row]];
}

- (NSInteger)tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section
{
    return self.posts.count;
}

- (UITableViewCell *)tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath
{
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:postCellIdentifier];

    if(cell == nil)
    {
        cell = [[PostCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:postCellIdentifier];
    }

    cell.post = self.posts[indexPath.row];

    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
