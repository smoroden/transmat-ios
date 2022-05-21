//
//  Image+Transmat.swift
//  Transmat
//
//  Created by Zach Smoroden on 2022-05-04.
//

import SwiftUI

extension Image {
    init(_ icon: LocalCallout) {
        self.init(icon.rawValue)
    }
}
