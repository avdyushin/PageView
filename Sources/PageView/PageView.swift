//
//  PageView.swift
//  PageView
//
//  Created by Grigory Avdyushin on 24/05/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import SwiftUI

/// Paginated horizontal view
public struct PageView<Content: View>: View {

    /// There is no way to get views count out of `@ViewBuilder`.
    /// So wrapping view into `Page` object allows us to work with an array of views.
    /// Providing it into `init` or `buildBlock` we can calculate number of pages.
    public struct Page: View {
        private let content: Content

        public init(@ViewBuilder _ content: () -> Content) {
            self.content = content()
        }

        public var body: some View { content }
    }

    /// Page builder to allow using DSL to build view
    @_functionBuilder public struct PageBuilder {
        public static func buildBlock(_ pages: Page...) -> [Page] { pages }
    }

    /// Page views
    private let pages: [Page]
    /// Bounce horizontally flag
    private let alwaysBounceHorizontally = true
    /// Current visible page index
    @Binding private var index: Int
    /// Relative y offset
    @State private var offset: CGFloat = 0

    public init(index: Binding<Int>, @PageBuilder _ content: () -> [Page]) {
        self.init(index: index, pages: content())
    }

    public init(index: Binding<Int>, pages: [Page]) {
        self._index = index
        self.pages = pages
    }

    public var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                ForEach(0..<self.pages.count) { index in
                    self.pages[index]
                }.frame(width: geometry.size.width, height: geometry.size.height)
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .leading)
            .offset(x: -CGFloat(self.index) * geometry.size.width)
            .offset(x: self.offset)
            .animation(.interactiveSpring())
            .gesture(
                DragGesture()
                    .onChanged { self.onDragChanged(gesture: $0, geometry: geometry) }
                    .onEnded { self.onDragEnded(gesture: $0, geometry: geometry) }
            )
        }
    }

    // MARK: - Private

    fileprivate func clamp<T: Comparable>(_ value: T, minValue: T, maxValue: T) -> T {
        min(max(value, minValue), maxValue)
    }

    fileprivate func onDragChanged(gesture: DragGesture.Value, geometry: GeometryProxy) {
        let minOffset: CGFloat = 0
        let maxOffset = -geometry.size.width * CGFloat(pages.count - 1)
        let pageOffset = gesture.translation.width - CGFloat(index) * geometry.size.width
        if maxOffset...minOffset ~= pageOffset {
            offset = gesture.translation.width
        } else if alwaysBounceHorizontally {
            // Bounce effect if needed
            offset = gesture.translation.width / 3
        }
    }

    fileprivate func onDragEnded(gesture: DragGesture.Value, geometry: GeometryProxy) {
        let relativeOffset = gesture.predictedEndTranslation.width / geometry.size.width
        let predictedIndex = Int((CGFloat(index) - relativeOffset).rounded())
        // Avoid jump over pages
        let newIndex = index - clamp(index - predictedIndex, minValue: -1, maxValue: 1)
        index = clamp(newIndex, minValue: 0, maxValue: pages.count - 1)
        // Reset local offset
        offset = 0
    }
}
