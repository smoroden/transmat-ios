//
//  CalloutView.swift
//  Transmat
//
//  Created by Zach Smoroden on 2022-05-09.
//

import SwiftUI

struct CalloutView: View {
    @EnvironmentObject var userSettings: UserSettings
    let callout: Callout
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if case .localImage = callout.image.type, let image = callout.image.image {
                Image(uiImage: image).resizable()
            } else if case .color = callout.image.type, let color = callout.image.color {
                color
            } else if case .networkImage = callout.image.type, let url = callout.image.url {
                AsyncImage(url: url) {
                    $0.resizable()
                } placeholder: {
                    Image(systemName: "questionmark.app")
                }
            }

            if userSettings.displayLabels {
                Text(callout.display)
                    .font(.system(size: 16 * userSettings.textScale))
                    .foregroundColor(.white)
                    .padding(4)
                    .background(Color.black.opacity(0.5).clipShape(RoundedRectangle(cornerRadius: 12)))
                    .padding(.bottom, 4)
            }
        }.aspectRatio(1, contentMode: .fit)
    }
}

#if DEBUG
struct CalloutView_Previews: PreviewProvider {
    static let service = DesignTimeCalloutService()
    static var previews: some View {
        Group {
            CalloutView(callout: LocalCallout.ascendantPlane.callout(service.container.viewContext))

            CalloutView(callout: LocalCallout.ascendantPlane.callout(service.container.viewContext))
                .environmentObject({ () -> UserSettings in
                    let settings = UserSettings()
                    settings.displayLabels = true

                    return settings
                }())

        }.environmentObject(UserSettings())
    }
}
#endif
