//
//  DesignTimeIAPService.swift
//  Transmat
//
//  Created by Zach Smoroden on 2022-05-20.
//

import Foundation
import StoreKit
import Combine

final class DesignTimeIAPService: IAPService {
    var cancellables = Set<AnyCancellable>()

    @Published var products: [SKProduct] = [
        DesignTimeProduct(title: "Tea for Zach",
                          description: "Just a tip to say thanks",
                          price: NSDecimalNumber(1.99)),
        DesignTimeProduct(title: "Burrito for Zach",
                          description: "Just a tip to say thanks",
                          price: NSDecimalNumber(5.99)),
    ]

    @Published var transactionState: SKPaymentTransactionState?
    @Published var purchasing: SKProduct?

    func getProducts() {
        debugPrint("got products")
    }

    func purchase(_ product: SKProduct) {
        transactionState = .purchasing
        purchasing = product

        Just(1)
            .delay(for: .seconds(3), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.transactionState = .purchased
                self?.purchasing = nil
            }.store(in: &cancellables)
    }
}

class DesignTimeProduct: SKProduct {
    private let _title: String
    private let _description: String
    private let _price: NSDecimalNumber

    init(title: String, description: String, price: NSDecimalNumber) {
        _title = title
        _description = description
        _price = price
    }

    override var localizedTitle: String {
        _title
    }

    override var localizedDescription: String {
        _description
    }

    override var price: NSDecimalNumber {
        _price
    }

    override var priceLocale: Locale {
        .current
    }
}
