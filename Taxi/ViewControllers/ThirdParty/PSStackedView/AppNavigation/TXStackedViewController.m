//
//  TXStackRootController.m
//  TXStackedView
//
#import <CoreGraphics/CoreGraphics.h>

static NSString *const kPSSVAssociatedBaseViewControllerKey = @"kPSSVAssociatedBaseViewController";
static CGFloat const EPSILON = .001f; // float calculations
// reduces alpha over overlapped view controllers. 1.f would totally black-out on complete overlay
static CGFloat const kAlphaReductRatio = 10.f;

#import "TXStackedView.h"
#import "UIView+Hierarchy.h"
#import <objc/runtime.h>

#define kPSSVStackAnimationSpeedModifier 1.f // DEBUG!
#define kPSSVStackAnimationDuration kPSSVStackAnimationSpeedModifier * 0.25f
#define kPSSVStackAnimationBounceDuration kPSSVStackAnimationSpeedModifier * 0.20f
#define kPSSVStackAnimationPushDuration kPSSVStackAnimationSpeedModifier * 0.25f
#define kPSSVStackAnimationPopDuration kPSSVStackAnimationSpeedModifier * 0.25f
#define kPSSVMaxSnapOverOffset 20


// prevents me getting crazy
typedef void(^PSSVSimpleBlock)(void);

@interface TXStackedViewController () <UIGestureRecognizerDelegate>
{
    NSMutableArray *_viewControllers;
    // internal drag state handling and other messy details
    PSSVSnapOption _lastDragOption;
    BOOL snapBackFromLeft_;
    NSInteger lastDragOffset_;
    BOOL lastDragDividedOne_;
    BOOL enableBounces_;
    struct
    {
        unsigned int delegateWillShowViewController:1;
        unsigned int delegateDidShowViewController:1;
        unsigned int delegateDidPanViewController:1;
        unsigned int delegateDidAlign:1;
        unsigned int delegateMaximalItemWidth:1;
        unsigned int delegateMaximalItemHeight:1;
        unsigned int delegateTopItemOffset:1;
    } _delegateFlags;
}
@property(nonatomic, strong) UIViewController *rootViewController;
@property(nonatomic, strong) NSArray *viewControllers;
@property(nonatomic, assign) NSInteger firstVisibleIndex;
@property(nonatomic, assign) CGFloat floatIndex;
- (UIViewController *)overlappedViewController;
- (TXContainerView *)wrappingViewForController:(UIViewController *)aViewController;
@end

#pragma mark - Main implementation

@implementation TXStackedViewController
@synthesize leftInset = leftInset_;
@synthesize largeLeftInset = largeLeftInset_;
@synthesize viewControllers = _viewControllers;
@synthesize floatIndex = _floatIndex;
@synthesize rootViewController = _rootViewController;
@synthesize panRecognizer = _panRecognizer;
@synthesize delegate = _delegate;
@synthesize reduceAnimations = reduceAnimations_;
@synthesize enableBounces = enableBounces_;
@synthesize enableShadows = enableShadows_;
@synthesize enableDraggingPastInsets = enableDraggingPastInsets_;
@synthesize enableScalingFadeInOut = enableScalingFadeInOut_;
@synthesize defaultShadowWidth = defaultShadowWidth_;
@synthesize defaultShadowAlpha  = defaultShadowAlpha_;
@synthesize cornerRadius = cornerRadius_;
@synthesize numberOfTouches = numberOfTouches_;
@dynamic firstVisibleIndex;

#pragma mark - UIView lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.rootViewController)
    {
        [self addChildViewController:self.rootViewController];
        [self.view addSubview:self.rootViewController.view];
        self.rootViewController.view.frame = self.view.bounds;
        self.rootViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.rootViewController didMoveToParentViewController:self];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // enlarge/shrink stack
    [self updateViewControllerSizes];
    [self updateViewControllerMasksAndShadow];
    [self alignStackAnimated:NO];
}

- (void)viewDidUnload
{
    [self.rootViewController.view removeFromSuperview];
    self.rootViewController.view = nil;
    [super viewDidUnload];
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

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if (self.isReducingAnimations)
    {
        [self updateViewControllerSizes];
        [self updateViewControllerMasksAndShadow];
    }
    // ensure we're correctly aligned (may be messed up in willAnimate, if panRecognizer is still active)
    [self alignStackAnimated:!self.isReducingAnimations];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (!self.isReducingAnimations)
    {
        [self updateViewControllerSizes];
        [self updateViewControllerMasksAndShadow];
    }
    // enlarge/shrink stack
    [self alignStackAnimated:!self.isReducingAnimations];
}

#pragma mark - Initialization and memory management

- (void)configureGestureRecognizer
{
    [self.view removeGestureRecognizer:self.panRecognizer];
    // add a gesture recognizer to detect dragging to the guest controllers
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanFrom:)];
    if (numberOfTouches_ > 0)
        [panRecognizer setMinimumNumberOfTouches:numberOfTouches_];
    else
        [panRecognizer setMaximumNumberOfTouches:1];            
    [panRecognizer setDelaysTouchesBegan:NO];
    [panRecognizer setDelaysTouchesEnded:YES];
    [panRecognizer setCancelsTouchesInView:YES];
    panRecognizer.delegate = self;
    [self.view addGestureRecognizer:panRecognizer];
    self.panRecognizer = panRecognizer;
}

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    if ((self = [super init]))
    {
        _rootViewController = rootViewController;
        objc_setAssociatedObject(rootViewController, (__bridge void *const)kPSSVAssociatedStackViewControllerKey, self, OBJC_ASSOCIATION_ASSIGN); // associate weak
        _viewControllers = [[NSMutableArray alloc] init];
        
        // set some reasonable defaults
        leftInset_ = 60;
        largeLeftInset_ = 200;
        [self configureGestureRecognizer];

        enableBounces_ = YES;
        enableShadows_ = YES;
        enableDraggingPastInsets_ = YES;
        enableScalingFadeInOut_ = YES;
        defaultShadowWidth_ = 60.0f;
        defaultShadowAlpha_ = 0.2f;
        cornerRadius_ = 6.0f;
    }
    return self;
}

