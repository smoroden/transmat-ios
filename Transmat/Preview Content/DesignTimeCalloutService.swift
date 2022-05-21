//
//  DesignTimeCalloutService.swift
//  Transmat
//
//  Created by Zach Smoroden on 2022-05-09.
//

import Foundation
import CoreData

class DesignTimeCalloutService: CalloutService {
    let container = NSPersistentContainer(name: "Callout")
    lazy var page = CalloutPage.vowOfDisciple((container.viewContext))

    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                debugPrint("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
}
