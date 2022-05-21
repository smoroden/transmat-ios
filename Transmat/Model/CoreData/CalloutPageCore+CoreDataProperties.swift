//
//  CalloutPage+CoreDataProperties.swift
//  Transmat
//
//  Created by Zach Smoroden on 2022-05-15.
//
//

import Foundation
import CoreData


extension CalloutPage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CalloutPage> {
        return NSFetchRequest<CalloutPage>(entityName: "CalloutPage")
    }

    @NSManaged public var title: String
    @NSManaged public var callouts: NSOrderedSet

}

// MARK: Generated accessors for callouts
extension CalloutPage {

    @objc(insertObject:inCalloutsAtIndex:)
    @NSManaged public func insertIntoCallouts(_ value: Callout, at idx: Int)

    @objc(removeObjectFromCalloutsAtIndex:)
    @NSManaged public func removeFromCallouts(at idx: Int)

    @objc(insertCallouts:atIndexes:)
    @NSManaged public func insertIntoCallouts(_ values: [Callout], at indexes: NSIndexSet)

    @objc(removeCalloutsAtIndexes:)
    @NSManaged public func removeFromCallouts(at indexes: NSIndexSet)

    @objc(replaceObjectInCalloutsAtIndex:withObject:)
    @NSManaged public func replaceCallouts(at idx: Int, with value: Callout)

    @objc(replaceCalloutsAtIndexes:withCallouts:)
    @NSManaged public func replaceCallouts(at indexes: NSIndexSet, with values: [Callout])

    @objc(addCalloutsObject:)
    @NSManaged public func addToCallouts(_ value: Callout)

    @objc(removeCalloutsObject:)
    @NSManaged public func removeFromCallouts(_ value: Callout)

    @objc(addCallouts:)
    @NSManaged public func addToCallouts(_ values: NSOrderedSet)

    @objc(removeCallouts:)
    @NSManaged public func removeFromCallouts(_ values: NSOrderedSet)

}

extension CalloutPage : Identifiable {
    var calloutsArray: [Callout] {
        callouts.array as? [Callout] ?? []
    }

    static func vowOfDisciple(_ context: NSManagedObjectContext?) -> CalloutPage {
        let page: CalloutPage
        if let context = context {
            page = CalloutPage(context: context)
        } else {
            page = CalloutPage()
        }
        page.insertIntoCallouts(LocalCallout.allCases.map { $0.callout(context) }, at: NSIndexSet(index: 0))
        page.title = "Vow of the Disciple"
        return page
    }
}