- (void)dealloc
{
    _panRecognizer.delegate = nil;
    // remove all view controllers the hard way (w/o calling delegate)
    while ([self.viewControllers count])
    {
        [self popViewControllerAnimated:NO invokeDelegate:NO];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Delegate

- (void)setDelegate:(id<TXStackedViewDelegate>)delegate
{
    if (delegate != _delegate)
    {
        _delegate = delegate;
        _delegateFlags.delegateWillShowViewController = (unsigned int) [delegate respondsToSelector:@selector(stackedViewController:willShowViewController:)];
        _delegateFlags.delegateDidShowViewController = (unsigned int) [delegate respondsToSelector:@selector(stackedViewController:didShowViewController:)];
        _delegateFlags.delegateDidPanViewController = (unsigned int) [delegate respondsToSelector:@selector(stackedView:didPanViewController:byOffset:)];
        _delegateFlags.delegateDidAlign = (unsigned int) [delegate respondsToSelector:@selector(stackedViewDidAlign:)];
        _delegateFlags.delegateMaximalItemHeight = (unsigned int) [delegate respondsToSelector:@selector(maximalItemHeightForStackedView:)];
        _delegateFlags.delegateMaximalItemWidth = (unsigned int) [delegate respondsToSelector:@selector(maximalItemWidthForStackedView:)];
        _delegateFlags.delegateTopItemOffset = (unsigned int) [delegate respondsToSelector:@selector(topItemOffsetForStackedView:)];
    }
}


- (void)delegateWillShowViewController:(UIViewController *)viewController
{
    [[NSNotificationCenter defaultCenter] postNotificationName:TXWillShowViewControllerNotification object:viewController];
    if (_delegateFlags.delegateWillShowViewController)
        [self.delegate stackedViewController:self willShowViewController:viewController];
}

- (void)delegateDidShowViewController:(UIViewController *)viewController
{
    [[NSNotificationCenter defaultCenter] postNotificationName:TXDidShowViewControllerNotification object:viewController];
    if (_delegateFlags.delegateDidShowViewController)
        [self.delegate stackedViewController:self didShowViewController:viewController];
}

- (void)delegateDidPanViewController:(UIViewController *)viewController byOffset:(NSInteger)offset
{
    if (_delegateFlags.delegateDidPanViewController)
        [self.delegate stackedView:self didPanViewController:viewController byOffset:offset];
}

- (void)delegateDidAlign
{
    if (_delegateFlags.delegateDidAlign)
        [self.delegate stackedViewDidAlign:self];
}

- (CGFloat) maximalItemHeight
{
    if (_delegateFlags.delegateMaximalItemHeight)
        return [self.delegate maximalItemHeightForStackedView:self];
    return [self screenHeight];
}

- (CGFloat) maximalItemWidth
{
    if (_delegateFlags.delegateMaximalItemWidth)
        return [self.delegate maximalItemWidthForStackedView:self];
    return [self maxControllerWidth];
}

- (CGFloat) topItemOffset
{
    if (_delegateFlags.delegateTopItemOffset)
        return [self.delegate topItemOffsetForStackedView:self];
    return .0f;
}

#pragma mark - Private Helpers

- (NSInteger)firstVisibleIndex
{
    return (NSInteger) floorf(self.floatIndex);
}

- (CGRect)viewRect
{
    return [[UIScreen mainScreen] applicationFrame];
}

// return screen width
- (CGFloat)screenWidth
{
    CGRect viewRect = [self viewRect];
    CGFloat screenWidth = PSIsLandscape() ? viewRect.size.height : viewRect.size.width;
    return screenWidth;
}

- (CGFloat)screenHeight
{
    CGRect viewRect = [self viewRect];
    CGFloat screenHeight = PSIsLandscape() ? viewRect.size.width : viewRect.size.height;
    return screenHeight;
}

- (CGFloat)maxControllerWidth
{
    CGFloat maxWidth = [self screenWidth] - self.leftInset;
    return maxWidth;
}

// total stack width if completely expanded
- (NSUInteger)totalStackWidth
{
    NSUInteger totalStackWidth = 0;
    for (UIViewController *controller in self.viewControllers)
    {
        totalStackWidth += controller.containerView.width;
    }
    return totalStackWidth;
}

// menu is only collapsable if stack is large enough
- (BOOL)isMenuCollapsable
{
    BOOL isMenuCollapsable = [self totalStackWidth] + self.largeLeftInset > [self screenWidth];
    return isMenuCollapsable;
}

// return current left border (how it *should* be)
- (NSUInteger)currentLeftInset
{
    return self.floatIndex >= 0.5 ? self.leftInset : self.largeLeftInset;
}

// minimal left border is depending on amount of VCs
- (NSUInteger)minimalLeftInset
{
    return [self isMenuCollapsable] ? self.leftInset : self.largeLeftInset;
}

// check if a view controller is visible or not
- (BOOL)isViewControllerVisible:(UIViewController *)viewController completely:(BOOL)completely
{
    NSParameterAssert(viewController);
    CGFloat screenWidth = [self screenWidth];
    BOOL isVCVisible = ((viewController.containerView.left < screenWidth && !completely) ||
                        (completely && viewController.containerView.right <= screenWidth));
    return isVCVisible;
}

// returns view controller that is displayed before viewController 
- (UIViewController *)previousViewController:(UIViewController *)viewController
{
    if(!viewController) // don't assert on mere menu events
        return nil;
    NSUInteger vcIndex = [self indexOfViewController:viewController];
    UIViewController *prevVC = nil;
    if (vcIndex > 0)
        prevVC = [self.viewControllers objectAtIndex:vcIndex-1];
    return prevVC;
}

// returns view controller that is displayed after viewController 
- (UIViewController *)nextViewController:(UIViewController *)viewController
{
    NSParameterAssert(viewController);
    NSUInteger vcIndex = [self indexOfViewController:viewController];
    UIViewController *nextVC = nil;
    if (vcIndex + 1 < [self.viewControllers count])
        nextVC = [self.viewControllers objectAtIndex:vcIndex+1];
    return nextVC;
}

// returns last visible view controller. this *can* be the last view controller in the stack, 
// but also one of the previous ones if the user navigates back in the stack
- (UIViewController *)lastVisibleViewControllerCompletelyVisible:(BOOL)completely
{
    __block UIViewController *lastVisibleViewController = nil;
    [self.viewControllers enumerateObjectsWithOptions:NSEnumerationReverse
                                           usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                               UIViewController *currentViewController = (UIViewController *)obj;
                                               if ([self isViewControllerVisible:currentViewController completely:completely])
                                               {
                                                   lastVisibleViewController = currentViewController;
                                                   *stop = YES;
                                               }
                                           }];
    return lastVisibleViewController;
}

// returns true if firstVisibleIndex is the last available index.
- (BOOL)isLastIndex
{
    return self.firstVisibleIndex == [self.viewControllers count] - 1;
}

#pragma mark - Numbers rounding options and functions

enum
{
    PSSVRoundNearest,
    PSSVRoundUp,
    PSSVRoundDown,
    PSSVRoundAvoidHalf,
}typedef PSSVRoundOption;

- (BOOL)isFloatIndexBetween:(CGFloat)floatIndex
{
    CGFloat intIndex, restIndex;
    restIndex = modff(floatIndex, &intIndex);
    BOOL isBetween = fabsf(restIndex - 0.5f) < EPSILON;
    return isBetween;
}

// check if index is valid. Valid indexes are >= 0.0 and only full or .5 parts are allowed.
// there are lots of other, more complex rules, so calculate!
- (BOOL)isValidFloatIndex:(CGFloat)floatIndex
{
    BOOL isValid = floatIndex == 0.f; // 0.f is always allowed
    if (!isValid)
    {
        CGFloat contentWidth = [self totalStackWidth];
        if (floatIndex == 0.5f)
        {
            // docking to menu is only allowed if content > available size.
            isValid = contentWidth > [self screenWidth] - self.largeLeftInset;
        }
        else
        {
            NSUInteger stackCount = [self.viewControllers count];
            CGFloat intIndex, restIndex;
            restIndex = modff(floatIndex, &intIndex); // split e.g. 1.5 in 1.0 and 0.5
            isValid = stackCount > intIndex && contentWidth > ([self screenWidth] - self.leftInset);
            if (isValid && fabsf(restIndex - 0.5f) < EPSILON)
            {
                // comparing floats -> if so, we have a .5 here
                if (ceilf(floatIndex) < stackCount)
                {
                    // at the end?
                    CGFloat widthLeft = [[self.viewControllers objectAtIndex:(NSUInteger) floorf(floatIndex)] containerView].width;
                    CGFloat widthRight = [[self.viewControllers objectAtIndex:(NSUInteger) ceilf(floatIndex)] containerView].width;
                    isValid = (widthLeft + widthRight) > ([self screenWidth] - self.leftInset);
                }
                else
                    isValid = NO;
            }
        }
    }
    return isValid;
}

- (CGFloat)nearestValidFloatIndex:(CGFloat)floatIndex round:(PSSVRoundOption)roundOption
{
    CGFloat roundedFloat;
    CGFloat intIndex, restIndex;
    restIndex = modff(floatIndex, &intIndex);
    if (intIndex ==0 && roundOption == PSSVRoundAvoidHalf)
        roundOption = PSSVRoundNearest;

    if (restIndex < 0.5f)
    {
        if (roundOption == PSSVRoundAvoidHalf)
            restIndex = 0.0f;
        else if (roundOption == PSSVRoundNearest)
            restIndex = (restIndex < 0.25f) ? 0.f : 0.5f;
        else
            restIndex = (roundOption == PSSVRoundUp) ? 0.5f : 0.f;
    }
    else
    {
        if (roundOption == PSSVRoundAvoidHalf)
            restIndex = (restIndex < 0.75f) ? 0.f : 1.f;
        else if (roundOption == PSSVRoundNearest)
            restIndex = (restIndex < 0.75f) ? 0.5f : 1.f;
        else
            restIndex = (roundOption == PSSVRoundUp) ? 1.f : 0.5f;
    }
    roundedFloat = intIndex + restIndex;
    
    // now check if this is valid
    BOOL isValid = [self isValidFloatIndex:roundedFloat];
    
    // if not valid, and custom rounding produced a .5, test again with full rounding
    if (!isValid && restIndex == 0.5f)
    {
        CGFloat naturalRoundedIndex;
        if (roundOption == PSSVRoundNearest)
            naturalRoundedIndex = roundf(floatIndex);
        else if(roundOption == PSSVRoundUp)
            naturalRoundedIndex = ceilf(floatIndex);
        else
            naturalRoundedIndex = floorf(floatIndex);
        // if that works out, return it!
        if ([self isValidFloatIndex:naturalRoundedIndex])
        {
            isValid = YES;
            roundedFloat = naturalRoundedIndex;
        }
    }
    
    // still not valid? start the for loops, find nearest valid index
    if (!isValid)
    {
        CGFloat validLowIndex = 0.f, validHighIndex = 0.f;
        // upper bound
        CGFloat viewControllerCount = [self.viewControllers count];
        for (CGFloat tester = roundedFloat + 0.5f; tester < viewControllerCount;  tester += 0.5f)
        {
            if ([self isValidFloatIndex:tester])
            {
                validHighIndex = tester;
                break;
            }
        }
        // lower bound
        for (CGFloat tester = roundedFloat - 0.5f; tester >= 0.f;  tester -= 0.5f)
        {
            if ([self isValidFloatIndex:tester])
            {
                validLowIndex = tester;
                break;
            }
        }
        
        if (fabsf(validLowIndex - roundedFloat) < fabsf(validHighIndex - roundedFloat))
            roundedFloat = validLowIndex;
        else
            roundedFloat = validHighIndex;
    }
    
    return roundedFloat;
}

- (CGFloat)nearestValidFloatIndex:(CGFloat)floatIndex
{
    return [self nearestValidFloatIndex:floatIndex round:PSSVRoundNearest];
}

- (CGFloat)nextFloatIndex:(CGFloat)floatIndex
{
    CGFloat nextFloat = floatIndex;
    CGFloat roundedFloat = [self nearestValidFloatIndex:floatIndex];
    CGFloat viewControllerCount = [self.viewControllers count];
    for (CGFloat tester = roundedFloat + 0.5f; tester < viewControllerCount;  tester += 0.5f)
    {
        if ([self isValidFloatIndex:tester])
        {
            nextFloat = tester;
            break;
        }
    }
    return nextFloat;
}

- (CGFloat)prevFloatIndex:(CGFloat)floatIndex
{
    CGFloat prevFloat = floatIndex;
    CGFloat roundedFloat = [self nearestValidFloatIndex:floatIndex];
    for (CGFloat tester = roundedFloat - 0.5f; tester >= 0.f;  tester -= 0.5f)
    {
        if ([self isValidFloatIndex:tester])
        {
            prevFloat = tester;
            break;
        }
    }
    return prevFloat;
}

- (void)popInvisibleViewControllers
{
    UIViewController *lastVisibleVC = [self lastVisibleViewControllerCompletelyVisible:NO];
    NSUInteger lvcIndex = [self indexOfViewController:lastVisibleVC];
    if (lvcIndex + 1 < _viewControllers.count)
    {
        [self delegateWillShowViewController:lastVisibleVC];
        while (lvcIndex + 1 < _viewControllers.count)
        {
            UIViewController *vc = [_viewControllers lastObject];
            [vc willMoveToParentViewController:nil];
            [vc.containerView removeFromSuperview];
            [vc removeFromParentViewController];
            [_viewControllers removeLastObject];
        }
        [self delegateDidShowViewController:lastVisibleVC];
    }
    [self checkStackEditMode];
}

/// calculates all rects for current visibleIndex orientation
- (NSArray *)rectsForControllers
{
    NSMutableArray *frames = [NSMutableArray array];
    // TODO: currently calculates *all* objects, should cache!
    CGFloat floatIndex = [self nearestValidFloatIndex:self.floatIndex];
    [self.viewControllers enumerateObjectsWithOptions:0
                                           usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                               UIViewController *currentVC = (UIViewController *)obj;
                                               CGFloat leftPos = [self currentLeftInset];
                                               CGRect leftRect = idx > 0 ? [[frames objectAtIndex:idx-1] CGRectValue] : CGRectZero;

                                               if (idx == floorf(floatIndex))
                                               {
                                                   BOOL dockRight = ![self isFloatIndexBetween:floatIndex] && floatIndex >= 1.f;
                                                   // should we pan it to the right?
                                                   if (dockRight)
                                                       leftPos = [self screenWidth] - currentVC.containerView.width;
                                               }
                                               else if (idx > floatIndex)
                                               {
                                                   // connect vc to left vc's right!
                                                   leftPos = leftRect.origin.x + leftRect.size.width;
                                               }
                                               CGRect currentRect = CGRectMake(leftPos, currentVC.containerView.top, currentVC.containerView.width, currentVC.containerView.height);
                                               [frames addObject:[NSValue valueWithCGRect:currentRect]];
                                           }];
    [self.viewControllers enumerateObjectsWithOptions:NSEnumerationReverse
                                           usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                               if(idx < floatIndex && idx < [self.viewControllers count] - 1)
                                               {
                                                   CGRect crect = [[frames objectAtIndex:idx] CGRectValue];
                                                   CGRect nrect = [[frames objectAtIndex:idx + 1] CGRectValue];
                                                   CGFloat lpos = nrect.origin.x - crect.size.width;
                                                   lpos = MAX(lpos, [self currentLeftInset]);
                                                   CGRect newrect = CGRectMake(lpos, crect.origin.y, crect.size.width, crect.size.height);
                                                   [frames replaceObjectAtIndex:idx withObject:[NSValue valueWithCGRect:newrect]];
                                               }
                                           }];

    return frames;
}

