//
//  ContentView.swift
//  zoomTest
//
//  Created by Alvito . on 15/09/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            FrameAnimationView(image: UIImage(named: "testImg")!)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 4 / 3)
                .clipped()
        }
        .padding()
    }
}

struct FrameAnimationView: View {
    @State private var currentFrame: Int = 0
    @State private var zoomFactor: CGFloat = 1.0
    let totalFrames: Int = 200  // 10 seconds of animation at 20 FPS
    let fps: Double = 20.0  // 20 frames per second
    let maxZoom: CGFloat = 2.0
    
    // The image to be zoomed in
    let image: UIImage

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            let imageAspectRatio = image.size.width / image.size.height
            let targetAspectRatio: CGFloat = 3 / 4
            let scaleToFit = imageAspectRatio < targetAspectRatio
                ? height / (width / imageAspectRatio)
                : width / (height * imageAspectRatio)
            
            ZStack {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .scaleEffect(zoomFactor)
                    .frame(width: width, height: height)
                    .clipped()
            }
            .frame(width: width, height: height)
            .onAppear {
                startAnimation()
            }
        }
    }
    
    func startAnimation() {
        Timer.scheduledTimer(withTimeInterval: 1.0 / fps, repeats: true) { timer in
            withAnimation(.linear(duration: 1.0 / fps)) {
                if currentFrame < totalFrames {
                    currentFrame += 1
                    let zoomStep = (maxZoom - 1.0) / CGFloat(totalFrames)
                    zoomFactor += zoomStep
                } else {
                    timer.invalidate()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
