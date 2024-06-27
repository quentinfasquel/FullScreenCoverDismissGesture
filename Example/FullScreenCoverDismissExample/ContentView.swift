//
//  ContentView.swift
//  FullScreenCoverDismissExample
//
//  Created by Quentin Fasquel on 27/06/2024.
//

import SwiftUI
import FullScreenCoverDismissGesture

struct ContentView: View {
    @State private var showDetail: Bool = false
    var body: some View {
        ZStack {
            LinearGradient(colors: [.blue, .cyan], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            Button("Show Detail") {
                presentWithoutAnimation()
            }
            .font(.headline)
            .buttonStyle(.borderedProminent)
        }
        .fullScreenCover(isPresented: $showDetail) {
            DetailView().fullScreenCoverDismissGesture()
        }
    }

    private func presentWithoutAnimation() {
        var transaction = Transaction(animation: nil)
        transaction.disablesAnimations = true
        withTransaction(transaction) {
            showDetail = true
        }
    }
}

struct DetailView: View {
    @Environment(\.fullScreenCoverDismiss) private var dismiss

    var body: some View {
        ZStack {
            Color.black
            VStack(spacing: 16) {
                Group {
                    Text("Drag to dismiss")
                        .font(.headline)
                    Text("or")
                        .font(.caption)
                }
                .foregroundStyle(.white)
                Button("Dismiss") {
                    dismiss()
                }
                .font(.headline)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

#Preview {
    ContentView()
}
