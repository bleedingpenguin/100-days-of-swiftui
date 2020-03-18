//
//  Movie+CoreDataProperties.swift
//  CoreDataProject
//
//  Created by umam on 3/18/20.
//  Copyright © 2020 umam. All rights reserved.
//
//

import Foundation
import CoreData


extension Movie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }

    @NSManaged public var director: String?
    @NSManaged public var title: String?
    @NSManaged public var year: Int16

}
