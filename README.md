# FullScreenCoverDismissGesture

[![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A SwiftUI extension to enable dismiss gestures for full-screen covers.

![Example of usage](https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExdjFwZjZncTNtbGI4OTBhNGh4N3Q3YXc3YTIwMGh3ZWQ4dmZocnhsbyZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/VncU1XwjgvzN9TwImn/giphy.gif)

## Usage

### Presenting a Full-Screen Cover

To present a full-screen cover without animation, you can use the following example:

```swift
struct ContentView: View {
    @State private var showDetail: Bool = false
    var body: some View {
        ZStack {
            Button("Show Detail") {
                presentWithoutAnimation()
            }
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
```

### Dismissing a Full-Screen Cover

To enable dismissing a full-screen cover using a custom gesture, use the following example:

```swift
struct DetailView: View {
    @Environment(\.fullScreenCoverDismiss) private var dismiss

    var body: some View {
        ZStack {
            Color.black
            Button("Dismiss") {
                dismiss()
            }
        }
    }
}
```

## License

This project is licensed under the MIT License - see the [LICENSE](/LICENSE) file for details.

