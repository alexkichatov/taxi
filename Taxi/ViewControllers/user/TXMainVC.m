//
//  TXMainVC.m
//  Taxi
//
//  Created by Irakli Vashakidze on 4/2/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import "TXMainVC.h"
#import "TXSignInVC.h"
#import "TXSignUpVC.h"

@interface TXMainVC ()

-(IBAction)signUp:(id)sender;
-(IBAction)signIn:(id)sender;

@end

@implementation TXMainVC

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)signIn:(id)sender {
    
    [self presentViewController:[[UIStoryboard storyboardWithName:@"Main_iPhone" bundle: nil] instantiateViewControllerWithIdentifier:@"SignInNavController"] animated:YES completion:nil];
  //  [self.navigationController pushViewController:[[UIStoryboard storyboardWithName:@"Main_iPhone" bundle: nil] instantiateViewControllerWithIdentifier:NSStringFromClass([TXSignInVC class])] animated:YES];
    
    /*
    [self pushViewControllerAndPopPrevious:^UIViewController *{
        return [[self->app iPhoneStoryBoard] instantiateViewControllerWithIdentifier:NSStringFromClass([TXSignInVC class])];
    } completionBlock:nil];
     */
}

-(void)signUp:(id)sender {
   
    [self presentViewController:[[UIStoryboard storyboardWithName:@"Main_iPhone" bundle: nil] instantiateViewControllerWithIdentifier:@"SignUpNavController"] animated:YES completion:nil];
    //[self.navigationController pushViewController:[[self->app iPhoneStoryBoard] instantiateViewControllerWithIdentifier:NSStringFromClass([TXSignUpVC class])] animated:YES];
    /*
    [self pushViewControllerAndPopPrevious:^UIViewController *{
        return [[self->app iPhoneStoryBoard] instantiateViewControllerWithIdentifier:NSStringFromClass([TXSignUpVC class])];
    } completionBlock:nil];
     */
}

@end
