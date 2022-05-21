//
//  IAPService.swift
//  Transmat
//
//  Created by Zach Smoroden on 2022-05-20.
//

import Foundation
import StoreKit

protocol IAPService: ObservableObject {
    func getProducts()
    func purchase(_ product: SKProduct)
    var products: [SKProduct] { get }
    var transactionState: SKPaymentTransactionState? { get }
    var purchasing: SKProduct? { get }
}
