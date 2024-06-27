//
//  AnimationCompletionObserverModifier.swift
//  FullScreenCoverDismissGesture
//
//  Created by Quentin Fasquel on 27/06/2024.
//

import SwiftUI

extension View {
    @available(iOS 16.4, *)
    public func fullScreenCoverDismissGesture() -> some View {
        modifier(PresentationDismissGestureModifier())
    }
}

@available(iOS 16.4, *)
public struct PresentationDismissGestureModifier: ViewModifier {

    @Environment(\.dismiss) private var dismiss

    @State private var isBeingPresented: Bool = false
    @State private var isBeingDismissed: Bool = false
    @State private var draggedOffset: CGFloat = 0

    @GestureState(reset: { value, transaction in
        if Self.dragGestureShouldDismiss(value) {
            transaction.disablesAnimations = true
            transaction.animation = .none
        } else {
            transaction.animation = .interpolatingSpring
        }
    }) private var draggingOffset: CGFloat = 0

    var offsetY: CGFloat {
        draggingOffset + draggedOffset
    }

    static func dragGestureShouldDismiss(_ offset: CGFloat) -> Bool {
        offset > 0.25
    }

    public func body(content: Content) -> some View {
        GeometryReader { geometry in
            ZStack {
                if isBeingPresented {
                    Color.black
                        .opacity(0.65 * (isBeingDismissed ? 0 : 1 - offsetY))
                        .transition(.opacity)
                }

                if isBeingDismissed {
                    EmptyView()
                } else if isBeingPresented {
                    content
                        .offset(y: offsetY * geometry.size.height)
                        .transition(.move(edge: .bottom))
                        .zIndex(1)
                }
            }
            .gesture(DragGesture()
                .updating($draggingOffset) { value, state, transaction in
                    if #available(iOS 17, *) {
                        transaction.tracksVelocity = true
                    }
                    state = value.translation.height / geometry.size.height
                }
                .onEnded { value in
                    let offset = value.translation.height / geometry.size.height
                    guard Self.dragGestureShouldDismiss(offset) else {
                        return
                    }

                    draggedOffset = offset
                    animateDismiss()
                }
            )
        }
        .ignoresSafeArea()
        .presentationBackground(.clear)
        .onAnimationCompleted(for: isBeingDismissed ? 1 : 0) {
            dismissWithoutAnimation()
        }
        .onAppear {
            withAnimation(.spring) {
                isBeingPresented = true
            }
        }
        .environment(\.fullScreenCoverDismiss, .init {
            animateDismiss()
        })
    }

    private func animateDismiss() {
        if #available(iOS 17, *) {
            withAnimation(.interpolatingSpring(.smooth)) {
                isBeingDismissed = true
            }
        } else {
            withAnimation(.interpolatingSpring) {
                isBeingDismissed = true
            }
        }
    }

    private func dismissWithoutAnimation() {
        var transaction = Transaction()
        transaction.disablesAnimations = true
        withTransaction(transaction) {
            dismiss()
        }
    }
}

public struct FullScreenCoverDismissAction {
    var handler: (() -> Void)?
    public func callAsFunction() {
        handler?()
    }
}

public struct FullScreenCoverDismissEnvironmentKey: EnvironmentKey {
    public static var defaultValue = FullScreenCoverDismissAction()
}

extension EnvironmentValues {
    public fileprivate(set) var fullScreenCoverDismiss: FullScreenCoverDismissAction {
        get { self[FullScreenCoverDismissEnvironmentKey.self] }
        set { self[FullScreenCoverDismissEnvironmentKey.self] = newValue }
    }
}
