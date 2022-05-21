//
//  LocalCalloutService.swift
//  Transmat
//
//  Created by Zach Smoroden on 2022-05-09.
//

import Foundation
import CoreData

final class LocalCalloutService: CalloutService {
    let container = NSPersistentContainer(name: "Callout")

    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
}
