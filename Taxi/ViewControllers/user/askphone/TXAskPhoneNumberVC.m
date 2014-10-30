//
//  TXAskPhoneNumberVC.m
//  Taxi
//
//  Created by Irakli Vashakidze on 4/9/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import "TXAskPhoneNumberVC.h"
#import "TXAskUserInfoVC.h"
#import "TXConfirmationVC.h"
#import "TXUserModel.h"

@implementation CountryCodeItem
@synthesize name, code, image;
@end

@interface TXAskPhoneNumberVC () {
    NSMutableArray *items;
    CountryCodeItem *selectedItem;
    NSNumber *userId;
}

-(IBAction)next:(id)sender;

@end

@implementation TXAskPhoneNumberVC

-(void) configure {
    [super configure];
    [self registerEventListeners];
    [self configurePhoneNumbers];
    self->userId = [[[self->model getApp] getSettings] getUserId];
    [self.btnNext setTitle:self->userId!=nil ? @"Update mobile" : @"Proceed to confirm" forState:UIControlStateNormal];
}

-(void) configurePhoneNumbers {
    self->items = [NSMutableArray arrayWithCapacity:3];
    
    CountryCodeItem *item = [[CountryCodeItem alloc] init];
    item.name = @"Georgia";
    item.code = @"995";
    [self->items addObject:item];
    
    item = [[CountryCodeItem alloc] init];
    item.name = @"Azerbaijan";
    item.code = @"996";
    [self->items addObject:item];
    
    item = [[CountryCodeItem alloc] init];
    item.name = @"Armenia";
    item.code = @"997";
    [self->items addObject:item];
    
    self->selectedItem = self->items[0];
}

-(void) registerEventListeners {
    [self->model addEventListener:self forEvent:TXEvents.CREATEUSER eventParams:nil];
    [self->model addEventListener:self forEvent:TXEvents.UPDATEUSERMOBILE eventParams:nil];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
        return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self->items.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    CountryCodeItem *item = (CountryCodeItem*)self->items[row];
    
    return  [NSString stringWithFormat:@"%@ - %@", item.name, item.code];
}

-(void)next:(id)sender {
    
    if([self.txtPhoneNumber.text length] > 0) {
        
        if(self->userId == nil) {
            
            TXUser *user = [[TXUser alloc] init];
            user.username = [self->parameters objectForKey:API_JSON.Authenticate.USERNAME];
            user.password = [self->parameters objectForKey:API_JSON.Authenticate.PASSWORD];
            user.mobile   = self.txtPhoneNumber.text;
            user.language = @"ka";
            
            [self showBusyIndicator:@"Completing sign up ... "];
            [self->model signUp:user];
            
        } else {
            
            [self showBusyIndicator:@"Updating mobile ... "];
            [self->model updateMobile:[self->userId intValue] mobile:self.txtPhoneNumber.text];
            
        }
    
    }
    
}

-(void) pushConfirmationVC:(TXResponseDescriptor *) descriptor {
    TXConfirmationVC *confirmationVC = [[TXConfirmationVC alloc] initWithNibName:@"TXConfirmationVC" bundle:nil];
    NSDictionary*source = (NSDictionary*)descriptor.source;
    [confirmationVC setParameters:@{ API_JSON.ID : [source objectForKey:API_JSON.ID] }];
    [self pushViewController:confirmationVC];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    self->selectedItem = self->items[row];
}

-(void)onEvent:(TXEvent *)event eventParams:(id)subscriptionParams {
    
    [self hideBusyIndicator];
    TXResponseDescriptor *descriptor = [event getEventProperty:TXEvents.Params.DESCRIPTOR];
    
    if(descriptor.success) {
        
        TXConfirmationVC *confirmationVC = [[TXConfirmationVC alloc] initWithNibName:@"TXConfirmationVC" bundle:nil];
        NSDictionary*source = (NSDictionary*)descriptor.source;
        [[[self->model getApp] getSettings] setUserId:[source objectForKey:API_JSON.ID]];
        [self pushViewController:confirmationVC];
        
    } else {
        NSString *message = [TXCode2MsgTranslator messageForCode:descriptor.code];
        [self alertError:@"Error" message:message];
    }

}

@end
