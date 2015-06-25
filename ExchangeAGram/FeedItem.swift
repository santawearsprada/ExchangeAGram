//
//  FeedItem.swift
//  ExchangeAGram
//
//  Created by SANTIPONG TANCHATCHAWAL on 6/25/15.
//  Copyright (c) 2015 SANTIPONG TANCHATCHAWAL. All rights reserved.
//

import Foundation
import CoreData

@objc(FeedItem)
class FeedItem: NSManagedObject {

    @NSManaged var caption: String
    @NSManaged var image: NSData

}
