//
//  ImageType.swift
//  Transmat
//
//  Created by Zach Smoroden on 2022-05-15.
//

import SwiftUI

enum ImageType: String, CaseIterable, Hashable, Identifiable, Codable {
    case localImage = "image-type-local"
    case networkImage = "image-type-network"
    case color = "image-type-color"

    var localizedKey: LocalizedStringKey {
        LocalizedStringKey(rawValue)
    }

    var id: String { rawValue }
}
