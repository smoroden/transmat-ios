//
//  HorizontalAdapter.swift
//  Transmat
//
//  Created by Zach Smoroden on 2022-05-14.
//

import SwiftUI

struct HorizontalAdapter<Content: View>: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    let content: () -> Content

    init( @ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    var body: some View {
        if horizontalSizeClass == .compact {
            VStack {
                content()
            }
        } else {
            HStack {
                content()
            }
        }
    }
}

struct HorizontalAdapter_Previews: PreviewProvider {
    static var previews: some View {
        HorizontalAdapter {
            Text("test 1")

            Text("test 2")
        }
    }
}
