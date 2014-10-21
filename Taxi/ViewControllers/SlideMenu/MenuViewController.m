//
//  MenuViewController.m
//  SlideMenu
//
//  Created by Aryan Gh on 4/24/13.
//  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
//

#import "MenuViewController.h"
#import "SlideNavigationContorllerAnimatorFade.h"
#import "SlideNavigationContorllerAnimatorSlide.h"
#import "SlideNavigationContorllerAnimatorScale.h"
#import "SlideNavigationContorllerAnimatorScaleAndFade.h"
#import "SlideNavigationContorllerAnimatorSlideAndFade.h"
#import "StrConsts.h"
#import "TXSharedObj.h"

int const MENU_ITEMS_COUNT = 4;

@implementation TXSettingsMenuItem
@synthesize title, image, vc;

+(id) create:(NSString *) title image:(NSString *) image viewController:(NSString *)vc {
    return [[self alloc] initWithProperties:title image:image viewController:vc];
}

-(id)initWithProperties:(NSString *) title_ image:(NSString *) image_ viewController:(NSString *)vc_ {
    
    if(self = [super init]) {
        
        self.title = title_;
        self.image = [UIImage imageNamed:image_];
        self.vc = [[[TXSharedObj instance] currentStoryBoard] instantiateViewControllerWithIdentifier:vc_];
    }
    
    return self;
    
}

@end

@interface MenuViewController() {
    NSMutableArray *items;
}

@end

@implementation MenuViewController
@synthesize cellIdentifier;

-(void)viewDidLoad {
    
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:@"MenuTableViewCell" bundle:nil];
    self.cellIdentifier = @"leftMenuCell";
    [self.tableView registerNib:nib forCellReuseIdentifier:self.cellIdentifier];
    
    self->items = [NSMutableArray arrayWithCapacity:MENU_ITEMS_COUNT];
    
    TXSettingsMenuItem *item = [TXSettingsMenuItem create:LEFT_MENU.Names.HOME
                                                   image:LEFT_MENU.Images.HOME
                                                   viewController:LEFT_MENU.Controllers.HOME];
    
    [items addObject:item];
    
    item = [TXSettingsMenuItem create:LEFT_MENU.Names.PROFILE
                                image:LEFT_MENU.Images.PROFILE
                       viewController:LEFT_MENU.Controllers.PROFILE];
    
    [items addObject:item];
    
    item = [TXSettingsMenuItem create:LEFT_MENU.Names.SETTINGS
                                image:LEFT_MENU.Images.SETTINGS
                       viewController:LEFT_MENU.Controllers.SETTINGS];
    
    [items addObject:item];
    
    item = [TXSettingsMenuItem create:LEFT_MENU.Names.SIGNOUT
                                image:LEFT_MENU.Images.SIGNOUT
                       viewController:LEFT_MENU.Controllers.SIGNOUT];
    
    [items addObject:item];
    
    
}

#pragma mark - UITableView Delegate & Datasrouce -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self->items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
	
    TXSettingsMenuItem *item = self->items[indexPath.row];
    ((UILabel *)[cell.contentView viewWithTag:1]).text = item.title;
    ((UIImageView*)[cell.contentView viewWithTag:2]).image = item.image;
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
	if (indexPath.section == 0)
	{
		UIViewController *vc ;
		
		switch (indexPath.row)
		{
			case 0:
				//vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"HomeViewController"];
				break;
			
		}
		
		[[SlideNavigationController sharedInstance] switchToViewController:vc withCompletion:nil];
	}
	else
	{
		id <SlideNavigationContorllerAnimator> revealAnimator;
		
		switch (indexPath.row)
		{
			case 0:
				revealAnimator = nil;
				break;
				
			case 1:
				revealAnimator = [[SlideNavigationContorllerAnimatorSlide alloc] init];
				break;
				
			case 2:
				revealAnimator = [[SlideNavigationContorllerAnimatorFade alloc] init];
				break;
				
			case 3:
				revealAnimator = [[SlideNavigationContorllerAnimatorSlideAndFade alloc] initWithMaximumFadeAlpha:.7 fadeColor:[UIColor purpleColor] andSlideMovement:100];
				break;
				
			case 4:
				revealAnimator = [[SlideNavigationContorllerAnimatorScale alloc] init];
				break;
				
			case 5:
				revealAnimator = [[SlideNavigationContorllerAnimatorScaleAndFade alloc] initWithMaximumFadeAlpha:.6 fadeColor:[UIColor blueColor] andMinimumScale:.7];
				break;
				
			default:
				return;
		}
		
		[[SlideNavigationController sharedInstance] closeMenuWithCompletion:^{
			[SlideNavigationController sharedInstance].menuRevealAnimator = revealAnimator;
		}];
	}
}

@end
