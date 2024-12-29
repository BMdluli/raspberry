//
//  SecureTextFieldWithLabel.swift
//  Trezo
//
//  Created by Bekithemba Mdluli on 2024/09/29.
//

import SwiftUI

struct SecureTextFieldWithLabel: View {
    @Binding var text: String
    
    let title: String
    let placeholder: String
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
            SecureField(placeholder, text: $text)
                .padding()
                .frame(height: 65)
                .background(.textField)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}

//#Preview {
//    SecureTextFieldWithLabel()
//}
