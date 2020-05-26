# PageView

Missing Page View for SwiftUI

<img src="https://raw.githubusercontent.com/avdyushin/PageView/master/Assets/PageView.gif" width="200px" />

### How to use?

```swift
struct PaginatedView: View {

    @State var index = 0

    var body: some View {
        PageView(index: $index) {
            PageView.Page { AnyView(
                ZStack {
                    Rectangle().fill().foregroundColor(.yellow)
                    VStack {
                        Text("Page 1")
                        Text("View")
                    }
                }
            )}
            PageView.Page { AnyView(
                ZStack {
                    Rectangle().fill().foregroundColor(.orange)
                    Text("Page 2 View")
                }
            )}
            PageView.Page { AnyView(
                ZStack {
                    Rectangle().fill().foregroundColor(.green)
                    HStack {
                        Text("Page 3")
                        Text("View")
                    }
                }
            )}
        }
    }
}
```

### Adding page indicator

Page indicator view is a button with circle inside and callback action block:

```swift
struct IndicatorView: View {
    var action: () -> Void
    var body: some View {
        Button(action: { withAnimation { self.action() } }) {
            ZStack {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 24, height: 24)
                Circle().fill().frame(width: 8, height: 12)
            }
        }
    }
}
```

Indicator modifier, so we can highlight current page:

```swift
struct IndicatorModifier: ViewModifier {
    let index: Int
    @Binding var currentIndex: Int

    func body(content: Content) -> some View {
        content.opacity(index == currentIndex ? 1.0 : 0.5)
    }
}
```

Using ZStack combine views together:

```swift
struct PaginatedWithIndicatorsView: View {
    @State var index = 0
    var body: some View {
        ZStack(alignment: .bottom) {
            PaginatedView(index: $index)
            HStack(spacing: 0) {
                ForEach(0..<3) { index in
                    IndicatorView { self.index = index }
                        .foregroundColor(.white)
                        .modifier(IndicatorModifier(index: index, currentIndex: self.$index))
                }
            }.padding(.bottom, 12)
        }.background(Color.blue)
    }
}
```

### How to add it to Xcode project?

1. In Xcode select **File ⭢ Swift Packages ⭢ Add Package Dependency...**
1. Copy-paste repository URL: **https://github.com/avdyushin/PageView**
1. Hit **Next** two times, under **Add to Target** select your build target.
1. Hit **Finish**
