//
//  Info.swift
//  Transmat
//
//  Created by Zach Smoroden on 2022-05-18.
//

import SwiftUI
import StoreKit

struct Info<IAPType: IAPService>: View {
    @ObservedObject var iapService: IAPType
    @State var showThankyou = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Section {
                    Text("info-first-step")
                    Text("info-second-step")

                    HStack {
                        Image("bluetoothDisconnected")
                        Text("info-disconnected")
                    }

                    HStack {
                        Image("bluetoothConnected")
                        Text("info-connected")
                    }
                } header: {
                    Text("info-headline")
                        .font(.headline)
                }

                if SKPaymentQueue.canMakePayments() {
                    Divider()

                    Section {
                        ForEach(iapService.products, id: \.self) { product in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(product.localizedTitle)
                                        .font(.subheadline)
                                    Text(product.localizedDescription)
                                        .font(.caption2)
                                }
                                Spacer()

                                Button(action: {
                                    iapService.purchase(product)
                                }) {
                                    if iapService.purchasing == product {
                                        ProgressView()
                                    } else {
                                        Text("\(product.localizedPrice())")
                                    }
                                }.disabled(iapService.purchasing == product)
                            }
                            .padding()
                            .background(Color("backgroundAccent"))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    } header: {
                        Text("tips-title")
                            .font(.headline)
                        Text("tips-disclaimer")
                            .font(.caption)
                    }

                }
            }
            .navigationTitle("info-title")
            .padding()
            .onChange(of: iapService.transactionState) { state in
                if state == .purchased {
                    showThankyou = true
                }
            }
            .alert("Thank You!", isPresented: $showThankyou, actions: {})
        }
    }
}

#if DEBUG
struct Info_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Info(iapService: DesignTimeIAPService())
            Info(iapService: DesignTimeIAPService())
                .preferredColorScheme(.dark)
        }
    }
}
#endif