/// calculates the specific rect
- (CGRect)rectForControllerAtIndex:(NSUInteger)index
{
    NSArray *frames = [self rectsForControllers];
    return [[frames objectAtIndex:index] CGRectValue];
}

/// moves a rect around, recalculates following rects
- (NSArray *)modifiedRects:(NSArray *)frames newLeft:(CGFloat)newLeft index:(NSUInteger)index
{
    NSMutableArray *modifiedFrames = [NSMutableArray arrayWithArray:frames];
    CGRect prevFrame = CGRectZero;
    for (NSUInteger i = index; i < [modifiedFrames count]; i++)
    {
        CGRect vcFrame = [[modifiedFrames objectAtIndex:i] CGRectValue];
        if (i == index)
            vcFrame.origin.x = newLeft;
        else
            vcFrame.origin.x = prevFrame.origin.x + prevFrame.size.width;
        [modifiedFrames replaceObjectAtIndex:i withObject:[NSValue valueWithCGRect:vcFrame]];
        prevFrame = vcFrame;
    }

    return modifiedFrames;
}

// at some point, dragging does not make any more sense
- (BOOL)snapPointAvailableAfterOffset:(NSInteger)offset
{
    BOOL snapPointAvailableAfterOffset = YES;
    CGFloat screenWidth = [self screenWidth];
    CGFloat totalWidth = [self totalStackWidth];
    CGFloat minCommonWidth = MIN(screenWidth, totalWidth);

    // are we at the end?
    UIViewController *topViewController = [self topViewController];
    if (topViewController == [self lastVisibleViewControllerCompletelyVisible:YES])
    {
        if (minCommonWidth + [self minimalLeftInset] <= topViewController.containerView.right)
            snapPointAvailableAfterOffset = NO;
    }
    // slow down first controller when dragged to the right
    if ([self canCollapseStack] == 0)
        snapPointAvailableAfterOffset = NO;
    if ([self firstViewController].containerView.left > self.largeLeftInset)
        snapPointAvailableAfterOffset = NO;
    return snapPointAvailableAfterOffset;
}

