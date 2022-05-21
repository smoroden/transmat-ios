//
//  HomeView.swift
//  Transmat
//
//  Created by Zach Smoroden on 2022-05-04.
//

import SwiftUI

struct HomeView<CommandType: CommandService, IAPType: IAPService>: View {
    @ObservedObject var bluetoothService: CommandType
    @ObservedObject var iapService: IAPType
    @FetchRequest(sortDescriptors: []) var calloutPages: FetchedResults<CalloutPage>
    @Environment(\.managedObjectContext) var context

    @State var selectedPage: CalloutPage?
    @State var showBluetoothAlert = false
    @State var showSettings = false
    @State var showCreate = false

    var body: some View {
        NavigationView {
            List(selection: $selectedPage) {
                ForEach(calloutPages) { page in
                    NavigationLink(page.title,
                                   tag: page,
                                   selection: $selectedPage) {
                        CalloutPageDetail<CommandType>(calloutPage: page)
                    }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        context.delete(calloutPages[index])
                    }

                    do {
                        try context.save()
                    } catch let error {
                        debugPrint(error)
                    }
                }
            }
            .onAppear {
                if selectedPage == nil, UIDevice.isIPad {
                    selectedPage = calloutPages.first
                }
            }
            .toolbar {
                toolbar
            }
            .navigationTitle("app-name")
            .alert("alert-disconnect-title", isPresented: $showBluetoothAlert) {
                Button("button-cancel", role: .cancel, action: {})
                Button("button-ok", action: bluetoothService.stop)
            }

            Text("home-empty-title")
                .font(.largeTitle)
        }
        .environmentObject(bluetoothService)
    }

    @ViewBuilder
    var toolbar: some View {
        HStack {
            Button(action: toggleBluetooth) {
                Image(bluetoothService.isConnected ? "bluetoothConnected" : "bluetoothDisconnected")
                    .padding(4)
                    .background(IconBackground())
            }

            NavigationLink(destination: Info(iapService: iapService)) {
                Image(systemName: "info.circle")
                    .padding(4)
                    .background(IconBackground())
            }

            Button(action: { showSettings.toggle() }) {
                Image(systemName: "gearshape.fill")
                    .padding(4)
                    .background(IconBackground())
            }.popover(isPresented: $showSettings) {
                SettingsView(showing: $showSettings)
                    .padding()
            }

            NavigationLink(destination: CreateCalloutPage(selectedPage: $selectedPage)) {
                Image(systemName: "plus")
                    .padding(4)
                    .background(IconBackground())
            }
        }
    }

    func toggleBluetooth() {
        if bluetoothService.isConnected {
            showBluetoothAlert = true
        } else {
            bluetoothService.start()
        }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static let service = DesignTimeCalloutService()
    static var previews: some View {
        Group {
            HomeView(bluetoothService: DesignTimeBluetooth(),
                     iapService: DesignTimeIAPService())
            HomeView(bluetoothService: DesignTimeBluetooth(),
                     iapService: DesignTimeIAPService())
                .preferredColorScheme(.dark)
                .previewDevice("iPhone 8")
                .previewInterfaceOrientation(.landscapeRight)
            HomeView(bluetoothService: DesignTimeBluetooth(),
                     iapService: DesignTimeIAPService())
                .previewDevice("iPad Pro (12.9-inch) (5th generation)")
            HomeView(bluetoothService: DesignTimeBluetooth(),
                     iapService: DesignTimeIAPService())
                .preferredColorScheme(.dark)
                .previewDevice("iPad mini (6th generation)")
        }.environmentObject(UserSettings())
            .environment(\.managedObjectContext, service.container.viewContext)
    }
}
#endif
