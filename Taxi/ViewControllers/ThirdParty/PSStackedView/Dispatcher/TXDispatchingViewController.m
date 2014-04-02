#import "TXDispatchingViewController.h"
#import "TXRootViewController.h"
#import "TXStackedViewController.h"
#import "UIViewController+BaseNavigation.h"
#import "TXAlertView.h"
#import "UIViewController+PSStackedView.h"

@interface TXDispatchingViewController()
@property (nonatomic, strong) TXStackedViewController *stackViewController;
@end

@implementation TXDispatchingViewController

#pragma mark - Initialization and memory management

- (id)init
{
    self = [super init];
    if (self) {
        [self configure];
    }
    return self;
}

- (void)awakeFromNib
{
    [self configure];
    self.stackViewController = [[TXStackedViewController alloc] initWithRootViewController:self.rootMenuController];
    self.stackViewController.delegate = self.rootMenuController;
    self.stackViewController.leftInset = 200;
}

//override to set rootviewcontroller as the menu list
- (void)configure {
}

#pragma mark - View lifecycle

-(CGRect)rectForPushController{
    CGRect vFrame = self.view.bounds;

    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1){
        vFrame.origin.y = 0;
        vFrame.size.height -= vFrame.origin.y;
    }

    return vFrame;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.view.autoresizesSubviews = YES;
    self.view.backgroundColor = [UIColor blackColor];
    [self addChildViewController:self.stackViewController];
    
    UIView *ctlView =  self.stackViewController.view;
    ctlView.autoresizingMask = self.view.autoresizingMask;
    ctlView.frame = [self rectForPushController];
    [self.view addSubview:ctlView];
    [self.stackViewController didMoveToParentViewController:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

@end