//
//  ViewModel.swift
//  Spongercaser
//
//  Created by Marcus Ziadé on 10.10.2022.
//

import Combine
import Foundation
#if os(iOS)
import UIKit
#endif
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
#if os(macOS)
        if let clipboard = NSPasteboard.general.string(forType: .string) {
            inputMessage = clipboard
        }
#elseif os(iOS)
        if let clipboard = UIPasteboard.general.string {
            inputMessage = clipboard
        }
#endif

        $inputMessage
            .dropFirst()
            .subscribe(on: DispatchQueue.global())
            .removeDuplicates()
            .debounce(for: 0.2, scheduler: DispatchQueue.main)
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] message in
                if message.isEmpty {
                    state = .empty
                    outputMessage = ""
                } else {
                    makeSpongecase(for: message)
                    state = .result
                }
            }
            .store(in: &cancellables)
    }

    func copyOutput() {
        state = .copied
#if os(iOS)
        UINotificationFeedbackGenerator().notificationOccurred(.success)
#endif
        copyToClipboard(with: outputMessage)
    }

    // MARK: Private

    private var cancellables = Set<AnyCancellable>()

    private func makeSpongecase(for message: String) {
        outputMessage = ""
        for c in message {
            outputMessage.append(Bool.random() ? c.uppercased() : c.lowercased())
        }
    }

    private func copyToClipboard(with message: String) {
#if os(macOS)
        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([.string], owner: self)
        pasteboard.setString(message, forType: .string)
#elseif os(iOS)
        UIPasteboard.general.string = message
#endif
    }
}
