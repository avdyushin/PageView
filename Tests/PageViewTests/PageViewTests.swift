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

final class PageViewTests: XCTestCase {

    func testExample() {
        let view = PaginatedView()
        view.index = 0
        XCTAssertEqual(view.index, 0)
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