- (BOOL)displayViewControllerOnRightMost:(UIViewController *)vc animated:(BOOL)animated
{
    NSUInteger index = [self indexOfViewController:vc];
    if (index != NSNotFound)
    {
        [self displayViewControllerIndexOnRightMost:index animated:animated];
        return YES;
    }
    return NO;
}

// ensures index is on rightmost position
- (void)displayViewControllerIndexOnRightMost:(NSInteger)index animated:(BOOL)animated
{
    // add epsilon to round indexes like 1.0 to 2.0, also -1.0 to -2.0
    CGFloat floatIndexOffset = index - self.floatIndex;
    NSInteger indexOffset = (NSInteger) ceilf(floatIndexOffset + (floatIndexOffset > 0 ? EPSILON : -EPSILON));
    if (indexOffset > 0)
        [self collapseStack:indexOffset animated:animated];
    else if(indexOffset < 0)
        [self expandStack:indexOffset animated:animated];
            // hide menu, if first VC is larger than available screen space with floatIndex = 0.0
    else if (index == 0 && [self.viewControllers count])
    {
        self.floatIndex = 0.5f;
        [self alignStackAnimated:YES];
    }
}

- (void)displayRootViewControllerAnimated:(BOOL)animated
{
    self.floatIndex = 0.0f;
    [self alignStackAnimated:animated];
}

// iterates controllers and sets width (also, enlarges if requested width is larger than current width)
- (void)updateViewControllerSizes
{
    CGFloat maxControllerView = [self maxControllerWidth];
    for (UIViewController *controller in self.viewControllers)
    {
        [controller.containerView limitToMaxWidth:maxControllerView];
    }
}

- (CGFloat)overlapRatio
{
    CGFloat overlapRatio = 0.f;
    UIViewController *overlappedVC = [self overlappedViewController];
    if (overlappedVC)
    {
        UIViewController *rightVC = [self nextViewController:overlappedVC];
        PSSVLog(@"overlapping %@ with %@", NSStringFromCGRect(overlappedVC.containerView.frame), NSStringFromCGRect(rightVC.containerView.frame));
        overlapRatio = fabsf(overlappedVC.containerView.right - rightVC.containerView.left)/overlappedVC.containerView.width;
    }
    return overlapRatio;
}

// updates view containers
- (void)updateViewControllerMasksAndShadow
{
    if (enableShadows_)
    {
        // only one!
        if ([self.viewControllers count] == 1)
            self.firstViewController.containerView.shadow = PSSVSideLeft | PSSVSideRight;
        else
        {
            // rounded corners on first and last controller
            [self.viewControllers enumerateObjectsUsingBlock:^(UIViewController *vc, NSUInteger idx, BOOL *stop) {
                if ([self firstVisibleIndex] <= idx + 2)
                {
                    if(idx == [self.viewControllers count]-1)
                        vc.containerView.shadow = PSSVSideLeft | PSSVSideRight;
                    else if (idx != 0)
                        vc.containerView.shadow = PSSVSideLeft | PSSVSideRight;
                }
            }];
        }
        // update alpha mask
        CGFloat overlapRatio = [self overlapRatio];
        UIViewController *overlappedVC = [self overlappedViewController];
        overlappedVC.containerView.darkRatio = MIN(overlapRatio, 1.f)/kAlphaReductRatio;
        // reset alpha ratio everywhere else
        for (UIViewController *vc in self.viewControllers)
        {
            if (vc != overlappedVC)
                vc.containerView.darkRatio = 0.0f;
        }
    }
}

- (NSArray *)visibleViewControllersSetFullyVisible:(BOOL)fullyVisible
{
    NSMutableArray *array = [NSMutableArray array];
    [self.viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([self isViewControllerVisible:obj completely:fullyVisible])
            [array addObject:obj];
    }];
    return [array copy];
}

// check if there is any overlapping going on between VCs
- (BOOL)isViewController:(UIViewController *)leftViewController overlappingWith:(UIViewController *)rightViewController
{
    NSParameterAssert(leftViewController);
    NSParameterAssert(rightViewController);
    // figure out which controller is the top one
    if ([self indexOfViewController:rightViewController] < [self indexOfViewController:leftViewController])
    {
        PSSVLog(@"overlapping check flipped! fixing that...");
        UIViewController *tmp = rightViewController;
        rightViewController = leftViewController;
        leftViewController = tmp;
    }
    BOOL overlapping = leftViewController.containerView.right > rightViewController.containerView.left;
    if (overlapping)
    {
        PSSVLog(@"overlap detected: %@ (%@) with %@ (%@)", leftViewController, NSStringFromCGRect(leftViewController.containerView.frame),
        rightViewController, NSStringFromCGRect(rightViewController.containerView.frame));
    }
    return overlapping;
}

// find the rightmost overlapping controller
- (UIViewController *)overlappedViewController
{
    __block UIViewController *overlappedViewController = nil;
    [self.viewControllers enumerateObjectsWithOptions:NSEnumerationReverse
                                           usingBlock:^(UIViewController *currentViewController, NSUInteger idx, BOOL *stop) {
                                               UIViewController *leftViewController = [self previousViewController:currentViewController];
                                               BOOL overlapping = NO;
                                               if (leftViewController && currentViewController)
                                                   overlapping = [self isViewController:leftViewController overlappingWith:currentViewController];
                                               if (overlapping)
                                               {
                                                   overlappedViewController = leftViewController;
                                                   *stop = YES;
                                               }
                                           }];
    return overlappedViewController;
}

- (TXContainerView *)wrappingViewForController:(UIViewController *)aViewController
{
    TXContainerView *container = [TXContainerView containerViewWithController:aViewController];
    NSUInteger leftGap = [self totalStackWidth] + [self minimalLeftInset];
    container.frame = CGRectMake(leftGap, self.topItemOffset, MIN(aViewController.view.bounds.size.width, self.maximalItemWidth), MIN(aViewController.view.bounds.size.height, self.maximalItemHeight));
    container.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    container.shadowWidth = defaultShadowWidth_;
    container.shadowAlpha = defaultShadowAlpha_;
    container.cornerRadius = cornerRadius_;
    [container limitToMaxWidth:[self maxControllerWidth]];
    return container;
}


#pragma mark - Touch Handling

- (void)stopStackAnimation
{
    // remove all current animations
    [self.viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIViewController *vc = (UIViewController *)obj;
        [vc.containerView.layer removeAllAnimations];
    }];
}

