
#import "UIToolbar+AddItems.h"


@implementation UIToolbar (AddItems)

- (void)insertItem:(UIBarItem *)barItem atIndex:(NSUInteger)index animated:(BOOL)animated
{
    NSMutableArray *toolbarItems = [self.items mutableCopy];
    NSAssert(index <= toolbarItems.count, @"Invalid index for toolbar item");
    [toolbarItems insertObject:barItem atIndex:index];
    [self setItems:toolbarItems animated:animated];
}

- (void)removeItemAtIndex:(NSUInteger)index animated:(BOOL)animated
{
    NSMutableArray *toolbarItems = [self.items mutableCopy];
    NSAssert(index < toolbarItems.count, @"Invalid index for toolbar item");
    [toolbarItems removeObjectAtIndex:index];
    [self setItems:toolbarItems animated:animated];
}

- (void)removeItem:(UIBarItem *)barItem animated:(BOOL)animated
{
    NSUInteger itemIndex = [self.items indexOfObject:barItem];
    if (itemIndex != NSNotFound)
        [self removeItemAtIndex:itemIndex animated:animated];
}

- (void)pushLeftItem:(UIBarItem *)barItem animated:(BOOL)animated
{
    [self insertItem:barItem atIndex:0 animated:animated];
}

- (void)popLeftItemAnimated:(BOOL)animated
{
    [self removeItemAtIndex:0 animated:animated];
}

- (void)pushRightItem:(UIBarItem *)barItem animated:(BOOL)animated
{
    [self insertItem:barItem atIndex:self.items.count animated:animated];
}

- (void)popRightItemAnimated:(BOOL)animated
{
    [self removeItemAtIndex:self.items.count animated:YES];
}

- (void)appendItems:(NSArray *)barItems animated:(BOOL)animated
{
    if (barItems.count)
    {
        NSMutableArray *toolbarItems = [self.items mutableCopy];
        [toolbarItems addObjectsFromArray:barItems];
        [self setItems:toolbarItems animated:animated];
    }
}

- (void)popItemsFromIndex:(NSUInteger)index animated:(BOOL)animated
{
    if (index < self.items.count)
    {
        NSArray *extraItems = [self.items subarrayWithRange:NSMakeRange(index, self.items.count - index)];
        [self popItems:extraItems animated:animated];
    }
}

- (void)popItems:(NSArray *)barItems animated:(BOOL)animated
{
    if (barItems.count)
    {
        NSMutableArray *toolbarItems = [self.items mutableCopy];
        [toolbarItems removeObjectsInArray:barItems];
        [self setItems:toolbarItems animated:animated];
    }
}

- (void)replaceItems:(NSArray *)oldItems withItems:(NSArray *)newItems animated:(BOOL)animated
{
    NSMutableArray *toolbarItems = [self.items mutableCopy];
    if (![oldItems isKindOfClass:[NSNull class]] && oldItems.count)
        [toolbarItems removeObjectsInArray:oldItems];
    if (![newItems isKindOfClass:[NSNull class]] && newItems.count)
        [toolbarItems addObjectsFromArray:newItems];
    [self setItems:toolbarItems animated:animated];
}


@end