//
//  ContentView.swift
//  TCA-example
//
//  Created by Narumichi Kubo on 2022/07/23.
//

import SwiftUI

struct ContentView: View {
    @State private var isPresentCounterView = false

    var body: some View {
        List {
            Button("SearchMainView") {
                isPresentCounterView.toggle()
            }
        }
        .fullScreenCover(isPresented: $isPresentCounterView) {
            SearchMainView(isPresentCounterView: $isPresentCounterView)
        }
    }
}


