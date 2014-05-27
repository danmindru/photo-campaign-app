//
//  accountTextField.m
//  photoCampaign
//
//  Created by Dan Mindru on 11/05/14.
//  Copyright (c) 2014 Dan Mindru. All rights reserved.
//

#import "accountTextField.h"

@implementation accountTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
	return CGRectMake(bounds.origin.x + 10, bounds.origin.y + 8,
					  bounds.size.width - 20, bounds.size.height - 16);
}
- (CGRect)editingRectForBounds:(CGRect)bounds {
	return [self textRectForBounds:bounds];
}

@end
