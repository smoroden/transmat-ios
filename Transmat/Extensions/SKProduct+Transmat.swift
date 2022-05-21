//
//  SKProduct+Transmat.swift
//  Transmat
//
//  Created by Zach Smoroden on 2022-05-20.
//

import StoreKit

extension SKProduct {
    func localizedPrice() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = self.priceLocale
        return formatter.string(from: self.price) ?? "N/A"
    }

}
