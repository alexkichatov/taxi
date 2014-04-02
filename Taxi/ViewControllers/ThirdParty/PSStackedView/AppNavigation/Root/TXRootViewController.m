#import <objc/runtime.h>
#import "TXRootViewController.h"
#import "TXStackedViewController.h"
#import "UIToolbar+AddItems.h"
#import "SVProgressHUD.h"
#import "UIViewController+PSStackedView.h"
#import "TXSimpleSubMenuCell.h"
#import "TXAlertView.h"

static int const kVisibleStackWidth = 1;
static int const kMaxBackButtonLength = 64;
static NSString *const kRightBarButtonItemsKeyPath = @"rightBarButtonItems";


@interface TXRootViewController ()
@property (nonatomic, weak) IBOutlet UITableView* menuTableView;
@property (nonatomic, weak) IBOutlet UIToolbar* topToolbar;
@property (nonatomic, weak) UILabel* titleLabel;
@property (nonatomic, strong) NSIndexPath* selectedIndexPath;
@property (nonatomic, readonly) TXStackedViewController *stackedViewController;
@property (nonatomic, strong) UIButton* backButtonForFirstController;
@end

@implementation TXRootViewController
{
    NSIndexPath *_selectedIndexPath;
    UIBarButtonItem *_backButtonItem;
    NSMutableSet *_observedControllerItems;
}

#pragma mark - Initialization and memory management

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) 
    {
        _observedControllerItems = [NSMutableSet setWithCapacity:3];
        self.menuItems = @[];
        [self constructMenus];
        [_menuTableView reloadData];
        _selectedIndexPath = nil;
    }
    return self;
}

//override to create menus
- (void)constructMenus
{
}

- (TXStackedViewController *)stackedViewController
{
    if ([self.parentViewController isKindOfClass:[TXStackedViewController class]])
        return (TXStackedViewController *) self.parentViewController;
    return nil;
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _menuTableView.delegate = nil;
    _menuTableView.dataSource = nil;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    UINib *menuCellNib = [UINib nibWithNibName:[TXMenuCell reuseIdentifier] bundle:[NSBundle mainBundle]];
    [self.menuTableView registerNib:menuCellNib forCellReuseIdentifier:[TXMenuCell reuseIdentifier]];
    UINib *subMenuCellNib = [UINib nibWithNibName:[TXSimpleSubMenuCell reuseIdentifier] bundle:[NSBundle mainBundle]];
    [self.menuTableView registerNib:subMenuCellNib forCellReuseIdentifier:[TXSimpleSubMenuCell reuseIdentifier]];

    UILabel *label = [self createTitleLabel];
    self.titleLabel = label;
    [self.topToolbar insertItem:[[UIBarButtonItem alloc] initWithCustomView:label] atIndex:_topToolbar.items.count/2 animated:NO];

    if (self.selectedIndexPath && self.selectedIndexPath.row >= 0)
        [self.menuTableView selectRowAtIndexPath:_selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.menuTableView reloadData];
    if (self.selectedIndexPath)
    {
        [self.menuTableView selectRowAtIndexPath:self.selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    [self.menuTableView setNeedsDisplay];
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.menuTableView.delegate = nil;
    self.menuTableView.dataSource = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.menuTableView reloadData];
    if (self.selectedIndexPath)
    {
        [self.menuTableView selectRowAtIndexPath:self.selectedIndexPath
                                        animated:NO
                                  scrollPosition:UITableViewScrollPositionNone];
    }
}

#pragma mark - UI customizations

- (UILabel *)createTitleLabel
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 400, CGRectGetHeight(_topToolbar.frame))];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithWhite:0.1 alpha:1.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"ArialMT" size:20];
    label.minimumScaleFactor = 0.5;
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    return label;
}

#pragma mark - UITableView data source

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return _menuItems.count;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section withHeight:(CGFloat*)height
{
    if (section == 0)
    {
        NSArray* mainMenuItems = [_menuItems objectAtIndex:0];
        NSInteger totalNumberOfItems = 0;
        *height = 0;
        for (TXMenuItemObject *item in mainMenuItems)
        {
            ++totalNumberOfItems;
            *height = *height + 44.0f;
            if ([item isExpanded])
            {
                totalNumberOfItems += [item.subItems count];
                *height = *height + [item.subItems count] * 36.0f;
            }
        }
        return totalNumberOfItems;
    }
    else
    {
        *height = [[_menuItems objectAtIndex:(NSUInteger) section] count] * 44.0f;
        return [[_menuItems objectAtIndex:(NSUInteger) section] count];
    }
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    CGFloat height = 0;
    return [self numberOfRowsInSection:section withHeight:&height];
}

