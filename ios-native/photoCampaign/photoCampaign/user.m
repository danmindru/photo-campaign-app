//
//  user.m
//  photoCampaign
//
//  Created by Dan Mindru on 09/05/14.
//  Copyright (c) 2014 Dan Mindru. All rights reserved.
//

#import "user.h"

@implementation user

- (id)initWithId:(NSString *)_id andEmail:(NSString *)email andFirstName:(NSString *)firstName andLastName:(NSString *)lastName andBio:(NSString *)bio andLevel:(NSString *)level andPhotoURL:(NSString *)photoURL andProvider:(NSString *)provider andUpdated:(NSString *)updated andCreated:(NSString *)created{
	self = [super init];
	if(self){
		self._id = _id;
		self.email = email;
		self.firstName = firstName;
		self.lastName = lastName;
		self.bio = bio;
		self.level = level;
		self.photoURL = photoURL;
		self.provider = provider;
		self.updated = updated;
		self.created = created;
	}
	
	return self;
}

- (void) encodeWithCoder: (NSCoder *) coder{
	[coder encodeObject:self._id forKey:@"_id"];
	[coder encodeObject:self.email forKey:@"email"];
	[coder encodeObject:self.firstName forKey:@"firstName"];
	[coder encodeObject:self.lastName forKey:@"lastName"];
	[coder encodeObject:self.bio forKey:@"bio"];
	[coder encodeObject:self.level forKey:@"level"];
	[coder encodeObject:self.photoURL forKey:@"photoURL"];
	[coder encodeObject:self.provider forKey:@"provider"];
	[coder encodeObject:self.updated forKey:@"updated"];
	[coder encodeObject:self.created forKey:@"created"];
}

- (id) initWithCoder: (NSCoder *) coder{
	self._id = [coder decodeObjectForKey:@"_id"];
	self.email = [coder decodeObjectForKey:@"email"];
	self.firstName = [coder decodeObjectForKey:@"firstName"];
	self.lastName = [coder decodeObjectForKey:@"lastName"];
	self.bio = [coder decodeObjectForKey:@"bio"];
	self.level = [coder decodeObjectForKey:@"level"];
	self.photoURL = [coder decodeObjectForKey:@"photoURL"];
	self.provider = [coder decodeObjectForKey:@"provider"];
	self.updated = [coder decodeObjectForKey:@"updated"];
	self.created = [coder decodeObjectForKey:@"created"];
	
	return self;
}

+ (NSString *) getPlistURL{
	NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsPath = [paths objectAtIndex:0];
	NSString *userURL = [documentsPath stringByAppendingPathComponent:@"user-data.plist"];
	
	return userURL;
}

#pragma read/write plist

- (void) saveToPlist:(NSString *)plistURL{
	//create a NSMutableDictionary to hold the items
	NSMutableDictionary *itemsHolder = [[NSMutableDictionary alloc] init];
	
	//first load the file contents
	//check if file exists
	BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:plistURL];
	
	if(fileExists){
		//write the current info in the dictionary
		itemsHolder = [NSKeyedUnarchiver unarchiveObjectWithFile:plistURL];
	}
	
	//add to dictionary
	//adding self as in the current instance of the user
	[itemsHolder setObject:self forKey:[NSString stringWithFormat:@"user"]];
	
	//save to file
	[NSKeyedArchiver archiveRootObject:itemsHolder toFile:plistURL];
	
}

//read file
+ (NSMutableArray *) readFromPlist:(NSString *)plistURL{
	NSMutableArray *loadedUserData = [[NSMutableArray alloc] init];
	
	//check if file exists first
	BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:plistURL];
	
	if(fileExists){
		
		NSMutableDictionary *userData = [[NSMutableDictionary alloc] init];
		//read values
		userData = [NSKeyedUnarchiver unarchiveObjectWithFile:plistURL];
		
		//if not empty
		if(userData != nil){
			//load the values of all postcards
			NSArray * finalUserData = [userData objectForKey:[NSString stringWithFormat:@"user"]];
			[loadedUserData addObject:finalUserData];
		}
	}
	
	return loadedUserData;
}

//remove from plist
+ (void) removeFromPlist:(NSString *)plistURL{
	NSMutableDictionary *itemsHolder = [[NSMutableDictionary alloc] init];
	
	//check if the file exists
	BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:plistURL];
	
	if(fileExists){
		//overwrite file with empty object
		[NSKeyedArchiver archiveRootObject:itemsHolder toFile:plistURL];
	}
}


@end
