//
//  AnimationCompletionObserverModifier.swift
//  FullScreenCoverDismissGesture
//
//  Created by Quentin Fasquel on 27/06/2024.
//

import SwiftUI


extension View {
    public func onAnimationCompleted<Value: VectorArithmetic>(for value: Value, completion: @escaping () -> Void) -> some View {
        modifier(AnimationCompletedModifier(value: value, completion: completion))
    }
}

struct AnimationCompletedModifier<Value: VectorArithmetic>: ViewModifier {
    var value: Value
    var completion: () -> Void
    func body(content: Content) -> some View {
        if #available(iOS 17, *) {
            content.transaction(value: value) { transaction in
                transaction.addAnimationCompletion(criteria: .logicallyComplete, completion)
            }
        } else {
            content.modifier(AnimationCompletionObserverModifier(targetValue: value, completion: { started in
                completion()
            }))
        }
    }
}

// MARK: =

struct AnimationCompletionObserverModifier<Value: VectorArithmetic>: ViewModifier, Animatable {
    private let completion: (Bool) -> Void
    private let timer = Timer.publish(every: 0.0167, on: .main, in: .common).autoconnect()

    @State private var animatableDataTrail: [Value] = [.zero, .zero, .zero]
    @State private var isIdle: Bool = true

    var animatableData: Value

    init(targetValue: Value, completion: @escaping (Bool) -> Void) {
        self.completion = completion
        self.animatableData = targetValue
    }

    func body(content: Content) -> some View {
        content.onReceive(timer) { _ in
            animatableDataTrail[2] = animatableDataTrail[1]
            animatableDataTrail[1] = animatableDataTrail[0]
            animatableDataTrail[0] = animatableData
            
            let isIdle = animatableDataTrail[0] == animatableDataTrail[1]
            && animatableDataTrail[1] == animatableDataTrail[2]
            
            if !self.isIdle && isIdle {
                Task { completion(false) }
            } else if self.isIdle && !isIdle {
                Task { completion(true) }
            }
            
            self.isIdle = isIdle
        }
    }
}

