//
//  ContentView.swift
//  Spongercaser
//
//  Created by Marcus Ziadé on 10.10.2022.
//

import SwiftUI

struct ContentView: View {

    @ObservedObject var model: ViewModel

    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .center) {
                Color.black.opacity(0.7)
                TextEditor(text: $model.inputMessage)
            }

            ZStack {
                model.state.color

                if !model.outputMessage.isEmpty {
                    OutputView(
                        message: model.outputMessage,
                        buttonTitle: model.state == .copied ? "Copied" : "Copy"
                    ) {
                        model.copyOutput()
                    }
                }
            }
            #if os(iOS)
            .animation(.easeInOut, value: model.state)
            #endif
        }
    }
}

struct ContentView_Previews: PreviewProvider {

    static var previews: some View {
        ContentView(model: ViewModel())
    }
}
