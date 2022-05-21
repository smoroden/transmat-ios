//
//  View+Transmat.swift
//  Transmat
//
//  Created by Zach Smoroden on 2022-05-11.
//

import SwiftUI

extension View {
    func gridItems(height: Int, width: Int, itemCount: Int, padding: Int) -> [GridItem] {
        guard itemCount > 0 else {
            return [GridItem(.fixed(10))]
        }
        var resultColumnCount = itemCount
        var resultItemSize = height

        for columnCount in 1...itemCount {
            let itemSize = (width / columnCount) - padding
            let rows = Int(ceilf(Float(itemCount) / Float(columnCount)))

            if itemSize * rows < height - padding * rows {
                resultItemSize = itemSize
                resultColumnCount = columnCount
                break
            }
        }

        return Array(repeating: GridItem(.fixed(CGFloat(resultItemSize))), count: resultColumnCount)
    }
}