- (TXMenuItemObject *)menuItemForIndexPath:(NSIndexPath *)indexPath parentMenuItem:(TXMenuItemObject**)parentMenuItem
{
    if (indexPath.section == 1)
        return [[self.menuItems objectAtIndex:1] objectAtIndex:(NSUInteger) indexPath.row];
    NSArray *mainMenuItems = [self.menuItems objectAtIndex:0];
    int globalIndex = 0;
    for (TXMenuItemObject *topLevelMenuItem in mainMenuItems)
    {
        if (globalIndex == indexPath.row)
            return topLevelMenuItem;
        ++globalIndex;
        if (topLevelMenuItem.isExpanded)
        {
            for (TXMenuItemObject *childMenuItem in topLevelMenuItem.subItems)
            {
                if (globalIndex == indexPath.row)
                {
                    if (parentMenuItem)
                        *parentMenuItem = topLevelMenuItem;
                    return childMenuItem;
                }
                ++globalIndex;
            }
        }
    }
    return nil;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TXMenuItemObject *menuItem = [self menuItemForIndexPath:indexPath parentMenuItem:nil];

    TXMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:
                    (menuItem.level == 0?[TXMenuCell reuseIdentifier]:[TXSimpleSubMenuCell reuseIdentifier])];

    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:0 green:126.0/255 blue:213.0/255 alpha:1.0];
    bgColorView.layer.masksToBounds = YES;
    cell.selectedBackgroundView = bgColorView;

    cell.delegate = self;
    cell.clipsToBounds = YES;
    
    [cell configureWithMenuItem:menuItem];
    return cell;
}

#pragma mark - UITableView delegate

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0,tableView.frame.size.width,0)];
    view.backgroundColor = [UIColor clearColor];
    view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        CGFloat totalHeight;

        CGFloat heightTop = 0;
        CGFloat heightBottom = 0;

        [self numberOfRowsInSection:0 withHeight:&heightTop];

        totalHeight = CGRectGetHeight(tableView.frame) - (heightBottom + heightTop);

        if (totalHeight < 20)
            totalHeight = 20;

        return totalHeight;
    }

    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TXMenuItemObject *item = [self menuItemForIndexPath:indexPath parentMenuItem:nil];
    return (item.level == 0)?44.0f:36.0f;
}

- (void)deselectMenuRow:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TXMenuCell *cell = (TXMenuCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO];
}

-(void)collapseStack{
    if (self.stackedViewController.viewControllers.count > 1) {
        [self.stackedViewController popToViewController:self.stackedViewController.firstViewController animated:YES];
        [self.stackedViewController setUserInteractionEnabled:YES exceptController:nil];
    }
}

// Here we should simulate standard tab bar behaviour
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TXMenuItemObject *parentItem = nil;
    TXMenuItemObject *item = [self menuItemForIndexPath:indexPath parentMenuItem:&parentItem];

    if ([item.subItems count])
    {
        /* We're in parent menu and have to expand/collapse only */
        for (TXMenuItemObject *mItem in [self.menuItems objectAtIndex:0])
        {
            if (mItem != item && mItem.isExpanded)
                mItem.isExpanded = NO;
        }
        item.isExpanded = !item.isExpanded;
        self.selectedIndexPath = nil;
        [tableView reloadData];
        return;
    }

    if (self.selectedIndexPath && [self.selectedIndexPath compare:indexPath] == NSOrderedSame)
    {
        //check whether current navigation stack contains more than 1 controller
        if ([self canCollapseStack])
            [self collapseStack];
    }

    // check if we can perform transition
    if ([self canPerformMenuTransition:indexPath menuItem:item])
        [self performMenuTransition:tableView indexPath:indexPath menuItem:item];
    else
        [self deselectMenuRow:tableView indexPath:indexPath];
    

    BOOL needsReload = NO;
    for (TXMenuItemObject *mItem in [self.menuItems objectAtIndex:0])
    {
        TXMenuItemObject *checkItem = parentItem ?: item;
        if (mItem != checkItem && mItem.isExpanded)
        {
            needsReload = YES;
            mItem.isExpanded = NO;
        }
    }
    if (needsReload)
        [tableView reloadData];
}

#pragma mark - Navigation helpers

-(BOOL)canCollapseStack{
    BOOL canCollapseStack = YES;
    return canCollapseStack;
}

- (BOOL)canPerformMenuTransition:(NSIndexPath *)indexPath menuItem:(id)menuItem
{
    BOOL canPerformTransition = YES;
    return canPerformTransition;
}

