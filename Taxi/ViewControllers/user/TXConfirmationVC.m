//
//  TXConfirmationVC.m
//  Taxi
//
//  Created by Irakli Vashakidze on 6/8/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import "TXConfirmationVC.h"
#import "TXMapVC.h"

@interface TXConfirmationVC () {
    int userId;
}

-(IBAction)submit:(id)sender;
-(IBAction)resend:(id)sender;

@end

@implementation TXConfirmationVC

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
    }
    
    return self;
}

-(void)viewDidLoad {
    
    [super viewDidLoad];
    self->userId = [[self->parameters objectForKey:API_JSON.ID] intValue];
}

-(void)submit:(id)sender {

    TXSyncResponseDescriptor *response = [self->model confirm:self->userId code:self.txtCodeInput.text];
    
    if(response.success == true) {
        
        TXMapVC* mainVC = [[TXMapVC alloc] initWithNibName:@"TXMapVC" bundle:nil];
        [self pushViewController:mainVC];
        
    } else {
        
        [self alertError:@"Error" message:@"Failed to confirm user !"];
        
    }
    
}

-(void)resend:(id)sender {
    
    int userId = [[self->parameters objectForKey:API_JSON.ID] intValue];
    TXSyncResponseDescriptor *response = [self->model resendVerificationCode:self->userId];
    
    
}

@end
