//
//  ThemeViewModel.swift
//  Trezo
//
//  Created by Bekithemba Mdluli on 2024/12/12.
//

import SwiftUI


class ThemeViewModel: ObservableObject {
    // Function to change theme
    func applyTheme(_ theme: Int) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return
        }

        for window in windowScene.windows {
            switch theme {
            case 2:
                window.overrideUserInterfaceStyle = .light
            case 3:
                window.overrideUserInterfaceStyle = .dark
            default:
                window.overrideUserInterfaceStyle = .unspecified
            }
        }
    }
}
