#import "TXMenuItemObject.h"

@implementation TXMenuItemObject
{
    Class _observedClass;
    NSString *_observedAttribute;
}


#pragma mark - Initialization and memory management

- (id)initWithParentItem:(TXMenuItemObject *)aParentItem
{
    if ((self = [super init]))
    {
        self.parentItem = aParentItem;
    }
    return self;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Class methods


-(BOOL)isEqual:(id)object {
    TXMenuItemObject *compObject = (TXMenuItemObject *)object;
    return self.moduleType == compObject.moduleType;
}

@end