
#import <UIKit/UIKit.h>
//#import "TXLabeledFlexibleControl.h"

extern NSString *const kToolBarLabel;
extern NSString *const kPercentages;
extern NSInteger const kLabelIndent;

@protocol TXBaseCellDelegate <NSObject>
@optional
- (void)baseCell:(UITableViewCell *)cell keyboardButtonNextPressedForTextField:(UITextField *)textField;
- (void)baseCell:(UITableViewCell *)cell keyboardButtonPreviousPressedForTextField:(UITextField *)textField;
- (void)baseCell:(UITableViewCell *)cell textFieldDidBeginEditing:(UITextField *)textField;
- (void)baseCell:(UITableViewCell *)cell textViewDidBeginEditing:(UITextView *)textView;
@end

@interface TXBaseCell : UITableViewCell <UITextFieldDelegate, UITextViewDelegate>
@property (nonatomic) BOOL dividerNeeded;
@property (nonatomic, weak) id<TXBaseCellDelegate> delegate;
@property (nonatomic, strong) UIToolbar* fieldToolBar;
- (void) cellSelected;
+ (NSString *) reuseIdentifier;
+ (CGFloat)cellMarginForTableWidth:(CGFloat)tableWidth;
@end