//
//  AppBrowserViewController.m
//  TrickplayController_v2
//
//  Created by Rex Fenley on 3/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AppBrowserViewController.h"
#import "AppBrowser.h"
#import "Extensions.h"


@interface AppBrowserViewControllerContext : AppBrowserViewController {
    
@protected
    /*
     UIBarButtonItem *appShopButton;
     UIBarButtonItem *showcaseButton;
     UIToolbar *toolBar;
     */
    
    UITableView *tableView;
    // Spins while a app data is loading; disappears otherwise.
    UIActivityIndicatorView *loadingSpinner;
    
    // Refreshes the list of apps
    UIBarButtonItem *refreshButton;
    
    // Orange dot indicating which app is the current app
    UIImageView *currentAppIndicator;
    
    AppBrowser *appBrowser;
    
    id <AppBrowserViewControllerDelegate> delegate;
}


@end




@implementation AppBrowserViewControllerContext

//@synthesize tableView;
//@synthesize appBrowser;
//@synthesize delegate;

/*
@synthesize appShopButton;
@synthesize showcaseButton;
@synthesize toolBar;
*/

#pragma mark -
#pragma mark IBAction methods

- (IBAction)showcaseButtonClick {
}

- (IBAction)appShopButtonClick {
}

#pragma mark -
#pragma mark Forwarded Getters/Setters

- (UITableView *)tableView {
    UITableView *retval = nil;
    @synchronized(self) {
        retval = [[tableView retain] autorelease];
    }
    return retval;
}

- (void)setTableView:(UITableView *)_tableView {
    @synchronized(self) {
        [_tableView retain];
        [tableView release];
        tableView = _tableView;
    }
}

- (AppBrowser *)appBrowser {
    AppBrowser *retval = nil;
    @synchronized(self) {
        retval = [[appBrowser retain] autorelease];
    }
    return retval;
}

- (id <AppBrowserViewControllerDelegate>)delegate {
    id <AppBrowserViewControllerDelegate> val = nil;
    @synchronized(self) {
        val = delegate;
    }
    return val;
}

- (void)setDelegate:(id <AppBrowserViewControllerDelegate>)_delegate {
    @synchronized(self) {
        delegate = _delegate;
    }
}

#pragma mark -
#pragma mark Initialization

- (id)init {
    NSBundle *myBundle = [NSBundle bundleWithPath:[NSString stringWithFormat:@"%@%@", [NSBundle mainBundle].bundlePath, @"/TakeControl.framework"]];
    return [self initWithNibName:@"AppBrowserViewController" bundle:myBundle];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        appBrowser = [[AppBrowser alloc] init];
        [appBrowser addViewController:self];
    }
    
    return self;
}

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    return [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil appBrowser:[[[AppBrowser alloc] init] autorelease]];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil appBrowser:(AppBrowser *)browser {
    
    if (!nibNameOrNil || [nibNameOrNil compare:@"AppBrowserViewController"] != NSOrderedSame || !nibBundleOrNil || !browser || ![browser isKindOfClass:[AppBrowser class]]) {
        
        [self release];
        return nil;
    }
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        delegate = nil;
        appBrowser = [browser retain];
        [appBrowser addViewController:self];
    }
    
    return self;
}

#pragma mark -
#pragma mark View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"AppBrowserView Loaded!");
    // Initialize the orange indicator for the current running app
    if (!currentAppIndicator) {
        currentAppIndicator = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 10.0, 20.0, 20.0)];
        currentAppIndicator.backgroundColor = [UIColor colorWithRed:1.0 green:168.0/255.0 blue:18.0/255.0 alpha:1.0];
        currentAppIndicator.layer.borderWidth = 3.0;
        currentAppIndicator.layer.borderColor = [UIColor colorWithRed:1.0 green:200.0/255.0 blue:0.0 alpha:1.0].CGColor;
        currentAppIndicator.layer.cornerRadius = currentAppIndicator.frame.size.height/2.0;
    }
    
    // Add a button to the navigation bar that refreshes the list of advertised
    // services.
    refreshButton = [[UIBarButtonItem alloc] initWithTitle: @"Refresh" style:UIBarButtonItemStylePlain target:self action:@selector(refresh)];
    [[self navigationItem] setRightBarButtonItem:refreshButton];
    
    self.title = @"TV Apps";
    
    // Initialize the loadingSpinner if it does not exist
    if (!loadingSpinner) {
        loadingSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    // Set the delegate for the table which holds the app info
    [tableView setDelegate:self];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    NSLog(@"AppBrowserViewController didUnload");
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    if (tableView) {
        [tableView release];
        tableView = nil;
    }
    if (loadingSpinner) {
        [loadingSpinner stopAnimating];
        [loadingSpinner release];
        loadingSpinner = nil;
    }
    if (refreshButton) {
        [refreshButton release];
        refreshButton = nil;
    }
}

/*
- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"AppBrowserViewController did appear");
}
//*/
//*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
 }
//*/

#pragma mark -
#pragma mark Retrieving App Info From Network

- (void)refresh {
    [appBrowser refresh];
}

#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

/**
 * Customize the number of rows in the table view. The number of rows is equlivalent
 * to the number of apps available. If Trickplay has no apps then one row is
 * still created which will be populated with a string informing the user there
 * are no available apps.
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (!appBrowser.availableApps || [appBrowser.availableApps count] == 0) {
        return 1;
    }
    return [appBrowser.availableApps count];
}

/**
 * Customize the appearance of table view cells. Each cell will contain the name
 * of an app available on Trickplay. Selecting an app will launch the app on
 * Trickplay.
 */
- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *tableCellIdentifier = @"UITableViewCell";
	UITableViewCell *cell = (UITableViewCell *)[_tableView dequeueReusableCellWithIdentifier:tableCellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableCellIdentifier] autorelease];
	}
    
    if (!appBrowser.availableApps || [appBrowser.availableApps count] == 0) {
        cell.textLabel.text = @"Loading Data...";
        [currentAppIndicator removeFromSuperview];
        cell.accessoryView = loadingSpinner;
        [loadingSpinner startAnimating];
        cell.userInteractionEnabled = NO;
        
        return cell;
    }
    
    cell.userInteractionEnabled = YES;
    
    [loadingSpinner stopAnimating];
    [loadingSpinner removeFromSuperview];
    cell.accessoryView = nil;
    
    AppInfo *app = [appBrowser.availableApps objectAtIndex:indexPath.row];
    cell.textLabel.text = app.name;
    cell.textLabel.textColor = [UIColor blackColor];
    
    if (appBrowser.currentApp && appBrowser.currentApp.name && [cell.textLabel.text compare:appBrowser.currentApp.name] == NSOrderedSame) {
        [cell addSubview:currentAppIndicator];
        cell.textLabel.text = [NSString stringWithFormat:@"     %@", cell.textLabel.text];
    } else {
        for (UIImageView *view in cell.subviews) {
            if (view == currentAppIndicator) {
                [currentAppIndicator removeFromSuperview];
            }
        }
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
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
 // Delete the row from the data source.
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
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


#pragma mark -
#pragma mark Table view delegate

/**
 * Override to support row selection in the table view. Selecting a row tells
 * Trickplay to launch the app populated by that row.
 */
- (void)tableView:(UITableView *)_tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"Selected row %@\n", indexPath);
    
    if (appBrowser.availableApps && appBrowser.availableApps.count > 0 && indexPath.row < appBrowser.availableApps.count) {
        
        AppInfo *app = [appBrowser.availableApps objectAtIndex:indexPath.row];
        
        if (appBrowser.currentApp != app) {
            [appBrowser launchApp:[appBrowser.availableApps objectAtIndex:indexPath.row]];
            [self.delegate appBrowserViewController:self didSelectApp:app isCurrentApp:NO];
        } else {
            [self.delegate appBrowserViewController:self didSelectApp:app isCurrentApp:YES];
        }
    } else {
        [self refresh];
    }
    
	NSIndexPath *indexPath2 = [_tableView indexPathForSelectedRow];
	if (indexPath2 != nil)
	{
		[_tableView deselectRowAtIndexPath:indexPath2 animated:YES];
	}
	
}

#pragma mark -
#pragma mark Memory Management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)dealloc {
    NSLog(@"AppBrowserViewController dealloc");
    self.delegate = nil;
    
    if (tableView) {
        [tableView release];
        tableView = nil;
    }
    if (loadingSpinner) {
        [loadingSpinner stopAnimating];
        [loadingSpinner release];
        loadingSpinner = nil;
    }
    if (currentAppIndicator) {
        [currentAppIndicator release];
    }
    
    [appBrowser invalidateViewController:self];
    [appBrowser cancelRefresh];
    [appBrowser release];
    appBrowser = nil;
    
    [super dealloc];
}


@end



#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -




@implementation AppBrowserViewController

#pragma mark -
#pragma mark Allocation

+ (id)alloc {
    if ([self isEqual:[AppBrowserViewController class]]) {
        NSZone *temp = [self zone];
        [self release];
        return [AppBrowserViewControllerContext allocWithZone:temp];
    } else {
        return [super alloc];
    }
}

+ (id)allocWithZone:(NSZone *)zone {
    if ([self isEqual:[AppBrowserViewController class]]) {
        return [AppBrowserViewControllerContext allocWithZone:zone];
    } else {
        return [super allocWithZone:zone];
    }
}

#pragma mark -
#pragma mark Initialization

- (id)init {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

#pragma mark -
#pragma mark Initialization

- (IBAction)showcaseButtonClick {
}

- (IBAction)appShopButtonClick {
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil appBrowser:(AppBrowser *)browser {
    
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

#pragma mark -
#pragma mark Forwarded Getters/Setters

- (UITableView *)tableView {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (void)setTableView:(UITableView *)tableView {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (AppBrowser *)appBrowser {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (void)setAppBrowser:(AppBrowser *)appBrowser {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (id <AppBrowserViewControllerDelegate>)delegate {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (void)setDelegate:(id <AppBrowserViewControllerDelegate>)delegate {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

#pragma mark -
#pragma mark Forwarded Methods

- (void)refresh {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

/**
 * Customize the number of rows in the table view. The number of rows is equlivalent
 * to the number of apps available. If Trickplay has no apps then one row is
 * still created which will be populated with a string informing the user there
 * are no available apps.
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	@throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

/**
 * Customize the appearance of table view cells. Each cell will contain the name
 * of an app available on Trickplay. Selecting an app will launch the app on
 * Trickplay.
 */
- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

#pragma mark -
#pragma mark Table view delegate

/**
 * Override to support row selection in the table view. Selecting a row tells
 * Trickplay to launch the app populated by that row.
 */
- (void)tableView:(UITableView *)_tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

#pragma mark -
#pragma mark Memory Management

/*
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}
*/

/*
- (void)dealloc {
    NSLog(@"AppBrowserViewController dealloc");
    
    [super dealloc];
}
 */


@end
