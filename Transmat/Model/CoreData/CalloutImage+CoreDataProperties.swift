//
//  CalloutImage+CoreDataProperties.swift
//  Transmat
//
//  Created by Zach Smoroden on 2022-05-15.
//
//

import Foundation
import CoreData
import SwiftUI

extension CalloutImage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CalloutImage> {
        return NSFetchRequest<CalloutImage>(entityName: "CalloutImage")
    }

    @NSManaged public var url: URL?
    @NSManaged public var colorData: Data?
    @NSManaged public var imageData: Data?
    @NSManaged public var imageType: String

}

extension CalloutImage : Identifiable {
    var color: Color? {
        guard let data = colorData else { return nil }
        return try? JSONDecoder().decode(Color.self, from: data)
    }

    var image: UIImage? {
        guard let data = imageData else { return nil }
        return UIImage(data: data)
    }

    var type: ImageType? {
        ImageType(rawValue: imageType)
    }
}
