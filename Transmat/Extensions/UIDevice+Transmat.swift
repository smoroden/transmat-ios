//
//  UIDevice+Transmat.swift
//  Transmat
//
//  Created by Zach Smoroden on 2022-05-04.
//

import UIKit

extension UIDevice {
    static var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }

    static var isIPhone: Bool {
        UIDevice.current.userInterfaceIdiom == .phone
    }

    static var isSimulator: Bool {
        #if IOS_SIMULATOR
            return true
        #else
            return false
        #endif
    }
}