- (void)configureViewController:(UIViewController *)controller atIndexPath:(NSIndexPath *)path
{
    if ([controller isKindOfClass:[TXBaseViewController class]])
    {
        TXBaseViewController *baseViewController = (TXBaseViewController *) controller;
        baseViewController.appearanceDelegate = self;
    }
}

- (void)performMenuTransition:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath menuItem:(TXMenuItemObject *)menuItem
{
    @autoreleasepool {
    //    id controllerClass = [[self menuItemForIndexPath:indexPath parentMenuItem:nil] controllerClass];
    //    if (controllerClass && ![controllerClass isKindOfClass:[NSNull class]])
        if (menuItem) {
            self.selectedIndexPath = indexPath;

                [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
                BOOL showProgressHUD = NO;
                if (showProgressHUD)
                    [SVProgressHUD showWithStatus:@"Please wait..." maskType:SVProgressHUDMaskTypeBlack];
                else if ([SVProgressHUD isVisible])
                    [SVProgressHUD dismiss];
                SimpleBlock transitionBlock = ^{
                    UIViewController *controllerToPush;
                    controllerToPush = [self getViewControllerForMenuItem:menuItem];
                    [controllerToPush prepareForAppearance:self.stackedViewController];
                    [self configureViewController:controllerToPush atIndexPath:indexPath];
                    [self.stackedViewController popToRootViewControllerAnimated:NO];
                    [self.stackedViewController pushViewController:controllerToPush animated:NO];
                    if ([SVProgressHUD isVisible])
                        [SVProgressHUD dismiss];
                };
                [[NSOperationQueue mainQueue] performSelector:@selector(addOperationWithBlock:)
                                                   withObject:transitionBlock
                                                   afterDelay:0];
        }
        else
            [TXAlertView showInProgressAlert:self.stackedViewController];
    }
}

- (UIViewController *)getViewControllerForMenuItem:(TXMenuItemObject *)menuItem
{
    return nil;
}

#pragma mark - Navigation routines

- (void)navigationBackPushed
{
    [self.stackedViewController popViewControllerAnimated:YES];
}

- (void)navigateToHomeViewController
{
    NSIndexPath *settingsIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.menuTableView selectRowAtIndexPath:settingsIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    [self tableView:self.menuTableView didSelectRowAtIndexPath:settingsIndexPath];
}

- (void)navigationBackForFirstViewControllerPushed
{
    [_backButtonForFirstController removeFromSuperview];
    [self.stackedViewController popViewControllerAnimated:YES];
}

- (void)pushBackButtonItemForController:(UIViewController *)viewController
{
    if (!_backButtonItem)
    {
        NSString *backTitle =  viewController.title;
        if (backTitle.length > kMaxBackButtonLength)
        {
            backTitle = [backTitle substringToIndex:kMaxBackButtonLength];
            backTitle = [backTitle stringByAppendingString:@"..."];
        }
        UIFont * font = [UIFont fontWithName:@"ArialMT" size:14.0f];
        CGSize textSize = [backTitle sizeWithFont:font];
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, textSize.width + 30, 30)];
        UIImage *backgroundImage = [[UIImage imageNamed:((floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)?@"nav-btn-back_ios7.png":@"nav-btn-back.png")] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 5)];
        [button setBackgroundImage:backgroundImage forState:UIControlStateNormal];
        [button setTitle:backTitle forState:UIControlStateNormal];
        button.titleLabel.font = font;
        if(floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
            [button setTitleColor:_topToolbar.tintColor forState:UIControlStateNormal];
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        [button addTarget:self action:@selector(navigationBackPushed) forControlEvents:UIControlEventTouchUpInside];
        _backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        [self.topToolbar pushLeftItem:_backButtonItem animated:YES];
        button.accessibilityLabel = @"Back Button";
    }
}

- (void)pushBackButtonItemForFirstControllerInTheStack:(UIViewController *)viewController
{
    if (!_backButtonItem)
    {
        NSString *backTitle =  viewController.title;
        if (backTitle.length > kMaxBackButtonLength)
        {
            backTitle = [backTitle substringToIndex:kMaxBackButtonLength];
            backTitle = [backTitle stringByAppendingString:@"..."];
        }

        UIFont * font = [UIFont fontWithName:@"ArialMT" size:14.0f];
        CGSize textSize = [backTitle sizeWithFont:font];
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, textSize.width + 30, 30)];
        UIImage *backgroundImage = [[UIImage imageNamed:((floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)?@"nav-btn-back_ios7.png":@"nav-btn-back.png")] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 5)];
        [button setBackgroundImage:backgroundImage forState:UIControlStateNormal];
        [button setTitle:backTitle forState:UIControlStateNormal];
        button.titleLabel.font = font;

        if(floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
            [button setTitleColor:_topToolbar.tintColor forState:UIControlStateNormal];

        button.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        CGRect frame = button.frame;
        frame.origin.x = 10;
        frame.origin.y = 7;
        button.frame = frame;
        _backButtonForFirstController = button;
        [_backButtonForFirstController addTarget:self action:@selector(navigationBackForFirstViewControllerPushed) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_backButtonForFirstController];
    }
}

