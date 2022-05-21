//
//  LocalCallout.swift
//  Transmat
//
//  Created by Zach Smoroden on 2022-05-04.
//

import Foundation
import SwiftUI
import CoreData

enum LocalCallout: String, Identifiable, CaseIterable {
    case redacted
    case ascendantPlane = "ascendant_plane"
    case blackGarden = "black_garden"
    case blackHeart = "black_heart"
    case commune
    case darkness
    case drink
    case earth
    case enter
    case fleet
    case give
    case grieve
    case guardian
    case hive
    case light
    case love
    case pyramid
    case remember
    case savathun
    case scorn
    case stop
    case tower
    case traveler
    case witness
    case worm
    case worship

    var id: String { rawValue }

    func callout(_ context: NSManagedObjectContext?) -> Callout {
        let base: Callout
        let image: CalloutImage

        if let context = context {
            base = Callout(context: context)
            image = CalloutImage(context: context)
        } else {
            base = Callout()
            image = CalloutImage()
        }

        switch self {
        case .redacted:
            base.action = "---------"
            base.display = "Next"
            image.imageType = ImageType.localImage.rawValue
            image.imageData = UIImage(named: rawValue)?.pngData()
            base.image = image
        case .ascendantPlane:
            base.action = "Ascendant Plane"
            base.display = "Ascendant Plane"
            image.imageType = ImageType.localImage.rawValue
            image.imageData = UIImage(named: rawValue)?.pngData()
            base.image = image
        case .blackGarden:
            base.action = "Black Garden"
            base.display = "Black Garden"
            image.imageType = ImageType.localImage.rawValue
            image.imageData = UIImage(named: rawValue)?.pngData()
            base.image = image
        case .blackHeart:
            base.action = "Black Heart"
            base.display = "Black Heart"
            image.imageType = ImageType.localImage.rawValue
            image.imageData = UIImage(named: rawValue)?.pngData()
            base.image = image
        default:
            base.action = rawValue.capitalized
            base.display = rawValue.capitalized
            image.imageType = ImageType.localImage.rawValue
            image.imageData = UIImage(named: rawValue)?.pngData()
            base.image = image
        }

        return base
    }
}
