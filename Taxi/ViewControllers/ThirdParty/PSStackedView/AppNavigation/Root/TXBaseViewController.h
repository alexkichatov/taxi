
#import <Foundation/Foundation.h>
#import "TXMenuItemObject.h"
#import "TXBaseNavigationProtocol.h"
#import "UIViewController+BaseNavigation.h"
#import "TXAppearanceDelegate.h"

@class TXBaseViewController;
@class TXObjectPDQ;



@interface TXBaseViewController : UIViewController <TXBaseNavigationProtocol>
@property (nonatomic, weak) id<TXAppearanceDelegate> appearanceDelegate;

@property (assign, nonatomic) BOOL allowsSyncAfterPopping;
@property (strong, nonatomic) TXObjectPDQ *objectPDQ;
@property (readonly, nonatomic) NSString *controllerStatID;
@property (readonly, nonatomic) BOOL includeInStats;



- (void) checkIfControllerIsNotFullyOnScreen;


@end