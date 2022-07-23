//
//  CounterMainView.swift
//  TCA-example
//
//  Created by Narumichi Kubo on 2022/07/23.
//

import SwiftUI

struct CounterMainView: View {
    @Binding var isPresentCounterView: Bool

    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Button("Close") {
                    isPresentCounterView.toggle()
                }
                .padding()
            }
        
            Spacer()
                
        }
    }
}
