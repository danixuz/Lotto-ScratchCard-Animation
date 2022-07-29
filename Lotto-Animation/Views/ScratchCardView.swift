//
//  ScratchCardView.swift
//  Lotto-Animation
//
//  Created by Daniel Spalek on 27/07/2022.
//

import SwiftUI

struct ScratchCardView<Content: View, Overlay: View>: View {
    var content: Content
    var overlay: Overlay
    // MARK: Properties
    var pointSize: CGFloat
    // MARK: Callback for when the scratchcard is fully visible
    var onFinish: () -> ()
    
    init(pointSize: CGFloat, @ViewBuilder content: @escaping() -> Content, @ViewBuilder overlay: @escaping() -> Overlay, onFinish: @escaping () -> Void) {
        self.content = content()
        self.overlay = overlay()
        self.pointSize = pointSize
        self.onFinish = onFinish
    }
    // MARK: Animation properties
    @State var isScratched: Bool = false
    @State var disableGesture: Bool = false
    @State var dragPoints: [CGPoint] = []
    @State var animateCard: [Bool] = [false, false]
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            ZStack{
                // MARK: The logic is simple
                // we are going to mask the content of the card bit by bit based on the drag location, thus it will start drawing the content view over the overlay view.
                
                overlay
                content
                    .mask {
                        if disableGesture{
                            Rectangle() // to show the trophy
                        }else{
                            PointShape(points: dragPoints)
                            // MARK: Giving the line drawn a radius
                                .stroke(style: StrokeStyle(lineWidth: isScratched ? (size.width * 3) : pointSize, lineCap: .round, lineJoin: .round))
                        }
                    }
                // MARK: Adding gesture
                    .gesture(
                        DragGesture(minimumDistance: disableGesture ? 100000 : 0)
                            .onChanged({value in
                                // MARK: Stopping animation when the first touch is registered
                                if dragPoints.isEmpty{
                                    withAnimation(.easeInOut){
                                        animateCard[0] = false
                                        animateCard[1] = false
                                    }
                                }
                                
                                // MARK: Adding the point
                                dragPoints.append(value.location)
                            })
                            .onEnded({ _ in
                                // MARK: Checking if atleast one portion is scratched
                                if !dragPoints.isEmpty{
                                    // MARK: Scratching whole card
                                    withAnimation(.easeInOut(duration: 0.35)){
                                        isScratched = true
                                    }
                                    
                                    // Callback
                                    onFinish()
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.35){
                                        disableGesture = true
                                    }
                                    
                                }
                            })
                    )
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            // MARK: The combination of both rotation3deffects and onappear code create the circular 3d rotation effect
            .rotation3DEffect(.init(degrees: animateCard[0] ? 4: 0), axis: (x: 1, y: 0, z: 0))
            .rotation3DEffect(.init(degrees: animateCard[1] ? 4: 0), axis: (x: 0, y: 1, z: 0))
            
            .onAppear{
                withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)){
                    animateCard[0] = true
                }
                withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true).delay(0.8)){
                    animateCard[1] = true
                }
                
        }
        }
    }
}

// MARK: Custom path shape based on drag location
struct PointShape: Shape{
    var points: [CGPoint]
    var animatableData: [CGPoint]{
        get{points} //getter for the points property
        set{points = newValue} //setter for the points property
        
    }
    
    func path(in rect: CGRect) -> Path {
        Path{ path in
            if let first = points.first{
                path.move(to: first)
                path.addLines(points)
            }
        }
    }
}

struct ScratchCardView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
