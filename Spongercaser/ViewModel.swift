//
//  ViewModel.swift
//  Spongercaser
//
//  Created by Marcus Ziadé on 10.10.2022.
//

import Combine
import Foundation
import SwiftUI

final class ViewModel: ObservableObject {

    enum State {
        case empty, result, copied

        var color: Color {
            switch self {
            case .empty: return Color.secondary.opacity(0.8)
            case .result: return Color.blue.opacity(0.8)
            case .copied: return Color.green.opacity(0.8)
            }
        }
    }

    @Published var inputMessage: String = "Enter your message here..."
    @Published var outputMessage: String = ""

    @Published var state: State = .empty

    init() {
        readClipboard()

        $inputMessage
            .dropFirst()
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] message in
                outputMessage = ""
                if message.isEmpty {
                    state = .empty
                } else {
                    makeSpongecase(for: message)
                }
            }
            .store(in: &cancellables)
    }

    func copyToClipboard() {
        state = .copied
#if os(macOS)
        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([.string], owner: self)
        pasteboard.setString(outputMessage, forType: .string)
#elseif os(iOS)
        UIPasteboard.general.string = outputMessage
        UINotificationFeedbackGenerator().notificationOccurred(.success)
#endif
    }

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    private func makeSpongecase(for message: String) {
        state = .result
        for c in message {
            outputMessage.append(Bool.random() ? c.uppercased() : c.lowercased())
        }
    }

    private func readClipboard() {
#if os(macOS)
        if let clipboard = NSPasteboard.general.string(forType: .string) {
            inputMessage = clipboard
        }
#elseif os(iOS)
        if let clipboard = UIPasteboard.general.string {
            inputMessage = clipboard
        }
#endif
    }
}