// moves the stack to a specific offset. 
- (void)moveStackWithOffset:(NSInteger)offset animated:(BOOL)animated userDragging:(BOOL)userDragging
{
    PSSVLog(@"moving stack on %d pixels (animated:%d, decellerating:%d)", offset, animated, userDragging);
    // let the delegate know the user is moving the stack
    if (self.delegate && userDragging)
        [self delegateDidPanViewController:self.topViewController byOffset:offset];
    [self stopStackAnimation];
    [UIView animateWithDuration:animated ? kPSSVStackAnimationDuration : 0.f
                          delay:0.f
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         // enumerate controllers from right to left
                         // scroll each controller until we begin to overlap!
                         __block BOOL isTopViewController = YES;
                         [self.viewControllers enumerateObjectsWithOptions:NSEnumerationReverse
                                                                usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                                                    *stop = !(idx + 2 > [self firstVisibleIndex]);
                                                                    UIViewController *currentViewController = (UIViewController *)obj;
                                                                    UIViewController *leftViewController = [self previousViewController:currentViewController];
                                                                    UIViewController *rightViewController = [self nextViewController:currentViewController];
                                                                    if (leftViewController)
                                                                    {
                                                                        UIView *container = !leftViewController.containerView
                                                                                ?[self wrappingViewForController:leftViewController]
                                                                                :leftViewController.containerView;
                                                                        if (container.superview != self.view)
                                                                            [self.view insertSubview:container belowSubview:currentViewController.containerView];
                                                                    }
                                                                    NSInteger minimalLeftInset = [self minimalLeftInset];

                                                                    // we just move the top view controller
                                                                    CGFloat currentVCLeftPosition = currentViewController.containerView.left;
                                                                    if (isTopViewController)
                                                                        currentVCLeftPosition += offset;
                                                                    else
                                                                    {
                                                                        // make sure we're connected to the next controller!
                                                                        currentVCLeftPosition = rightViewController.containerView.left - currentViewController.containerView.width;
                                                                    }

                                                                    // prevent scrolling < minimal width (except for the top view controller - allow stupidness!)
                                                                    if (currentVCLeftPosition < minimalLeftInset && (!userDragging || (userDragging && !isTopViewController)))
                                                                        currentVCLeftPosition = minimalLeftInset;

                                                                    // a previous view controller is not allowed to overlap the next view controller.
                                                                    if (leftViewController && leftViewController.containerView.right > currentVCLeftPosition)
                                                                    {
                                                                        CGFloat leftVCLeftPosition = currentVCLeftPosition - leftViewController.containerView.width;
                                                                        if (leftVCLeftPosition < minimalLeftInset)
                                                                            leftVCLeftPosition = minimalLeftInset;
                                                                        leftViewController.containerView.left = leftVCLeftPosition;
                                                                    }

                                                                    if (enableDraggingPastInsets_ == NO)
                                                                    {
                                                                        CGFloat stackWidth = (!isTopViewController) ? 0 :
                                                                                (leftViewController) ? leftViewController.view.frame.size.width :
                                                                                        (rightViewController) ? rightViewController.view.frame.size.width : 0;
                                                                        CGFloat padding  = 45;
                                                                        if (currentVCLeftPosition-stackWidth <= leftInset_)
                                                                            currentVCLeftPosition = leftInset_ + stackWidth;
                                                                        else if (currentVCLeftPosition-stackWidth >= largeLeftInset_ + padding)
                                                                        {
                                                                            //For a more natural
                                                                            currentVCLeftPosition = largeLeftInset_ + stackWidth + padding;
                                                                        }
                                                                    }
                                                                    currentViewController.containerView.left = currentVCLeftPosition;
                                                                    isTopViewController = NO; // there can only be one.
                                                                }];
                         [self updateViewControllerMasksAndShadow];

                         // special case, if we have overlapping controllers!
                         // in this case underlying controllers are visible, but they are overlapped by another controller
                         UIViewController *lastViewController = [self lastVisibleViewControllerCompletelyVisible:YES];
                         // there may be no controller completely visible - use partly visible then
                         if (!lastViewController)
                         {
                             NSArray *visibleViewControllers = self.visibleViewControllers;
                             lastViewController = [visibleViewControllers count] ? [visibleViewControllers objectAtIndex:0] : nil;
                         }
                         // calculate float index
                         NSUInteger newFirstVisibleIndex = lastViewController ? [self indexOfViewController:lastViewController] : 0;
                         CGFloat floatIndex = [self nearestValidFloatIndex:newFirstVisibleIndex]; // absolut value

                         CGFloat overlapRatio = 0.f;
                         UIViewController *overlappedVC = [self overlappedViewController];
                         if (overlappedVC)
                         {
                             UIViewController *rightVC = [self nextViewController:overlappedVC];
                             PSSVLog(@"overlapping %@ with %@", NSStringFromCGRect(overlappedVC.containerView.frame), NSStringFromCGRect(rightVC.containerView.frame));
                             overlapRatio = fabsf(overlappedVC.containerView.right - rightVC.containerView.left)/
                                     (overlappedVC.containerView.right - ([self screenWidth] - rightVC.containerView.width));
                         }
                         // only update ratio if < 1 (else we move sth else)
                         if (overlapRatio <= 1.f && overlapRatio > 0.f)
                             floatIndex += 0.5f + overlapRatio*0.5f; // fully overlapped = the .5 ratio!
                         else
                         {
                             // overlap ratio
                             UIViewController *lastVC = [self.visibleViewControllers lastObject];
                             UIViewController *prevVC = [self previousViewController:lastVC];
                             if (lastVC && prevVC && lastVC.containerView.right > [self screenWidth])
                             {
                                 overlapRatio = fabsf(([self screenWidth] - lastVC.containerView.left)/([self screenWidth] - (self.leftInset + prevVC.containerView.width)))*.5f;
                                 floatIndex += overlapRatio;
                             }
                         }
                         // special case for menu
                         if (floatIndex == 0.f)
                         {
                             CGFloat menuCollapsedRatio = (self.largeLeftInset - self.firstViewController.containerView.left)/(self.largeLeftInset - self.leftInset);
                             menuCollapsedRatio = MAX(0.0f, MIN(0.5f, menuCollapsedRatio/2));
                             floatIndex += menuCollapsedRatio;
                         }
                         _floatIndex = floatIndex;
                     }
            completion:nil];
}

- (void)handlePanFrom:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translatedPoint = [recognizer translationInView:self.view];
    UIGestureRecognizerState state = recognizer.state;

    // reset last offset if gesture just started
    if (state == UIGestureRecognizerStateBegan)
        lastDragOffset_ = 0;
    CGFloat offset = translatedPoint.x - lastDragOffset_;

    // if the move does not make sense (no snapping region), only use 1/2 offset
    BOOL snapPointAvailable = [self snapPointAvailableAfterOffset:(NSInteger) offset];
    if (!snapPointAvailable)
    {
        PSSVLog(@"offset dividing/2 in effect");
        // we only want to move full pixels - but if we drag slowly, 1 get divided to zero.
        // so only omit every second event
        if (fabsf(offset) == 1)
        {
            if(!lastDragDividedOne_)
            {
                lastDragDividedOne_ = YES;
                offset = 0;
            }
            else
                lastDragDividedOne_ = NO;
        }
        else
            offset = roundf(offset/2.f);
    }

    [self moveStackWithOffset:(NSInteger) offset animated:NO userDragging:YES];

    // set up designated drag destination
    if (state == UIGestureRecognizerStateBegan)
    {
        if (offset > 0)
            _lastDragOption = SVSnapOptionRight;
        else
            _lastDragOption = SVSnapOptionLeft;
    }
    else
    {
        // if there's a continuous drag in one direction, keep designation - else use nearest to snap.
        if ((_lastDragOption == SVSnapOptionLeft && offset > 0) || (_lastDragOption == SVSnapOptionRight && offset < 0))
            _lastDragOption = SVSnapOptionNearest;
    }

    // save last point to calculate new offset
    if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged)
        lastDragOffset_ = (NSInteger) translatedPoint.x;

    // perform snapping after gesture ended
    BOOL gestureEnded = state == UIGestureRecognizerStateEnded;
    if (gestureEnded)
    {
        if (_lastDragOption == SVSnapOptionRight){
            self.floatIndex = [self nearestValidFloatIndex:self.floatIndex round:/*PSSVRoundDown*/PSSVRoundAvoidHalf];
        }
        else if(_lastDragOption == SVSnapOptionLeft){
            self.floatIndex = [self nearestValidFloatIndex:self.floatIndex round:PSSVRoundUp];
        }
        else {
            self.floatIndex = [self nearestValidFloatIndex:self.floatIndex round:PSSVRoundAvoidHalf];
//            self.floatIndex = 1.0f;
        }
        [self alignStackAnimated:YES
                 completionBlock:^{
                     [self popInvisibleViewControllers];
                 }];


    }
}

