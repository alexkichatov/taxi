#import "TXBaseCell.h"

NSString *const kToolBarLabel = @"label";
NSString *const kPercentages = @"percentages";
NSInteger const kLabelIndent = 10;

@implementation TXBaseCell
@synthesize dividerNeeded = _deviderNeeded;
@synthesize delegate = _delegate;
@synthesize fieldToolBar = _fieldToolBar;


#pragma mark - UITableViewCell - overridden methods

+ (NSString *)reuseIdentifier
{
    return NSStringFromClass(self);
}

- (NSString *)reuseIdentifier
{
    return [[self class] reuseIdentifier];
}

#pragma mark - Class methods

// This is black magic
// from
// http://stackoverflow.com/questions/4708085/how-to-determine-margin-of-a-grouped-uitableview-or-better-how-to-set-it
+ (CGFloat)cellMarginForTableWidth:(CGFloat)tableWidth
{
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1){
        return 0;
    }

    // No margins for plain table views
    // iPhone always have 10 pixels margin
    // Really small table
    if (tableWidth <= 20)
        return tableWidth - 10;
    // Average table size
    if (tableWidth < 400)
        return 10;
    // Big tables have complex margin's logic
    // Around 6% of table width,
    // 31 <= tableWidth * 0.06 <= 45
    CGFloat marginWidth = tableWidth * 0.06;
    marginWidth = MAX(31, MIN(45, marginWidth));
    return marginWidth;
}

#pragma mark - Selection

- (void)cellSelected
{
    // override in subclasses
}

#pragma mark - Keyboard management

- (UIToolbar*)fieldToolBar
{
    // To fix physical keyboard blank area bug;
//    if (!_fieldToolBar) {
//        _fieldToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 308, 200, 44)];
//        _fieldToolBar.barStyle = UIBarStyleBlack;
//        _fieldToolBar.translucent = YES;
    
        //UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(nextButtonPressed:)];
        //UIBarButtonItem *prevButton = [[UIBarButtonItem alloc] initWithTitle:@"Previous" style:UIBarButtonItemStyleBordered target:self action:@selector(prevButtonPressed:)];
        //[_fieldToolBar setItems:[NSArray arrayWithObjects:prevButton, nextButton, nil]];
//    }
//    return _fieldToolBar;
    
    return nil;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(baseCell:textFieldDidBeginEditing:)])
        [self.delegate baseCell:self textFieldDidBeginEditing:textField];
}

- (void)textViewDidBeginEditing:(UITextView *)_textView
{
    if ([self.delegate respondsToSelector:@selector(baseCell:textViewDidBeginEditing:)])
        [self.delegate baseCell:self textViewDidBeginEditing:_textView];
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}
#pragma mark Keyboard buttons

- (void) nextButtonPressed:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(baseCell:keyboardButtonNextPressedForTextField:)])
        [self.delegate baseCell:self keyboardButtonNextPressedForTextField:nil];
}

- (void) prevButtonPressed:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(baseCell:keyboardButtonPreviousPressedForTextField:)])
        [self.delegate baseCell:self keyboardButtonPreviousPressedForTextField:nil];
}

@end
