//
//  post.m
//  photoCampaign
//
//  Created by Dan Mindru on 13/05/14.
//  Copyright (c) 2014 Dan Mindru. All rights reserved.
//

#import "post.h"

@implementation post

- (id)initWithId:(NSString *)_id andCampaignIdentifier:(NSString *)campaignIdentifier andTitle:(NSString *)title andDescription:(NSString *)description andPhotoURL:(NSString *)photoURL andCreated:(NSString *)created{
	
	self = [super init];
	
	if(self){
		self._id = _id;
		self.campaignIdentifier = campaignIdentifier;
		self.title = title;
		self.description = description;
		self.photoURL = photoURL;
		self.created = created;
	}
	
	return self;
}


- (void) encodeWithCoder: (NSCoder *) coder{
	[coder encodeObject:self._id forKey:@"_id"];
	[coder encodeObject:self.campaignIdentifier forKey:@"campaignIdentifier"];
	[coder encodeObject:self.title forKey:@"title"];
	[coder encodeObject:self.description forKey:@"description"];
	[coder encodeObject:self.photoURL forKey:@"photoURL"];
	[coder encodeObject:self.created forKey:@"created"];
}

- (id) initWithCoder: (NSCoder *) coder{
	self._id = [coder decodeObjectForKey:@"_id"];
	self.campaignIdentifier = [coder decodeObjectForKey:@"campaignIdentifier"];
	self.title = [coder decodeObjectForKey:@"title"];
	self.description = [coder decodeObjectForKey:@"description"];
	self.photoURL = [coder decodeObjectForKey:@"photoURL"];
	self.created = [coder decodeObjectForKey:@"created"];
	
	return self;
}

+ (NSString *) getPlistURL{
	NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsPath = [paths objectAtIndex:0];
	NSString *projectURL = [documentsPath stringByAppendingPathComponent:@"post-feed-data.plist"];
	
	return projectURL;
}

#pragma read/write plist

- (void) saveToPlist:(NSString *)plistURL{
	//create a NSMutableDictionary to hold the items
	NSMutableDictionary *itemsHolder = [[NSMutableDictionary alloc] init];
	
	//convert the DB datetime into timestamp
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
	NSDate *postCreatedDate = [dateFormatter dateFromString:self.created];
	
	
	NSDateFormatter *prettyDateFormatter = [[NSDateFormatter alloc] init];
	[prettyDateFormatter setDateFormat:@"yyyyMMddHHmm"];
	NSString *postTimestamp = [prettyDateFormatter stringFromDate:postCreatedDate];
	
	//first load the file contents
	//check if file exists
	BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:plistURL];
	
	if(fileExists){
		//write the current info in the dictionary
		itemsHolder = [NSKeyedUnarchiver unarchiveObjectWithFile:plistURL];
		
		if(![itemsHolder valueForKey:self._id]){
			//add to dictionary only if not already present
			//adding self as in the current instance of the post
			[itemsHolder setObject:self forKey:[NSString stringWithFormat:@"%@%@", postTimestamp, self._id]];
		}
	}
	else{
		//add to dictionary (empty)
		[itemsHolder setObject:self forKey:[NSString stringWithFormat:@"%@%@", postTimestamp, self._id]];
	}
	
	//save to file
	[NSKeyedArchiver archiveRootObject:itemsHolder toFile:plistURL];
	
}

//read file
+ (NSMutableArray *) readFromPlist:(NSString *)plistURL{
	NSMutableArray *loadedPosts = [[NSMutableArray alloc] init];
	
	//check if file exists first
	BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:plistURL];
	
	if(fileExists){
		
		NSMutableDictionary *allPosts = [[NSMutableDictionary alloc] init];
		//read values
		allPosts= [NSKeyedUnarchiver unarchiveObjectWithFile:plistURL];
		
		//if not empty
		if(allPosts != nil){
			//load the values of all posts
			NSArray * loadedValues = allPosts.allValues;
			
			//save to the array that will be returned
			for (post *onePost in loadedValues) {
				[loadedPosts addObject:onePost];
			}
		}
	}
	
	return loadedPosts;
}

//clear plist file
+ (void) removeAllPosts:(NSString *)plistURL{
	NSMutableDictionary *itemsHolder = [[NSMutableDictionary alloc] init];
	
	//save to file
	[NSKeyedArchiver archiveRootObject:itemsHolder toFile:plistURL];
}

@end