#pragma mark - SVStackRootController (Public)

- (NSUInteger)indexOfViewController:(UIViewController *)viewController
{
    __block NSUInteger index = [self.viewControllers indexOfObject:viewController];
    if (index == NSNotFound)
    {
        index = [self.viewControllers indexOfObject:viewController.navigationController];
        if (index == NSNotFound)
        {
            [self.viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
                                                                 if ([obj isKindOfClass:[UINavigationController class]] &&
                                                                         ((UINavigationController *)obj).topViewController == viewController)
                                                                 {
                                                                     index = idx;
                                                                     *stop = YES;
                                                                 }
                                                             }];
        }
    }
    return index;
}



- (UIViewController *)topViewController
{
    return self.viewControllers.count?[self.viewControllers lastObject]:self.rootViewController;
}

- (UIViewController *)firstViewController
{
    return [self.viewControllers count] ? [self.viewControllers objectAtIndex:0] : nil;
}

- (NSArray *)visibleViewControllers
{
    return [self visibleViewControllersSetFullyVisible:NO];
}

- (NSArray *)fullyVisibleViewControllers
{
    return [self visibleViewControllersSetFullyVisible:YES];
}

#pragma mark - Controllers push/pop methods

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self pushViewController:viewController fromViewController:self.topViewController animated:animated];
}

- (void)pushViewController:(UIViewController *)viewController fromViewController:(UIViewController *)baseViewController animated:(BOOL)animated
{
    // figure out where to push, and if we need to get rid of some viewControllers
    if (baseViewController)
    {
        [self.viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
            UIViewController *baseVC = objc_getAssociatedObject(obj, (__bridge void *const)kPSSVAssociatedBaseViewControllerKey);
            if (baseVC == baseViewController)
            {
                PSSVLog(@"BaseViewController found on index: %d", idx);
                UIViewController *parentVC = [self previousViewController:obj];
                if (parentVC)
                    [self popToViewController:parentVC animated:NO invokeDelegate:YES];
                else
                    [self popToRootViewControllerAnimated:NO invokeDelegate:YES];
                *stop = YES;
            }
        }];
        objc_setAssociatedObject(viewController, (__bridge void *const) kPSSVAssociatedBaseViewControllerKey, baseViewController, OBJC_ASSOCIATION_ASSIGN); // associate weak
    }
    // register stack controller
    // WARNING: this is the first place where viewController's view is accessed directly. Here we should set view controller's Stack Controller property
    PSSVLog(@"Pushing with index %d on stack: %@ (animated: %d)", [self.viewControllers count], viewController, animated);
    objc_setAssociatedObject(viewController, (__bridge void *const)kPSSVAssociatedStackViewControllerKey, self, OBJC_ASSOCIATION_ASSIGN);
    viewController.view.height = [self screenHeight];
    // get predefined stack width; query topViewController if we have a UINavigationController
    CGFloat stackWidth = viewController.stackWidth;
    if (stackWidth == 0.f && [viewController isKindOfClass:[UINavigationController class]])
    {
        UIViewController *topVC = ((UINavigationController *)viewController).topViewController;
        stackWidth = topVC.stackWidth;
    }
    stackWidth = [self baseDesignatedWidthForOrientation:[[UIApplication sharedApplication] statusBarOrientation]];

    if (stackWidth > 0.f)
        viewController.view.width = stackWidth;
    // Starting out in portrait, right side up, we see a 20 pixel gap (for status bar???)
    viewController.view.top = 0.f;

    // controller view is embedded into a container
    TXContainerView *container = [self wrappingViewForController:viewController];
    PSSVLog(@"container frame: %@", NSStringFromCGRect(container.frame));

    //add VC to the hierarchy
    [self addChildViewController:viewController];
    if (animated)
    {
        container.alpha = 0.f;
        if (enableScalingFadeInOut_)
            container.transform = CGAffineTransformMakeScale(1.2, 1.2); // large but fade in
    }
    [self delegateWillShowViewController:viewController];
    [_viewControllers addObject:viewController];
    [self.view addSubview:container];
    [viewController didMoveToParentViewController:self];
    PSSVSimpleBlock completionBlock = ^{
        [self delegateDidShowViewController:viewController];
    };
    if (animated)
    {
        [UIView animateWithDuration:kPSSVStackAnimationPushDuration
                              delay:0.f
                            options:UIViewAnimationOptionAllowUserInteraction 
                         animations:^{
                             container.alpha = 1.f;
                             container.transform = CGAffineTransformIdentity;
                         }
                         completion:^(BOOL completed){
                             if (completed)
                                completionBlock();
                         }];
    }
    // properly sizes the scroll view contents (for table view scrolling)
    [container layoutIfNeeded];
    [self updateViewControllerMasksAndShadow];
    if (self.floatIndex >=1 && self.floatIndex != (int)self.floatIndex)
        self.floatIndex =  [self nearestValidFloatIndex:self.floatIndex round:PSSVRoundUp];


    [self displayViewControllerIndexOnRightMost:[self.viewControllers count]-1 animated:animated];

    [self checkStackEditMode];
    if (!animated)
        completionBlock();
}

