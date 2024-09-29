//
//  TextFieldWithLabel.swift
//  Trezo
//
//  Created by Bekithemba Mdluli on 2024/09/12.
//

import SwiftUI

struct TextFieldWithLabel: View {
    @Binding var text: String
    
    let title: String
    let placeholder: String
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
            TextField(placeholder, text: $text)
                .padding()
                .frame(height: 65)
                .background(.textField)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}

//#Preview {
//    TextFieldWithLabel(text: Binding<String>, title: "test", placeholder: "test")
//}
