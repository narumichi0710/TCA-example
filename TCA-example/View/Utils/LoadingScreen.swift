//
//  IndicatorScreen.swift
//  TCA-example
//
//  Created by Narumichi Kubo on 2022/08/13.
//

import SwiftUI

struct LoadsingScreen: View {
    @State private var isAnimating = false

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // ①Loading中に画面をタップできないようにするためのほぼ透明なLayer
                Color(.black)
                    .opacity(0.01)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .edgesIgnoringSafeArea(.all)
                    .disabled(true)
                
                Circle()
                    .trim(from: 0, to: 0.6)
                    .stroke(AngularGradient(gradient: Gradient(colors: [.gray, .white]), center: .center),
                            style: StrokeStyle(
                                lineWidth: 8,
                                lineCap: .round,
                                dash: [0.1, 16],
                                dashPhase: 8))
                    .frame(width: 48, height: 48)
                    .rotationEffect(.degrees(isAnimating ? 360 : 0))
                    .onAppear() {
                        withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: false)) {
                            isAnimating = true
                        }
                    }
                    .onDisappear() {
                        isAnimating = false
                    }
            }
        }
    }
}

struct LoadingScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoadsingScreen()
    }
}