- (BOOL)popViewController:(UIViewController *)controller animated:(BOOL)animated
{
    if (controller != self.topViewController)
        return NO;
    else
        return [self popViewControllerAnimated:animated] == controller;
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    return [self popViewControllerAnimated:animated invokeDelegate:YES];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated invokeDelegate:(BOOL)invokeDelegate
{
    PSSVLog(@"popping controller: %@ (#%d total, animated:%d)", [self topViewController], [self.viewControllers count], animated);
    UIViewController *lastController = [self topViewController];
    if (lastController)
    {
        TXContainerView *container = lastController.containerView;
        PSSVSimpleBlock finishBlock = ^{
            [lastController willMoveToParentViewController:nil];
            [container removeFromSuperview];
            [lastController removeFromParentViewController];
            if (invokeDelegate)
                [self delegateDidShowViewController:self.topViewController];
        };
        if (invokeDelegate)
            [self delegateWillShowViewController:[self previousViewController:self.topViewController]];
        [_viewControllers removeLastObject];
        if (animated)
        {
            // kPSSVStackAnimationDuration
            [UIView animateWithDuration:kPSSVStackAnimationPopDuration
                                  delay:0.f
                                options:UIViewAnimationOptionBeginFromCurrentState
                             animations:^(void) {
                                 lastController.containerView.alpha = 0.f;
                                 if (enableScalingFadeInOut_)
                                     lastController.containerView.transform = CGAffineTransformMakeScale(0.8, 0.8); // make smaller while fading out
                             }
                             completion:^(BOOL finished) {
                                 // even with duration = 0, this doesn't fire instantly but on a future run loop with NSFireDelayedPerform, thus ugly double-check
                                 // DO NOT TOUCH! This may cause incorrect behaviour of stack controller (yvorontsov 3.09.2012)
                                 if (finished)
                                     finishBlock();
                             }];
        }
        else
            finishBlock();
        // save current stack controller as an associated object.
        objc_setAssociatedObject(lastController, (__bridge void *const) kPSSVAssociatedStackViewControllerKey, nil, OBJC_ASSOCIATION_ASSIGN);

        // realign view controllers
        [self updateViewControllerMasksAndShadow];
        [self alignStackAnimated:animated];
    }

    [self checkStackEditMode];
    return lastController;
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
{
    return [self popToRootViewControllerAnimated:animated invokeDelegate:YES];
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated completionBlock:(SimpleBlock)completionBlock
{
    [self popToRootViewControllerAnimated:animated invokeDelegate:YES];
    if (completionBlock)
        completionBlock();
    return nil;
}


- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated invokeDelegate:(BOOL)invokeDelegate
{
    if (invokeDelegate)
        [self delegateWillShowViewController:self.rootViewController];
    NSMutableArray *array = [NSMutableArray array];
    while ([self.viewControllers count] > 0)
    {
        UIViewController *vc = [self popViewControllerAnimated:animated invokeDelegate:NO];
        [array addObject:vc];
    }
    if (invokeDelegate)
        [self delegateDidShowViewController:self.rootViewController];
    return array;
}

// get view controllers that are in stack _after_ current view controller
- (NSArray *)viewControllersAfterViewController:(UIViewController *)viewController
{
    NSParameterAssert(viewController);
    NSUInteger index = [self indexOfViewController:viewController];
    if (NSNotFound == index)
        return nil;
    NSArray *array = nil;
    // don't remove view controller we've been called with
    if ([self.viewControllers count] > index + 1)
        array = [self.viewControllers subarrayWithRange:NSMakeRange(index + 1, [self.viewControllers count] - index - 1)];
    return array;
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    return [self popToViewController:viewController animated:animated invokeDelegate:YES];
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated invokeDelegate:(BOOL)invokeDelegate
{
    NSParameterAssert(viewController);
    NSUInteger index = [self indexOfViewController:viewController];
    if (NSNotFound == index)
        return nil;
    PSSVLog(@"popping to index %d, from %d", index, [self.viewControllers count]);
    NSArray *controllersToRemove = [self viewControllersAfterViewController:viewController];
    if (controllersToRemove.count)
    {
        if (invokeDelegate)
            [self delegateWillShowViewController:viewController];
        [controllersToRemove enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop){
            [self popViewControllerAnimated:animated invokeDelegate:NO];
        }];
        if (invokeDelegate)
            [self delegateDidShowViewController:viewController];
    }
    return controllersToRemove;
}

#pragma mark - Other nethods

- (NSArray *)controllersForClass:(Class)theClass
{
    NSArray *controllers = [self.viewControllers filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [evaluatedObject isKindOfClass:theClass] ||
                ([evaluatedObject isKindOfClass:[UINavigationController class]] && [((UINavigationController *)evaluatedObject).topViewController isKindOfClass:theClass]);
    }]];
    return controllers;
}

// last visible index is calculated dynamically, depending on width of VCs
- (NSInteger)lastVisibleIndex
{
    NSUInteger lastVisibleIndex = (NSUInteger) self.firstVisibleIndex;
    NSUInteger currentLeftInset = [self currentLeftInset];
    CGFloat screenSpaceLeft = [self screenWidth] - currentLeftInset;
    while (screenSpaceLeft > 0 && lastVisibleIndex < [self.viewControllers count])
    {
        UIViewController *vc = [self.viewControllers objectAtIndex:lastVisibleIndex];
        screenSpaceLeft -= vc.containerView.width;
        if (screenSpaceLeft >= 0)
            lastVisibleIndex++;
    }
    if (lastVisibleIndex > 0)
        lastVisibleIndex--; // compensate for last failure
    return lastVisibleIndex;
}

// returns +/- amount if grid is not aligned correctly
// + if view is too far on the right, - if too far on the left
- (CGFloat)gridOffsetByPixels
{
    CGFloat gridOffset;
    CGFloat firstVCLeft = self.firstViewController.containerView.left;
    // easiest case, controller is > then wide menu
    if (firstVCLeft > [self currentLeftInset] || firstVCLeft < [self currentLeftInset])
        gridOffset = firstVCLeft - [self currentLeftInset];
    else
    {
        NSUInteger targetIndex = (NSUInteger) self.firstVisibleIndex; // default, abs(gridOffset) < 1
        UIViewController *overlappedVC = [self overlappedViewController];
        if (overlappedVC)
        {
            UIViewController *rightVC = [self nextViewController:overlappedVC];
            targetIndex = [self indexOfViewController:rightVC];
            PSSVLog(@"overlapping %@ with %@", NSStringFromCGRect(overlappedVC.containerView.frame), NSStringFromCGRect(rightVC.containerView.frame));
        }
        UIViewController *targetVCController = [self.viewControllers objectAtIndex:targetIndex];
        CGRect targetVCFrame = [self rectForControllerAtIndex:targetIndex];
        gridOffset = targetVCController.containerView.left - targetVCFrame.origin.x;
    }
    PSSVLog(@"gridOffset: %f", gridOffset);
    return gridOffset;
}

/// detect if last drag offset is large enough that we should make a snap animation
- (BOOL)shouldSnapAnimate
{
    BOOL shouldSnapAnimate = abs(lastDragOffset_) > 10;
    return shouldSnapAnimate;
}

// bouncing is a three-way operation
enum
{
    PSSVBounceNone,
    PSSVBounceMoveToInitial,
    PSSVBounceBleedOver,
    PSSVBounceBack,
}typedef PSSVBounceOption;

- (void)alignStackAnimated:(BOOL)animated duration:(CGFloat)duration bounceType:(PSSVBounceOption)bounce completionBlock:(PSSVSimpleBlock)completionBlock
{
    animated = animated && !self.isReducingAnimations; // don't animate if set
    self.floatIndex = [self nearestValidFloatIndex:self.floatIndex]; // round to nearest correct index
    UIViewAnimationCurve animationCurve = UIViewAnimationCurveEaseInOut;
    if (animated)
    {
        if (bounce == PSSVBounceMoveToInitial)
        {
            if ([self shouldSnapAnimate])
                animationCurve = UIViewAnimationCurveLinear;
            CGFloat gridOffset = [self gridOffsetByPixels];
            snapBackFromLeft_ = gridOffset < 0;
            // some magic numbers to better reflect movement time
            duration = fabsf(gridOffset)/200.f * duration * 0.4f + duration * 0.6f;
        }
        else if(bounce == PSSVBounceBleedOver)
            animationCurve = UIViewAnimationCurveEaseOut;
    }

    PSSVSimpleBlock alignmentBlock = ^{
        PSSVLog(@"Begin aliging VCs. Last drag offset:%d direction:%d bounce:%d.", lastDragOffset_, _lastDragOption, bounce);
        // calculate offset used only when we're bleeding over
        NSInteger snapOverOffset = 0; // > 0 = <--- ; we scrolled from right to left.
        NSUInteger firstVisibleIndex = (NSUInteger) [self firstVisibleIndex];
        NSUInteger lastFullyVCIndex = [self indexOfViewController:[self lastVisibleViewControllerCompletelyVisible:YES]];
        BOOL bounceAtVeryEnd = NO;

        if ([self shouldSnapAnimate] && bounce == PSSVBounceBleedOver)
        {
            snapOverOffset = (NSInteger) fabsf(lastDragOffset_ / 5.f);
            if (snapOverOffset > kPSSVMaxSnapOverOffset)
                snapOverOffset = kPSSVMaxSnapOverOffset;

            // positive/negative snap offset depending on snap back direction
            snapOverOffset *= snapBackFromLeft_ ? 1 : -1;
            // if we're dragging menu all the way out, bounce back in
            PSSVLog(@"%@", NSStringFromCGRect(self.firstViewController.containerView.frame));
            CGFloat firstVCLeft = self.firstViewController.containerView.left;
            if (firstVisibleIndex == 0 && !snapBackFromLeft_ && firstVCLeft >= self.largeLeftInset)
                bounceAtVeryEnd = YES;
            else if(lastFullyVCIndex == [self.viewControllers count]-1 && lastFullyVCIndex > 0)
                bounceAtVeryEnd = YES;
            PSSVLog(@"bouncing with offset: %d, firstIndex:%d, snapToLeft:%d veryEnd:%d", snapOverOffset, firstVisibleIndex, snapOverOffset<0, bounceAtVeryEnd);
        }

        // iterate over all view controllers and snap them to their correct positions
        __block NSArray *frames = [self rectsForControllers];
        [self.viewControllers enumerateObjectsWithOptions:0
                                               usingBlock:^(UIViewController *currentVC, NSUInteger idx, BOOL *stop) {
                                                   CGRect currentFrame = [[frames objectAtIndex:idx] CGRectValue];
                                                   currentVC.containerView.left = currentFrame.origin.x;

                                                   // menu drag to right case or swiping last vc towards menu
                                                   if (bounceAtVeryEnd)
                                                   {
                                                       if (idx == firstVisibleIndex)
                                                           frames = [self modifiedRects:frames newLeft:currentVC.containerView.left + snapOverOffset index:idx];
                                                   }
                                                           // snap the leftmost view controller
                                                   else if ((snapOverOffset > 0 && idx == firstVisibleIndex)
                                                           || (snapOverOffset < 0 && (idx == firstVisibleIndex+1))
                                                           || [self.viewControllers count] == 1)
                                                   {
                                                       frames = [self modifiedRects:frames newLeft:currentVC.containerView.left + snapOverOffset index:idx];
                                                   }
                                                   // set again (maybe changed)
                                                   currentFrame = [[frames objectAtIndex:idx] CGRectValue];
                                                   currentVC.containerView.left = currentFrame.origin.x;
                                               }];
        [self updateViewControllerMasksAndShadow];
    };
    if (animated)
    {
        [UIView animateWithDuration:duration
                              delay:0.f
                            options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState | animationCurve
                         animations:alignmentBlock
                         completion:^(BOOL finished) {
                             /*  Scroll physics are applied here. Drag speed is saved in lastDragOffset. (direction with +/-, speed)
                              *  If we are above a certain speed, we "shoot over the target", then snap back. 
                              *  This is of course dependent on the direction we scrolled.
                              *
                              *  Right swiping (collapsing) makes the next vc overlapping the current vc a few pixels.
                              *  Left swiping (expanding) takes the parent controller a few pixels with, then snapping back.
                              *
                              *  We have 3 animations total
                              *   1) scroll to correct position
                              *   2) bleed over
                              *   3) snap back to correct position
                              */
                             if (finished && [self shouldSnapAnimate])
                             {
                                 CGFloat animationDuration = kPSSVStackAnimationBounceDuration/2.f;
                                 switch (bounce)
                                 {
                                     case PSSVBounceMoveToInitial:
                                     {
                                         // bleed over now!
                                         [self alignStackAnimated:YES duration:animationDuration bounceType:PSSVBounceBleedOver completionBlock:completionBlock];
                                         break;
                                     }
                                     case PSSVBounceBleedOver:
                                     {
                                         // now bounce back to origin
                                         [self alignStackAnimated:YES duration:animationDuration bounceType:PSSVBounceBack completionBlock:completionBlock];
                                         break;
                                     }
                                     case PSSVBounceNone:
                                     {
                                         [self delegateDidAlign];
                                         break;
                                     }
                                     case PSSVBounceBack:
                                     {
                                         [self delegateDidAlign];
                                         break;
                                     }
                                     default:
                                     {
                                         lastDragOffset_ = 0; // clear last drag offset for the animation
                                         break;
                                     }
                                 }
                             }
                             else if(finished)
                                 [self delegateDidAlign];
                             if (completionBlock)
                                 completionBlock();
                         }
        ];
    }
    else
        alignmentBlock();
}

- (void)alignStackAnimated:(BOOL)animated
{
    [self alignStackAnimated:animated completionBlock:nil];
}

- (void)alignStackAnimated:(BOOL)animated completionBlock:(PSSVSimpleBlock)completionBlock
{
    if([self enableBounces])
        [self alignStackAnimated:animated duration:kPSSVStackAnimationDuration bounceType:PSSVBounceMoveToInitial completionBlock:completionBlock];
    else
        [self alignStackAnimated:animated duration:kPSSVStackAnimationDuration bounceType:PSSVBounceNone completionBlock:completionBlock];
}

- (NSUInteger)canCollapseStack
{
    NSUInteger steps = [self.viewControllers count] - self.firstVisibleIndex - 1;
    if (self.lastVisibleIndex == [self.viewControllers count] - 1)
        steps = 0;
    else if (self.firstVisibleIndex + steps > [self.viewControllers count]-1)
        steps = [self.viewControllers count] - self.firstVisibleIndex - 1;
    return steps;
}


- (NSUInteger)collapseStack:(NSInteger)steps animated:(BOOL)animated
{
    // (<--- increases firstVisibleIndex)
    PSSVLog(@"collapsing stack with %d steps [%d-%d]", steps, self.firstVisibleIndex, self.lastVisibleIndex);
    CGFloat newFloatIndex = self.floatIndex;
    while (steps > 0)
    {
        newFloatIndex = [self nextFloatIndex:newFloatIndex];
        steps--;
    }
    if (newFloatIndex > 0.f)
        self.floatIndex = MAX(newFloatIndex, self.floatIndex);
    [self alignStackAnimated:animated];
    return (NSUInteger) steps;
}

- (NSUInteger)canExpandStack
{
    NSUInteger steps = (NSUInteger) self.firstVisibleIndex;
    // sanity check
    if (steps >= [self.viewControllers count]-1)
    {
        PSSVLog(@"Warning: firstVisibleIndex is higher than viewController count!");
        steps = [self.viewControllers count]-1;
    }
    return steps;
}

- (NSUInteger)expandStack:(NSInteger)steps animated:(BOOL)animated
{
    // (---> decreases firstVisibleIndex)
    steps = abs(steps); // normalize
    PSSVLog(@"expanding stack with %d steps [%d-%d]", steps, self.firstVisibleIndex, self.lastVisibleIndex);
    CGFloat newFloatIndex = self.floatIndex;
    while (steps > 0)
    {
        newFloatIndex = [self prevFloatIndex:newFloatIndex];
        steps--;
    }
    self.floatIndex = MIN(newFloatIndex, self.floatIndex);
    [self alignStackAnimated:animated
             completionBlock:^{
                 [self popInvisibleViewControllers];
             }];
    return (NSUInteger) steps;
}

- (void)setNumberOfTouches:(NSUInteger)numberOfTouches
{
    numberOfTouches_ = numberOfTouches;
    [self configureGestureRecognizer];
}

- (void)setLeftInset:(NSUInteger)leftInset
{
    [self setLeftInset:leftInset animated:NO];
}

- (void)setLeftInset:(NSUInteger)leftInset animated:(BOOL)animated
{
    leftInset_ = leftInset;
    [self alignStackAnimated:animated];
}

- (void)setLargeLeftInset:(NSUInteger)leftInset
{
    [self setLargeLeftInset:leftInset animated:NO];
}

- (void)setLargeLeftInset:(NSUInteger)leftInset animated:(BOOL)animated
{
    largeLeftInset_ = leftInset;
    [self alignStackAnimated:animated];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (touch.view.superview != nil)
    {
        if ([touch.view superviewOfClass:[UITableViewCell class]] != nil)
            return NO; // ignore the touch for TV cells
    }
    else if ([touch.view isKindOfClass:[UIControl class]])
        return NO; // prevent recognizing touches on the slider
    return YES;
}

#pragma mark - Lock/unlock UI

- (void)setUserInteractionEnabled:(BOOL)enabled
{
    [self setUserInteractionEnabled:enabled exceptController:self.topViewController];
}

- (void)setUserInteractionEnabled:(BOOL)enabled exceptController:(UIViewController *)ctl
{
    self.panRecognizer.enabled = enabled;
    for (UIViewController *controller in self.viewControllers)
    {
        if (controller != ctl && controller.isViewLoaded)
            controller.view.userInteractionEnabled = enabled;
    }
    TXContainerView *containerView = ctl.containerView;
    containerView.shadowWidth = enabled?defaultShadowWidth_:self.view.width - ctl.view.width;
    containerView.shadowAlpha = enabled?defaultShadowAlpha_:1;
    [containerView updateContainer];
}

- (void)checkStackEditMode
{
    self.panRecognizer.enabled = YES;
}

@end
