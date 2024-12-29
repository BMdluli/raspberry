//
//  LoadingView.swift
//  Trezo
//
//  Created by Bekithemba Mdluli on 2024/12/12.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ProgressView("Loading...") // Show loading indicator
            .progressViewStyle(CircularProgressViewStyle())
            .padding()
    }
}

#Preview {
    LoadingView()
}
