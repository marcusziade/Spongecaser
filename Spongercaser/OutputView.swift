//
//  OutputView.swift
//  Spongercaser
//
//  Created by Marcus Ziadé on 10.10.2022.
//

import SwiftUI

struct OutputView: View {

    let message: String
    let buttonTitle: String
    let onCopy: (() -> ())?

    var body: some View {
        VStack {
            Text(message)
                .fontWeight(.bold)
                .shadow(radius: 5).shadow(radius: 5).shadow(radius: 5)
                .padding()
            Button {
                onCopy?()
            } label: {
                Text(buttonTitle)
                    .padding(.horizontal)
            }
            .buttonStyle(.borderedProminent)
            .shadow(radius: 5, x: shadowOffset, y: shadowOffset)
            .shadow(radius: 5, x: shadowOffset, y: shadowOffset)
        }
        .foregroundColor(.white)
    }

    private let shadowOffset: CGFloat = 2
}

struct OutputView_Previews: PreviewProvider {

    static var previews: some View {
        OutputView(message: "Output message", buttonTitle: "Copy", onCopy: {})
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
