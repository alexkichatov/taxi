
#import "TXBaseViewController.h"
#import "TXStackedViewController.h"
//#import "TXSectionedContainerViewController.h"
#import "TXRootViewController.h"


@implementation TXBaseViewController
{
    __weak id <TXAppearanceDelegate> _appearanceDelegate;
}
@synthesize appearanceDelegate = _appearanceDelegate;
@synthesize allowsSyncAfterPopping;

#pragma mark - Initialization and memory management

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
    {
        self.allowsSyncAfterPopping = YES;
    }
    return self;
}

#pragma mark - View lifecycle

- (void)prepareForAppearance:(TXStackedViewController *)stackViewController
{
    self.appearanceDelegate = (TXRootViewController *)stackViewController.rootViewController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (_appearanceDelegate &&  [_appearanceDelegate respondsToSelector:@selector(controllerDidLoad:)])
        [_appearanceDelegate controllerDidLoad:self];

    self.view.accessibilityLabel = self.title;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_appearanceDelegate &&  [_appearanceDelegate respondsToSelector:@selector(controllerWillAppear:)])
        [_appearanceDelegate controllerWillAppear:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    if (self.includeInStats)
//        [TXAnalyticsGather addScreenAccessMetric:self];
    if (_appearanceDelegate &&  [_appearanceDelegate respondsToSelector:@selector(controllerDidAppear:)])
        [_appearanceDelegate controllerDidAppear:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (_appearanceDelegate && [_appearanceDelegate respondsToSelector:@selector(controllerWillDisappear:)])
        [_appearanceDelegate controllerWillDisappear:self];
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    if (_appearanceDelegate && [_appearanceDelegate respondsToSelector:@selector(controllerDidDisappear:)])
        [_appearanceDelegate controllerDidDisappear:self];
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
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


- (NSString *)controllerStatID
{
    return NSStringFromClass([self class]);
}

- (BOOL)includeInStats
{
    return YES;
}

#pragma mark - Controller push/pop methods



//

- (void)checkIfControllerIsNotFullyOnScreen
{
}

@end