//
//  FDKeyChain.m
//  Taxi
//
//  Created by Irakli Vashakidze on 2/22/14.
//  Copyright (c) 2014 99S. All rights reserved.
//

#ifndef AMDCom_FDNullOrEmpty_h
#define AMDCom_FDNullOrEmpty_h

static inline BOOL FDIsNull(id object)
{
	return ( object == nil || object == [NSNull null]);
}

static inline BOOL FDIsEmpty(id object)
{
	// Check if the object is null or if the object responds to the length or count selector and is zero.
	BOOL isEmpty = NO;
	
	if (FDIsNull(object) == YES
		|| ([object respondsToSelector: @selector(length)]
			&& [object length] == 0)
		|| ([object respondsToSelector: @selector(count)]
			&& [object count] == 0))
	{
		isEmpty = YES;
	}
	
	return isEmpty;
}

#endif
