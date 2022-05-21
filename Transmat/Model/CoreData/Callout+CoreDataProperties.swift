//
//  Callout+CoreDataProperties.swift
//  Transmat
//
//  Created by Zach Smoroden on 2022-05-15.
//
//

import Foundation
import CoreData


extension Callout {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Callout> {
        return NSFetchRequest<Callout>(entityName: "Callout")
    }

    @NSManaged public var action: String
    @NSManaged public var display: String
    @NSManaged public var image: CalloutImage

}

extension Callout : Identifiable {

}
