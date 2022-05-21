//
//  CalloutPageDetail.swift
//  Transmat
//
//  Created by Zach Smoroden on 2022-05-09.
//

import SwiftUI

struct CalloutPageDetail<BluetoothType: CommandService>: View {
    @EnvironmentObject var userSettings: UserSettings
    @EnvironmentObject var bluetoothService: BluetoothType
    @Environment(\.design) var design
    let calloutPage: CalloutPage

    var body: some View {
        GeometryReader { proxy in
            LazyVGrid(columns: gridItems(height: Int(proxy.size.height),
                                         width: Int(proxy.size.width),
                                         itemCount: calloutPage.calloutsArray.count,
                                         padding: Int(design.spacing * 2)),
                      spacing: design.spacing) {
                ForEach(calloutPage.calloutsArray) { callout in
                    Button(action: { bluetoothService.send(callout.action) }) {
                        CalloutView(callout: callout)
                    }
                }
            }.padding()
        }
    }
}

#if DEBUG
struct CalloutPageDetail_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CalloutPageDetail<DesignTimeBluetooth>(calloutPage: .vowOfDisciple(nil))
                .previewDevice("iPad Pro (12.9-inch) (5th generation)")

            CalloutPageDetail<DesignTimeBluetooth>(calloutPage: .vowOfDisciple(nil))
                .previewDevice("iPad Pro (12.9-inch) (5th generation)")
                .previewInterfaceOrientation(.landscapeRight)

            CalloutPageDetail<DesignTimeBluetooth>(calloutPage: .vowOfDisciple(nil))
                .previewDevice("iPhone 11")
                .previewInterfaceOrientation(.landscapeRight)
        }
        .environmentObject(UserSettings())
        .environmentObject(DesignTimeBluetooth())
    }
}
#endif
