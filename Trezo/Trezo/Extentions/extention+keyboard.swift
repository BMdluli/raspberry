//
//  extention+keyboard.swift
//  Trezo
//
//  Created by Bekithemba Mdluli on 2025/02/26.
//

import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
