
#import "TXIndeterminateProgressViewController.h"

@interface TXIndeterminateProgressViewController ()
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *progressIndicator;
@end

@implementation TXIndeterminateProgressViewController
{
    NSString *_message;
    BOOL _isRunning;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setImageForOrientation:self.interfaceOrientation];
    self.statusLabel.text = _message;
    _isRunning?[self.progressIndicator startAnimating]:[self.progressIndicator stopAnimating];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self setImageForOrientation:toInterfaceOrientation];
}

- (void)setImageForOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    NSString *imageName = UIInterfaceOrientationIsPortrait(interfaceOrientation)?@"Default-Portrait.png":@"Default-Landscape.png";
    self.backgroundImageView.image = [UIImage imageNamed:imageName];
}

- (void)startProgressWithMessage:(NSString *)message
{
    _isRunning = YES;
    [self updateStatusMessage:message];
    if (!self.progressIndicator.isAnimating)
        [self.progressIndicator startAnimating];
}

- (void)stopProgressWithMessage:(NSString *)message
{
    _isRunning = NO;
    [self updateStatusMessage:message];
    if (self.progressIndicator.isAnimating)
        [self.progressIndicator stopAnimating];
}

- (void)updateStatusMessage:(NSString *)message
{
    _message = message;
    self.statusLabel.text = message;
}

- (BOOL)includeInStats
{
    return NO;
}

@end
