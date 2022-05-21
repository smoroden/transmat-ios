//
//  UserSettings+Environment.swift
//  Transmat
//
//  Created by Zach Smoroden on 2022-05-11.
//

import SwiftUI

private struct DesignKey: EnvironmentKey {
    static let defaultValue: Design = Design()
}

extension EnvironmentValues {
    var design: Design {
        get { self[DesignKey.self] }
        set { self[DesignKey.self] = newValue }
    }
}

struct Design {
    let spacing: CGFloat = 8
}
