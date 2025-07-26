//
//  KeyboardResponder.swift
//  SoniScope
//
//  Created by Venkata Siva Ramisetty on 7/24/25.
//


import Combine
import SwiftUI

class KeyboardResponder: ObservableObject {
    @Published var currentHeight: CGFloat = 0
    private var cancellables: Set<AnyCancellable> = []

    init() {
        let keyboardWillShow = NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillShowNotification)
            .merge(with: NotificationCenter.default.publisher(for: UIResponder.keyboardWillChangeFrameNotification))
            .compactMap { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect }
            .map { $0.height }

        let keyboardWillHide = NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }

        keyboardWillShow
            .merge(with: keyboardWillHide)
            .sink { [weak self] height in
                self?.currentHeight = height
            }
            .store(in: &cancellables)
    }
}
