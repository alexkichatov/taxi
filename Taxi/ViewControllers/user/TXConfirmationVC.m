//
//  TXConfirmationVC.m
//  Taxi
//
//  Created by Irakli Vashakidze on 6/8/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import "TXConfirmationVC.h"

@interface TXConfirmationVC () {
    int userId;
}

-(IBAction)submit:(id)sender;
-(IBAction)resend:(id)sender;

@end

@implementation TXConfirmationVC

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self->userId = [[self->parameters objectForKey:API_JSON.ID] intValue];
    }
    
    return self;
}

-(void)submit:(id)sender {

    TXSyncResponseDescriptor *response = [self->model confirm:self->userId code:self.txtCodeInput.text];
    
    
    
    
}

-(void)resend:(id)sender {
    
    int userId = [[self->parameters objectForKey:API_JSON.ID] intValue];
    TXSyncResponseDescriptor *response = [self->model resendVerificationCode:self->userId];
    
    
}

@end
