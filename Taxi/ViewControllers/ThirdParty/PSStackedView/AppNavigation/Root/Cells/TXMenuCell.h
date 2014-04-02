#import <UIKit/UIKit.h>
#import "TXBaseCell.h"

@class TXMenuItemObject;
@class TXMenuCell;

@protocol TXMenuCellDelegate <NSObject, TXBaseCellDelegate>
- (void)menuCell:(TXMenuCell*)menuCell menuItemExpandingChanged:(TXMenuItemObject*)itemObject;
@end


@interface TXMenuCell : TXBaseCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *badgeImageView;
@property (nonatomic, readonly) TXMenuItemObject *menuObject;
@property (nonatomic, weak) id<TXMenuCellDelegate> delegate;
@property (nonatomic) BOOL customBGColor;
@property (nonatomic) NSInteger badgeNumber;
- (void)configureWithMenuItem:(TXMenuItemObject*)itemObject;
- (void)updateCellUI;
- (void)setMenuItemTitle:(NSString *)title;
@end
