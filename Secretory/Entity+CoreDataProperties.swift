//
//  Entity+CoreDataProperties.swift
//  Secretory
//
//  Created by Ming Sun on 5/4/16.
//  Copyright © 2016 MingSun. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Entity {

    @NSManaged var date: String?
    @NSManaged var thing: String?

}
