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
    var body: some View {
        ZStack{
            // MARK: The logic is simple
            // we are going to mask the content of the card bit by bit based on the drag location, thus it will start drawing the content view over the overlay view.
            
            overlay
            content
                .mask {
                    Rectangle() // to show the trophy
                }
        }
    }
}

struct ScratchCardView_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
