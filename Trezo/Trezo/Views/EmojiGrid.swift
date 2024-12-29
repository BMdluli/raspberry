//
//  EmojiGrid.swift
//  Trezo
//
//  Created by Bekithemba Mdluli on 2024/11/28.
//

import SwiftUI

struct EmojiGrid: View {
    let emojis = ["🏠", "🎉", "📚", "🛒", "⚽️", "🐶", "🌟", "⛑️", "🎵", "💡", "🍼", "🐈"]
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ] // Two rows

    @Binding var showModal: Bool
    @Binding var selectedEmoji: String
    
    var body: some View {
        VStack(spacing: 20) {

            Text("Add Cover")
                .font(.system(size: 22, weight: .bold))
            Divider()
            ScrollView(.horizontal) {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(emojis, id: \.self) { emoji in
                        Button {
                            selectedEmoji = emoji
                            showModal = false
                        } label: {
                            Text(emoji)
                                .font(.system(size: 50))
                                .frame(width: 80, height: 80)
                                .background(.primaryPurple.opacity(0.1))
                                .cornerRadius(10)
                        }
                    }
                }
                .padding()
            }
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
}

#Preview {
//    EmojiGrid(showModal: true)
}
