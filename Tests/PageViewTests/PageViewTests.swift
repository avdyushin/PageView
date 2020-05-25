//
//  PageViewTests.swift
//  PageView
//
//  Created by Grigory Avdyushin on 24/05/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import XCTest
import SwiftUI
@testable import PageView

struct PageIndicatorScaleModifier: PageIndicatorProtocol {

    @Binding var isActive: Bool

    init(isActive: Binding<Bool>) {
        self._isActive = isActive
    }

    func body(content: Content) -> some View {
        content.scaleEffect(isActive ? 1.1 : 0.8)
    }
}

struct WrappedView: View {

    @State var index = 0

    var circle: some View = Circle().frame(width: 8, height: 8)

    var body: some View {
        ZStack(alignment: .bottom) {
            PageView(index: $index, modifierType: PageIndicatorScaleModifier.self) {
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

final class PageViewTests: XCTestCase {

    func testExample() {
        let view = WrappedView()
        view.index = 0
        XCTAssertEqual(view.index, 0)
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
