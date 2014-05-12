//
//  user.h
//  photoCampaign
//
//  Created by Dan Mindru on 09/05/14.
//  Copyright (c) 2014 Dan Mindru. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface user : NSObject

@property (strong, nonatomic) NSString *_id;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *bio;
@property (strong, nonatomic) NSString *level;
@property (strong, nonatomic) NSString *photoURL;
@property (strong, nonatomic) NSString *provider;
@property (strong, nonatomic) NSString *updated;
@property (strong, nonatomic) NSString *created;

- (id)initWithId:(NSString *)_id andEmail:(NSString *)email andFirstName:(NSString *)firstName andLastName:(NSString *)lastName andBio:(NSString *)bio andLevel:(NSString *)level andPhotoURL:(NSString *)photoURL andProvider:(NSString *)provider andUpdated:(NSString *)updated andCreated:(NSString *)created;
- (void) saveToPlist:(NSString *)plistURL;
+ (void) removeFromPlist:(NSString *)plistURL;
+ (NSMutableArray *)readFromPlist:(NSString *)plistURL;
+ (NSString *) getPlistURL;

@end
