//
//  TransmatApp.swift
//  Transmat
//
//  Created by Zach Smoroden on 2022-05-04.
//

import SwiftUI
import CoreData
import StoreKit

@main
struct TransmatApp: App {
    @StateObject var bluetooth = BluetoothService()
    @StateObject var callout = LocalCalloutService()
    @StateObject var iap = InAppPurchaseService()

    @AppStorage(wrappedValue: false, "initialLoadComplete") var initialLoadComplete

    var body: some Scene {
        WindowGroup {
            HomeView(bluetoothService: bluetooth, iapService: iap)
            .environmentObject(UserSettings())
            .environmentObject(iap)
            .environment(\.managedObjectContext, callout.container.viewContext)
            .onAppear(perform: initialLoad)
        }
    }

    func initialLoad() {
        if !initialLoadComplete {
            let page = CalloutPage(context: callout.container.viewContext)
            let _ = LocalCallout.allCases
                .map { $0.callout(callout.container.viewContext) }
                .map(page.addToCallouts(_:))

            page.title = NSLocalizedString("vow-title", comment: "")
            initialLoadComplete = true
            do {
                try callout.container.viewContext.save()
            } catch let error {
                assertionFailure(error.localizedDescription)
            }

        }

        SKPaymentQueue.default().add(iap)
        iap.getProducts()
    }
}
