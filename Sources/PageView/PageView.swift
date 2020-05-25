//
//  PageView.swift
//  PageView
//
//  Created by Grigory Avdyushin on 24/05/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import SwiftUI

func clamp<T: Comparable>(_ value: T, minValue: T, maxValue: T) -> T {
    min(max(value, minValue), maxValue)
}

public protocol PageIndicatorProtocol: ViewModifier {

    var isActive: Bool { get set }

    init(isActive: Binding<Bool>)
}

public struct PageIndicatorDefaultModifier: PageIndicatorProtocol {

    @Binding public var isActive: Bool

    public init(isActive: Binding<Bool>) {
        self._isActive = isActive
    }

    public func body(content: Content) -> some View {
        content.opacity(isActive ? 1.0 : 0.5)
    }
}

public struct PageContentView<Content: View, Indicator: View>: View {

    let indicator: Indicator
    let content: Content

    public init(@ViewBuilder indicator: () -> Indicator, @ViewBuilder _ content: () -> Content) {
        self.indicator = indicator()
        self.content = content()
    }

    public var body: some View { content }
}

public struct PageView<Content: View, Indicator: View, Modifier: PageIndicatorProtocol>: View {

    public typealias Page = PageContentView<Content, Indicator>

    @_functionBuilder struct PageBuilder {
        static func buildBlock(_ pages: Page...) -> [Page] { pages }
    }

    private let pages: [Page]
    private let bounce = true
    private let modifierType: Modifier.Type

    @Binding private var index: Int
    @State private var offset: CGFloat = 0

    public init(index: Binding<Int>, modifierType: Modifier.Type, @PageBuilder _ pages: () -> [Page]) {
        self.pages = pages()
        self._index = index
        self.modifierType = modifierType
    }

    public var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                HStack(spacing: 0) {
                    ForEach(0..<self.pages.count) { index in
                        Group {
                            self.pages[index]
                        }
                        .frame(width: geometry.size.width, height: geometry.size.height)
                    }
                }
                .frame(width: geometry.size.width, height: geometry.size.height, alignment: .leading)
                .offset(x: -CGFloat(self.index) * geometry.size.width)
                .offset(x: self.offset)
                .animation(.interactiveSpring())
                .gesture(DragGesture()
                .onChanged { gesture in
                    let minOffset: CGFloat = 0
                    let maxOffset = -geometry.size.width * CGFloat(self.pages.count - 1)
                    let pageOffset = gesture.translation.width - CGFloat(self.index) * geometry.size.width
                    if maxOffset...minOffset ~= pageOffset {
                        self.offset = gesture.translation.width
                    } else if self.bounce {
                        self.offset = gesture.translation.width / 3
                    }
                }
                .onEnded { gesture in
                    let relativeOffset = gesture.predictedEndTranslation.width / geometry.size.width
                    let predictedIndex = Int((CGFloat(self.index) - relativeOffset).rounded())
                    // Avoid jump over pages
                    let newIndex = self.index - clamp(self.index - predictedIndex, minValue: -1, maxValue: 1)
                    self.index = clamp(newIndex, minValue: 0, maxValue: self.pages.count - 1)
                    // Reset local offset
                    self.offset = 0
                    }
                )
                HStack {
                    ForEach(0..<self.pages.count) { index in
                        Button(action: {
                            withAnimation {
                                self.index = index
                            }
                        }) {
                            self.pages[index].indicator
                        }
                        .modifier(
                            self.modifierType.init(isActive: Binding<Bool>(get: { index == self.index }, set: { _ in }))
                        )
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 12, trailing: 0))
                    }
                }
            }
        }
    }
}
