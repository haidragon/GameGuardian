//
//  Player+CoreDataProperties.swift
//  GameKeeper
//
//  Created by phil on 4/19/17.
//  Copyright © 2017 Brook Street Games. All rights reserved.
//

import Foundation
import CoreData


extension Player {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Player> {
        return NSFetchRequest<Player>(entityName: "Player");
    }

    @NSManaged public var name: String
    @NSManaged public var score: Int64

}
