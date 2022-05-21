//
//  SettingsView.swift
//  Transmat
//
//  Created by Zach Smoroden on 2022-05-11.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var userSettings: UserSettings
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.dismiss) private var dismiss

    @Binding var showing: Bool

    var body: some View {
        VStack {
        if UIDevice.isIPhone {
            ZStack {
                HStack {
                    Button(action: { showing = false }) {
                        Text("Close")
                    }

                    Spacer()
                }

                VStack {
                    Text("settings-title").bold()
                }
            }
            Spacer()
        }

            Toggle(isOn: $userSettings.displayLabels) {
                Text("settings-display-labels")
            }

            Divider()

            VStack {
                Slider(value: $userSettings.textScale, in: 1...4) {
                    Text("settings-label-scale")
                } minimumValueLabel: {
                    Text("1x")
                } maximumValueLabel: {
                    Text("4x")
                }

                Text(String(format: "%.1fx", userSettings.textScale))
            }
            Spacer()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SettingsView(showing: .constant(true))
                .environmentObject(UserSettings())
            SettingsView(showing: .constant(true))
                .preferredColorScheme(.dark)
                .environmentObject(UserSettings())
        }
    }
}
