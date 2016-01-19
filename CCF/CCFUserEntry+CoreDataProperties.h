//
//  CCFUserEntry+CoreDataProperties.h
//  CCF
//
//  Created by WDY on 16/1/19.
//  Copyright © 2016年 andforce. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CCFUserEntry.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCFUserEntry (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *userAvatar;
@property (nullable, nonatomic, retain) NSString *userID;

@end

NS_ASSUME_NONNULL_END
