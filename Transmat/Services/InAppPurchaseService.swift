//
//  InAppPurchaseService.swift
//  Transmat
//
//  Created by Zach Smoroden on 2022-05-20.
//

import Foundation
import StoreKit

class InAppPurchaseService: NSObject, IAPService, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    @Published var products: [SKProduct] = []
    @Published var transactionState: SKPaymentTransactionState?
    @Published var purchasing: SKProduct?

    private let productIDs: Set<String> = [
        "tipSmall",
        "tipLarge",
    ]

    func getProducts() {
        debugPrint("Start requesting products ...")
        let request = SKProductsRequest(productIdentifiers: productIDs)
        request.delegate = self
        request.start()
    }

    func purchase(_ product: SKProduct) {
        guard SKPaymentQueue.canMakePayments() else { return }
        purchasing = product

        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing:
                transactionState = .purchasing
            case .purchased:
                queue.finishTransaction(transaction)
                transactionState = .purchased
                purchasing = nil
            case .restored:
                queue.finishTransaction(transaction)
                transactionState = .restored
                purchasing = nil
            case .failed, .deferred:
                queue.finishTransaction(transaction)
                transactionState = .failed
                purchasing = nil
            default:
                debugPrint("Payment Queue Error: \(String(describing: transaction.error))")
                queue.finishTransaction(transaction)
            }
        }
    }

    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        debugPrint("Did receive response")

        if !response.products.isEmpty {
            let newProducts = response.products.filter { !products.contains($0) }
            DispatchQueue.main.async { [weak self] in
                self?.products.append(contentsOf: newProducts)
            }
        }

        for invalidIdentifier in response.invalidProductIdentifiers {
            debugPrint("Invalid identifiers found: \(invalidIdentifier)")
        }
    }

    func request(_ request: SKRequest, didFailWithError error: Error) {
        debugPrint("Request did fail: \(error)")
    }
}
