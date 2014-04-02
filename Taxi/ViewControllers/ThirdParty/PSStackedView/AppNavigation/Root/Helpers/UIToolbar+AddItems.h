#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIToolbar (AddItems)
- (void) insertItem:(UIBarItem *)barItem atIndex:(NSUInteger)index animated:(BOOL)animated;
- (void) removeItemAtIndex:(NSUInteger)index animated:(BOOL)animated;

- (void)removeItem:(UIBarItem *)barItem animated:(BOOL)animated;
- (void) pushLeftItem:(UIBarItem *)barItem animated:(BOOL)animated;
- (void) popLeftItemAnimated:(BOOL)animated;
- (void) pushRightItem:(UIBarItem *)barItem animated:(BOOL)animated;
- (void) popRightItemAnimated:(BOOL)animated;
- (void) appendItems:(NSArray *)barItems animated:(BOOL)animated;
- (void) popItemsFromIndex:(NSUInteger)index1 animated:(BOOL)animated;
- (void) popItems:(NSArray *)barItems animated:(BOOL)animated;
- (void) replaceItems:(NSArray *)oldItems withItems:(NSArray *)newItems animated:(BOOL)animated;

@end