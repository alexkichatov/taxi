#import "Macro.h"
#import "TXAlertView.h"
#import "TXStackedViewController.h"
#import "TXRootViewController.h"

@interface TXAlertView()
@property (weak, nonatomic) TXRootViewController *hostController;
@end


@implementation TXAlertView
@synthesize userInfo;

#pragma mark - Initialization methods

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    DLogE(@"Use %@ instead", NSStringFromSelector(@selector(initWithTitle:message:delegate:stackedViewController:cancelButtonTitle:otherButtonTitles:)));
    return nil;
}

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
             delegate:(id)delegate
stackedViewController:(TXStackedViewController *)stackedViewController
    cancelButtonTitle:(NSString *)cancelButtonTitle
    otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    if ((self = [super initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil]))
    {
        TXRootViewController *rootViewController = (TXRootViewController *) stackedViewController.rootViewController;
        NSParameterAssert(rootViewController != nil);
        self.hostController = rootViewController;
        if (!self.hostController.activeAlertView)
            self.hostController.activeAlertView = self;
    }
    self.accessibilityLabel = title;
    return self;
}

#pragma mark - Short presentation methods

+ (void)showInProgressAlert:(TXStackedViewController *)stackedViewController
{
    [[[TXAlertView alloc] initWithTitle:@"In Progress"
                                 message:@"We're working on it now. It will be available soon"
                                delegate:nil
                   stackedViewController:stackedViewController
                       cancelButtonTitle:@"OK"
                       otherButtonTitles:nil] show];
}

+ (void)showNotAllValidAlert:(TXStackedViewController *)stackedViewController
{
    [[[TXAlertView alloc] initWithTitle:@"Not all required field are valid"
                                 message:@"Please fill in all required fields"
                                delegate:nil
                   stackedViewController:stackedViewController
                       cancelButtonTitle:@"OK"
                       otherButtonTitles:nil] show];
}

+ (void)showEmailNotValidAlert:(TXStackedViewController *)stackedViewController
{
    [[[TXAlertView alloc] initWithTitle:@"Email is not valid"
                                 message:@"Please use valid email"
                                delegate:nil
                   stackedViewController:stackedViewController
                       cancelButtonTitle:@"OK"
                       otherButtonTitles:nil] show];
}

+ (void)showErrorSubscribeObject:(TXStackedViewController *)stackedViewController
{
    [[[TXAlertView alloc] initWithTitle:@"Error object subscription"
                                 message:@"Operation is failed"
                                delegate:nil
                   stackedViewController:stackedViewController
                       cancelButtonTitle:@"OK"
                       otherButtonTitles:nil] show];
}

+ (void)showNoteWarningAlert:(TXStackedViewController *)stackedViewController
{
    [[[TXAlertView alloc] initWithTitle:@"Note content size warning"
                                 message:@"The note content is too big. Please remove a part of text"
                                delegate:nil
                   stackedViewController:stackedViewController
                       cancelButtonTitle:@"OK"
                       otherButtonTitles:nil] show];
}

+ (void)showEntityUnsubscriptionWarningAlert:(TXStackedViewController *)stackedViewController entityName:(NSString *)entityName
{
    NSString* alertContent = [NSString stringWithFormat:@"%@ unsubscription failed", entityName];
    [[[TXAlertView alloc] initWithTitle:@"Unsubscription warning"
                                 message:alertContent
                                delegate:nil
                   stackedViewController:stackedViewController
                       cancelButtonTitle:@"OK"
                       otherButtonTitles:nil] show];
}

+ (void)showAccountAddressWarning:(TXStackedViewController *)stackedViewController warningMode:(TXAdressAlertMode)warningMode
{
    NSString* warningTitle = nil;
    NSString* warningContent = nil;
    switch (warningMode)
    {
        case TXAddressAlertSelection:
        {
            warningTitle = @"Address selection warning";
            warningContent = @"Account is not subscribed or opportunity is not selected";
            break;
        }
        case TXAddressAlertAddition:
        {
            warningTitle = @"Address addition warning";
            warningContent = @"Account is not subscribed or contact doesn't have parent account";
            break;
        }
        default:
            break;
    }
    [[[TXAlertView alloc] initWithTitle:warningTitle
                                 message:warningContent
                                delegate:nil
                   stackedViewController:stackedViewController
                       cancelButtonTitle:@"OK"
                       otherButtonTitles:nil] show];
}

+ (void)showQuoteItemDiscountAlert:(TXStackedViewController *)stackedViewController
{
    [[[TXAlertView alloc] initWithTitle:@"Warning"
                                 message:@"Please contact the pricing team for this quote."
                                delegate:nil
                   stackedViewController:stackedViewController
                       cancelButtonTitle:@"OK"
                       otherButtonTitles:nil] show];
}


#pragma mark - Presentation methods

- (BOOL)canBeShown
{
    return self.hostController.activeAlertView == self;
}

- (void)show
{
    if (self.canBeShown)
        [super show];
}


@end