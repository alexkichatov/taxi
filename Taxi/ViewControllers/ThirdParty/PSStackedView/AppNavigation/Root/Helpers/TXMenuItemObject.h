#import <Foundation/Foundation.h>

@interface TXMenuItemObject: NSObject
@property (nonatomic, strong) NSString *itemName;
@property (nonatomic, strong) NSArray *subItems;
@property (nonatomic, weak) TXMenuItemObject *parentItem;
@property (nonatomic, strong) Class controllerClass;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *sortSpect;
@property (nonatomic) BOOL isExpanded;
@property (nonatomic) NSInteger moduleType;
@property (nonatomic) NSInteger level;
- (id)initWithParentItem:(TXMenuItemObject *)aParentItem;
@end
