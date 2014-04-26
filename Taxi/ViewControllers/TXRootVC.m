//
//  TXRootVC.m
//  Taxi
//
//  Created by Irakli Vashakidze on 3/2/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import "TXRootVC.h"
#import "TXUserModel.h"

@interface TXRootVC ()

@end

@implementation TXRootVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.sharedObj = [TXSharedObj instance];
    self.model = [TXUserModel instance];
    [self.model addEventListener:self forEvent:TXEvents.REGISTER_USER_COMPLETED eventParams:nil];
    [self.model addEventListener:self forEvent:TXEvents.CHECK_USER_COMPLETED eventParams:nil];
	self.view.userInteractionEnabled = TRUE;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 * By default all the view controllers disable auto rotation,
 * if any UI view wants to display UI controls in landscape orientation, view controller must override this function
 */
-(BOOL)shouldAutorotate {
    return NO;
}

/*
 * By default all the view controllers handle touchesBegan to hide keyboard when it is not necessary,
 * If any UI view wants to force keyboard to be displayed permanently, it's controller should override this function
 */
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self view] endEditing:YES];
}

- (IBAction)backgroundTouched:(id)sender {
    [self.view endEditing:YES];
}

/*
 * Sets the model to the controller
 */
-(void)setModel:(TXModelBase *) model_ eventNames:(NSArray *) eventNames {
    self.model = model_;
    for (NSString *evtName in eventNames) {
        [self.model addEventListener:self forEvent:evtName eventParams:nil];
    }
}

-(void) pushViewController : (TXRootVC *) viewController {
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.25;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    
    [self.view.layer addAnimation:transition forKey:kCATransition];
    [self presentViewController:viewController animated:YES completion:nil];
    
}

-(TXRootVC *) viewControllerInstanceWithName: (NSString *) name {
    return [[self.sharedObj currentStoryBoard] instantiateViewControllerWithIdentifier:name];
}

-(TXRootVC *) viewControllerInstanceFromClass: (Class) aClass {
    return [[self.sharedObj currentStoryBoard] instantiateViewControllerWithIdentifier:NSStringFromClass(aClass)];
}

-(void) alertError : (NSString *) title message : (NSString *) message {
    
    [[[UIAlertView alloc] initWithTitle:title
                                message:message
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
    
}

-(void) setParameters:(NSDictionary *)params {
    self->parameters = params;
}

/*
 * Subclasses should override this function
 */
-(void)onEvent:(TXEvent *)event eventParams:(id)subscriptionParams{
    NSLog(@"Function onEvent not implemented in TXRootVC !");
}


-(void)refreshInterfaceBasedOnSignIn {
    NSLog(@"Function refreshInterfaceBasedOnSignIn not implemented in TXRootVC !");
}

@end
