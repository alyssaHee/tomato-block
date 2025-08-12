//
//  SwiftUI+Font.swift
//  Tomato Brick
//
//  Created by Alyssa H on 2025-07-17.
//

import SwiftUI

extension Font {
    static func kodemono(fontStyle: Font.TextStyle = .title) -> Font {
        return Font.custom("KodeMono-SemiBold", size: fontStyle.size)
    }
    
    static func IBMPlexMono(fontStyle: Font.TextStyle = .body) -> Font {
        return Font.custom("IBMPlexMono-Regular", size: fontStyle.size)
    }
}

extension Font.TextStyle {
    var size: CGFloat {
        switch self {
        case .largeTitle: return 34
        case .title: return 28
        case .title2: return 24
        case .title3: return 20
        case .headline: return 18
        case .subheadline: return 14
        case .body: return 16
        case .callout: return 15
        case .footnote: return 13
        case .caption: return 12
        case .caption2: return 11
        @unknown default: return 10
        }
    }
}
