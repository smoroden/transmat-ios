//
//  Color+Transmat.swift
//  Transmat
//
//  Created by Zach Smoroden on 2022-05-14.
//

import SwiftUI

extension Color: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let uicolordata = try container.decode(Data.self)
        let uicolor = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: uicolordata)

        self.init(uiColor: uicolor!)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        let convert = UIColor(self)
        let colorData = try NSKeyedArchiver.archivedData(withRootObject: convert, requiringSecureCoding: false)
        try container.encode(colorData)
    }
}
