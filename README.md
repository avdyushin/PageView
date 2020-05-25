# PageView

Missing Page View for SwiftUI

<img src="https://raw.githubusercontent.com/avdyushin/PageView/master/Assets/PageView.gif" width="200px" />

### How to use?

```swift
struct WrappedView: View {

    @State var index = 0

    var circle: some View = Circle().frame(width: 8, height: 8)

    var body: some View {
        ZStack(alignment: .bottom) {
            PageView(index: $index, modifierType: PageIndicatorDefaultModifier.self) {
                PageContentView(indicator: { self.circle }) {
                    AnyView(Group {
                        ZStack {
                            Rectangle().fill().foregroundColor(.yellow)
                            VStack {
                                Text("Page 1 View")
                                Text("Foo")
                            }
                        }
                    })
                }
                PageContentView(indicator: { self.circle }) {
                    AnyView(Group {
                        ZStack {
                            Rectangle().fill().foregroundColor(.orange)
                            Text("Page 2 View")
                        }
                    })
                }
                PageContentView(indicator: { self.circle }) {
                    AnyView(Group {
                        ZStack {
                            Rectangle().fill().foregroundColor(.green)
                            Text("Page 3 View")
                        }
                    })
                }
            }
        }.background(Color.blue)
    }
}
```

Custom indicator modifier example:

```swift
struct PageIndicatorScaleModifier: PageIndicatorProtocol {

    @Binding var isActive: Bool

    init(isActive: Binding<Bool>) {
        self._isActive = isActive
    }

    func body(content: Content) -> some View {
        content.scaleEffect(isActive ? 1.1 : 0.8)
    }
}
```

### How to add it to Xcode project?

1. In Xcode select **File ⭢ Swift Packages ⭢ Add Package Dependency...**
1. Copy-paste repository URL: **https://github.com/avdyushin/PageView**
1. Hit **Next** two times, under **Add to Target** select your build target.
1. Hit **Finish**

