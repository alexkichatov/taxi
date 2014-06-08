//
//  TXAskPhoneNumberVC.m
//  Taxi
//
//  Created by Irakli Vashakidze on 4/9/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#import "TXAskPhoneNumberVC.h"
#import "TXAskUserInfoVC.h"
#import "TXUserModel.h"

@implementation CountryCodeItem
@synthesize name, code, image;
@end

@interface TXAskPhoneNumberVC () {
    NSMutableArray *items;
    CountryCodeItem *selectedItem;
}

-(IBAction)next:(id)sender;

@end

@implementation TXAskPhoneNumberVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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

    int userId = [[self->parameters objectForKey:API_JSON.OBJID] intValue];
    
    if([self.txtPhoneNumber.text length] > 0) {
    
        
        TXSyncResponseDescriptor *descriptor = [self->model updateMobile:userId mobile:self.txtPhoneNumber.text];
        
        if(descriptor.success) {
            
            TXAskUserInfoVC *viewController = [[TXAskUserInfoVC alloc] initWithNibName:@"TXAskUserInfoVC" bundle:nil];
            
            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:self->parameters];
            [params setObject:[NSString stringWithFormat:@"%@%@", self->selectedItem.code, self.txtPhoneNumber.text] forKey:API_JSON.SignUp.PHONENUMBER];
            [viewController setParameters:params];
            
            [self pushViewController:viewController];
            
        } else {
            
            [self alertError:@"Error" message:@"Mobile number is blocked !"];
            
        }
        
    }
    
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    self->selectedItem = self->items[row];
}

@end
