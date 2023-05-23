//
//  ContentView.swift
//  Graduation project
//
//  Created by ByteDance on 2023/5/6.
//

import SwiftUI
import RealityKit

struct ContentView : View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ZStack{
            ARViewContainer().edgesIgnoringSafeArea(.all)
            VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Button(action: {
                                    self.presentationMode.wrappedValue.dismiss()
                                }) {
                                    Image(systemName: "xmark")
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color.black.opacity(0.6))
                                        .clipShape(Circle())
                                }
                                .padding()
                            }
                        }
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        // Add the box anchor to the scene
        let boxAnchor = try! Experience.loadBox()
        arView.scene.anchors.append(boxAnchor)
        
        // Add gesture recognizer to the AR view
        let panRecognizer = UIPanGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handlePanGesture(_:)))
        arView.addGestureRecognizer(panRecognizer)
        
        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject {
        @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
            let translation = gesture.translation(in: gesture.view)
            let velocity = gesture.velocity(in: gesture.view)
            // Do something with the translation and velocity data
            print("Translation: \(translation), Velocity: \(velocity)")
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
