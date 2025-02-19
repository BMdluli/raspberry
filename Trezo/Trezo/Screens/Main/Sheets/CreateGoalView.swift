//
//  CreateGoalView.swift
//  Trezo
//
//  Created by Bekithemba Mdluli on 2024/09/29.
//

import SwiftUI
import FirebaseAuth


struct CreateGoalView: View {
    
    let userID = Auth.auth().currentUser?.uid
    
    @StateObject private var viewModel = GoalViewModel()
    
    @State private var showEmojiModal = false
    
    @State private var selectedEmoji = ""
    
    @Binding var showModal: Bool
    @Binding var shouldRefresh: Bool
    
    @State private var date = Date.now
    
    enum Currency: String, CaseIterable, Identifiable {
        case rand = "Rand (R)"
        case dollar = "Dollar ($)"
        case euro = "Euro (€)"
        case pound = "Pound (£)"
        var id: Self { self }
    }
    
    
    @State private var selectedCurrency: Currency = .rand
    
    let currencies: [String] = [
        "Rand (R)",
        "Dollar ($)",
        "Euro (€)",
        "Pound (£)"
    ]
    
    @State private var goalName: String = ""
    @State private var note: String = ""
    @State private var amount: String = ""
    
    let goalColors: [String] = [
        "PrimaryPurple",
        "BrandGreen",
        "BrandLightBlue",
        "BrandRed",
        "PrimaryOrange"
    ]
    
    @State private var selectedColor: String = "BrandRed"
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                HStack {
                    Button {
                        showModal = false
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(.treAlertnateBackground)
                    }
                    
                    Spacer()
                    Text("Create New Goal")
                        .font(.system(size: 20, weight: .semibold))
                    Spacer()
                }
                
                Button {
                    showEmojiModal = true
                } label: {
                    VStack(spacing: 10) {
                        ZStack {
                            Circle()
                                .strokeBorder(.gray, lineWidth: 1)
                                .frame(width: 100, height: 100)
                                .background(Color(.systemBackground))
                            
                            
                            if selectedEmoji.isEmpty {
                                Image(systemName: "plus")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.treAlertnateBackground)
                            } else {
                                Text(selectedEmoji)
                                    .font(.system(size: 50))
                                    .frame(width: 80, height: 80)
                            }
                        }
                        
                        Text("Add Cover")
                            .foregroundStyle(.gray)
                    }
                }
                
                Divider()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        TextFieldWithLabel(text: $goalName, title: "Goal Name", placeholder: "e.g. Vacation, New car, etc.")
                        
                        TextFieldWithLabel(text: $amount, title: "Goal Amount", placeholder: "10.000")
                            .keyboardType(.numberPad)
                        
                        
                        VStack(alignment: .leading) {
                            Text("Currency")
                            HStack {
                                Text("Select Currency")
                                Spacer() // Pushes the currency picker to the right
                                Picker(selection: $selectedCurrency, label: Text(selectedCurrency.rawValue)
                                    .foregroundColor(.blue)
                                    .underline()
                                ) {
                                    ForEach(Currency.allCases) { currency in
                                        Text(currency.rawValue).tag(currency)
                                    }
                                }
                                
                                .pickerStyle(MenuPickerStyle()) // Dropdown style
                            }
                            .padding()
                            .frame(height: 65)
                            .background(.textField)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        
                        DatePicker("Deadline (Optional)",
                                   selection: $date, displayedComponents: .date)
                        .frame(height: 56)
                        
                        
                        
                        TextFieldWithLabel(text: $note, title: "Note Optional", placeholder: "Add your note.")
                        Text("Colour")
                        HStack(alignment: .center, spacing: 16) { // You can adjust `spacing` as needed
                            ForEach(goalColors, id: \.self) { goalColor in
                                Button {
                                    selectedColor = goalColor
                                } label: {
                                    Circle()
                                        .stroke(selectedColor == goalColor ? .gray : .white, lineWidth: 8)
                                        .fill(Color(goalColor))
                                        .frame(width: 50, height: 50)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 5)
                        
                    }
                    
                    Spacer()
                    
                    Divider()
                    
                    HStack(spacing: 30) {
                        Button {
                            showModal = false
                        } label: {
                            Text("Cancel")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(TreButtonStyle(backgroundColor: .treLightGray, textColor: .primaryPurple))
                        
                        Button {
                            if let amountDbl = Double(amount) {
                                viewModel.createNewGoal(goal: FirebaseGoal(coverImage: selectedEmoji, goalAmount: amountDbl, goalAmountContributed: [GoalAmountContributed()], goalColour: selectedColor, goalCurrency: selectedCurrency.rawValue, goalDeadline: date, goalName: goalName, goalNote: note, userId: userID!))
                            }
                            
                            
                        } label: {
                            Text("Save")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(TreButtonStyle(backgroundColor: .primaryPurple, textColor: .white))
                    }
                }
                
                
                

                
                
            }
            .padding(.horizontal)
            .onChange(of: viewModel.isCreated) { oldValue, newValue in
                if newValue {
                    showModal = false
                    shouldRefresh = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        viewModel.isUpdated = false
                    }
                }
            }
            .sheet(isPresented: $showEmojiModal) {
                EmojiGrid(showModal: $showEmojiModal, selectedEmoji: $selectedEmoji)
            }
            .padding()
            .ignoresSafeArea(.keyboard)
        }
        
        if viewModel.isLoading {
            LoadingOverlay()
        }
        
        
    }
}

#Preview {
    // Helper to see the fullscreen modal in Preview
    ContentPreviewWrapper()
}


struct ContentPreviewWrapper: View {
    @State private var showModal = true // Set to true for preview
    @State private var shouldRefresh = false
    
    var body: some View {
        ContentView()
            .fullScreenCover(isPresented: $showModal) {
                CreateGoalView(showModal: $showModal, shouldRefresh: $shouldRefresh)
            }
    }
}
