//
//  CalloutService.swift
//  Transmat
//
//  Created by Zach Smoroden on 2022-05-09.
//

import Foundation
import CoreData

/// Gathers callout pages from a source
protocol CalloutService: ObservableObject {
    var container: NSPersistentContainer { get }
}
