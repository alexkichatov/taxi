
#import "TXMenuCell.h"
#import "TXMenuItemObject.h"
#import "UIView+PSSizes.h"


@interface TXMenuCell()
@property (weak, nonatomic) IBOutlet UILabel *menuTitleLabel;
@property (nonatomic, weak) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, weak) IBOutlet UIImageView *expandIconImageView;
@property (nonatomic, copy) NSString *cellName;
@property (nonatomic, strong) TXMenuItemObject *menuObject;
@end

@implementation TXMenuCell
{
    __weak UILabel * _label;
    NSInteger _badgeNumber;
}
@synthesize iconImageView = _iconImageView;
@synthesize menuTitleLabel = _menuTitleLabel;
@synthesize backgroundImageView = _backgroundImageView;
@synthesize cellName = _cellName;
@synthesize expandIconImageView = _expandIconImageView;
@synthesize delegate = _delegate;
@synthesize badgeNumber = _badgeNumber;
@synthesize customBGColor;


#pragma mark - Initialization and memory management

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self configureCellBackground];
    }
    return self;
}

- (void)awakeFromNib
{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(expandIconIsTapped:)];
    [self.expandIconImageView addGestureRecognizer:tapGestureRecognizer];
}

#pragma mark - Action handlers

- (void)expandIconIsTapped:(UITapGestureRecognizer *)tapGesture
{
    self.menuObject.isExpanded = !self.menuObject.isExpanded;
    [_delegate menuCell:self menuItemExpandingChanged:self.menuObject];
}

#pragma mark - Appearance

-(void)bgConfigForState:(BOOL)selected{
    NSString *backgroundImageName = selected?@"menu-bar-bg-active.png":(customBGColor?nil:@"menu-bar-bg-inactive.png");
    NSString *iconName = [NSString stringWithFormat:@"menu_icon_%@_%@.png", _cellName.lowercaseString, self.isSelected?@"blue":@"grey"];
    self.backgroundImageView.image = backgroundImageName?[[UIImage imageNamed:backgroundImageName] resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 2, 2)]: nil;
    self.iconImageView.image = [UIImage imageNamed:iconName];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [self bgConfigForState:selected];
    [super setSelected:selected animated:animated];
}

- (void)setMenuItemTitle:(NSString *)title
{
    self.cellName = title;
    self.menuTitleLabel.text = title;
}

- (void)updateCellUI
{
    [self setMenuItemTitle:self.menuObject.itemName];
    self.expandIconImageView.hidden = [[self.menuObject subItems] count] == 0;
    self.expandIconImageView.image = [UIImage imageNamed:(self.menuObject.isExpanded?@"disclosureUp.png":@"disclosureDown.png")];
}


- (void)configureWithMenuItem:(TXMenuItemObject*)itemObject
{
    self.menuObject = itemObject;
    [self updateCellUI];
}

- (void)configureCellBackground
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.backgroundImageView = imageView;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    imageView.image = [[UIImage imageNamed:@"menu-bar-bg-inactive.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
    self.menuTitleLabel.textColor = [UIColor whiteColor];
    [self insertSubview:imageView atIndex:0];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.iconImageView.contentMode = UIViewContentModeCenter;
}

@end
