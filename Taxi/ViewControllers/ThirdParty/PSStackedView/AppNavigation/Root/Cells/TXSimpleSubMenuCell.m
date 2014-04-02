#import "TXSimpleSubMenuCell.h"
#import "TXRootViewController.h"
#import "TXMenuItemObject.h"

@implementation TXSimpleSubMenuCell

-(void)awakeFromNib
{
    self.customBGColor = YES;
}

- (void)dealloc
{
    [self configureWithMenuItem:nil];
}

- (void)configureWithMenuItem:(TXMenuItemObject *)itemObject
{
    [super configureWithMenuItem:itemObject];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
}

- (void)updateCellUI
{
    [self setMenuItemTitle:self.menuObject.itemName];
}

-(void)bgConfigForState:(BOOL)selected
{
}

- (void) configureCellBackground
{
}

@end
