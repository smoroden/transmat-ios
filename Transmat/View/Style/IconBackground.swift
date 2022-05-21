//
//  IconBackground.swift
//  Transmat
//
//  Created by Zach Smoroden on 2022-05-20.
//

import SwiftUI

struct IconBackground: View {
    var body: some View {
        Circle()
            .foregroundColor(Color("backgroundAccent"))
    }
}

struct IconBackground_Previews: PreviewProvider {
    static var previews: some View {
        IconBackground()
    }
}
