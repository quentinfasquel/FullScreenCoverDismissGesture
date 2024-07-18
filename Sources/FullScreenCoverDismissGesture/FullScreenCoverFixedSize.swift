//
//  FullScreenCoverFixedSize.swift
//  FullScreenCoverDismissGesture
//
//  Created by Quentin Fasquel on 18/07/2024.
//

import SwiftUI

struct FullScreenCoverFixedSize: ViewModifier {
    @State private var initialSafeAreaInsets: EdgeInsets = EdgeInsets(.zero)

    var horizontalSafeAreaInsets: CGFloat {
        initialSafeAreaInsets.leading + initialSafeAreaInsets.trailing
    }
    var verticalSafeAreaInsets: CGFloat {
        initialSafeAreaInsets.top + initialSafeAreaInsets.bottom
    }

    func body(content: Content) -> some View {
        GeometryReader { geometry in
            let frame = geometry.frame(in: .global)
            content
                .frame(
                    width: frame.width + horizontalSafeAreaInsets,
                    height: frame.height + verticalSafeAreaInsets
                )
                .offset(
                    x: -initialSafeAreaInsets.leading,
                    y: -initialSafeAreaInsets.top
                )
                .onAppear {
                    initialSafeAreaInsets = geometry.safeAreaInsets
                }
        }
    }
}

extension View {
    public func fullScreenCoverFixedSize() -> some View {
        modifier(FullScreenCoverFixedSize())
    }
}
