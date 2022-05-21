//
//  CreateCalloutPage+ViewModel.swift
//  Transmat
//
//  Created by Zach Smoroden on 2022-05-14.
//

import SwiftUI

extension CreateCalloutPage {
    class ViewModel: ObservableObject {
        @Published var callouts: [Callout] = []
    }
}
