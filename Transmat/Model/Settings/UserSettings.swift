//
//  UserSettings.swift
//  Transmat
//
//  Created by Zach Smoroden on 2022-05-11.
//

import SwiftUI

class UserSettings: ObservableObject {
    @AppStorage(wrappedValue: false, "displayLabels") var displayLabels
    @ AppStorage(wrappedValue: 1.0, "textScale") var textScale

    init(displayLabels: Bool? = nil,
         textScale: Double? = nil) {
        if let displayLabels = displayLabels {
            self.displayLabels = displayLabels
        }

        if let textScale = textScale {
            self.textScale = textScale
        }
    }
}
