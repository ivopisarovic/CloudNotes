//
//  Notebook.h
//  CloudNotes
//
//  Created by Tim Pryor on 2015-12-15.
//  Copyright (c) 2015 Tim Pryor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NSManagedObject;

@interface Notebook : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSSet *note;
@end

@interface Notebook (CoreDataGeneratedAccessors)

- (void)addNoteObject:(NSManagedObject *)value;
- (void)removeNoteObject:(NSManagedObject *)value;
- (void)addNote:(NSSet *)values;
- (void)removeNote:(NSSet *)values;

@end
