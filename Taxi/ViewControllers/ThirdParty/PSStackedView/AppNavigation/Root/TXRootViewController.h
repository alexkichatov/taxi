
#import <UIKit/UIKit.h>
#import "TXStackedViewDelegate.h"
#import "TXConstants.h"
#import "TXMenuCell.h"
#import "TXBaseViewController.h"


@interface TXRootViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,
        TXStackedViewDelegate, TXMenuCellDelegate, TXAppearanceDelegate>
@property (nonatomic, strong) NSArray *menuItems;
@property (weak, nonatomic) UIAlertView *activeAlertView;
- (void)navigateToHomeViewController;
- (void)popBackButtonItem;
- (void)pushBackButtonItemForController:(UIViewController *)viewController;
- (void)pushBackButtonItemForFirstControllerInTheStack:(UIViewController *)viewController;
- (void)constructMenus;
- (void)performMenuTransition:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath menuItem:(TXMenuItemObject *)menuItem;
- (UIViewController *)getViewControllerForMenuItem:(TXMenuItemObject *)menuItem;
@end
