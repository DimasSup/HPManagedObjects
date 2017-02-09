//
//  BaseManagedObjectModel+FMDB.h
//  Little Pal
//
//  Created by admin on 21.06.16.
//  Copyright © 2016 BrillKids. All rights reserved.
//

#import "BaseManagedObjectModel.h"
@import FMDB;

@interface BaseManagedObjectModel (FMDB)
/*!
 *  @brief  Update current instance with FMResultSet
 *
 *  @param resultSet FMResultSet (FMDatabase class which contain row info)
 */
- (nonnull instancetype)updateFromDbSet:(FMResultSet*_Nonnull)resultSet;
@end