- (void)popBackButtonItem
{
    if (_backButtonItem)
    {
        [self.topToolbar popLeftItemAnimated:NO];
        _backButtonItem = nil;
    }
    if (_backButtonForFirstController)
        [_backButtonForFirstController removeFromSuperview];
}

#pragma mark - Stacked view delegate

- (CGFloat)maximalItemHeightForStackedView:(TXStackedViewController *)stackedViewController
{
    return CGRectGetHeight(self.view.frame) - CGRectGetHeight(self.topToolbar.frame);
}

- (CGFloat)topItemOffsetForStackedView:(TXStackedViewController *)stackedViewController
{
    return CGRectGetHeight(self.topToolbar.frame);
}

- (void)stackedViewDidAlign:(TXStackedViewController *)stackedView
{
    //DLogV(@"StackDelegate did align: %@, topViewController: %@, container view: %@",
    //stackedView,  stackedView.topViewController, [stackedView.topViewController containerView]);
}

- (void)stackedView:(TXStackedViewController *)stackedView didPanViewController:(UIViewController *)viewController byOffset:(NSInteger)offset
{
}

- (void)stackedViewController:(TXStackedViewController *)stackedViewController willShowViewController:(UIViewController *)viewController
{
    UIViewController *topViewController = self.stackedViewController.topViewController;
    [self unregisterKVOForViewController:topViewController];
    if (viewController != self)
    {
        NSUInteger stackWidth = self.stackedViewController.viewControllers.count;
        BOOL isPushingVC = viewController && [self.stackedViewController.viewControllers indexOfObject:viewController] == NSNotFound;
        if (stackWidth > 0)
            [self popBackButtonItem];
        [self.topToolbar popItemsFromIndex:3 animated:NO];
        NSInteger expectedStackWidth = isPushingVC ? stackWidth + 1 : stackWidth - 1;
        if (expectedStackWidth >= kVisibleStackWidth)
            [self pushBackButtonItemForController:isPushingVC?topViewController:[self.stackedViewController previousViewController:viewController]];
    }
    else
        [self popBackButtonItem];
}

- (void)stackedViewController:(TXStackedViewController *)stackedViewController didShowViewController:(UIViewController *)viewController
{
    [self registerKVOForViewController:viewController];
    if (viewController != self)
    {
        self.titleLabel.text = viewController.title;
        [self.topToolbar appendItems:viewController.navigationItem.rightBarButtonItems animated:NO];
    }
}


#pragma mark - Key-value observing

- (void)registerKVOForViewController:(UIViewController *)viewController
{
    BOOL isKVORegistered = [_observedControllerItems containsObject:viewController.navigationItem];
    if (!isKVORegistered)
    {
        [viewController.navigationItem addObserver:self
                                        forKeyPath:kRightBarButtonItemsKeyPath
                                           options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
                                           context:nil];
        [_observedControllerItems addObject:viewController.navigationItem];
    }
}

- (void)unregisterKVOForViewController:(UIViewController *)viewController
{
    BOOL isKVORegistered = [_observedControllerItems containsObject:viewController.navigationItem];
    if (isKVORegistered)
    {
        [viewController.navigationItem removeObserver:self forKeyPath:kRightBarButtonItemsKeyPath];
        [_observedControllerItems removeObject:viewController.navigationItem];
    }
    if ([_observedControllerItems count] > 0)
    {
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:kRightBarButtonItemsKeyPath] && [object isKindOfClass:[UINavigationItem class]])
    {
        NSArray *oldItems = [change objectForKey:NSKeyValueChangeOldKey];
        NSArray *newItems = [change objectForKey:NSKeyValueChangeNewKey];
        [self.topToolbar replaceItems:oldItems withItems:newItems animated:NO];
    }
}

#pragma mark - Other helpers

- (void)menuCell:(TXMenuCell*)menuCell menuItemExpandingChanged:(TXMenuItemObject*)itemObject
{
    for (TXMenuItemObject *item in [self.menuItems objectAtIndex:0])
    {
        if (item != itemObject && item.isExpanded)
            item.isExpanded = NO;
    }
    self.selectedIndexPath = nil;
    [self.menuTableView reloadData];
}


@end
