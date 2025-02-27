//
//  CreateGoalView.swift
//  Trezo
//
//  Created by Bekithemba Mdluli on 2024/09/29.
//

import SwiftUI
import FirebaseAuth


struct EditGoalView: View {
    let id: String
    let userID = Auth.auth().currentUser?.uid
    
    @Binding var shouldRefetch: Bool
    
    //    @StateObject private var viewModel = GoalViewModel()
    @ObservedObject var viewModel: GoalViewModel
    
    @Binding var showModal: Bool
    
    @State private var date = Date.now
    
    enum Currency: String, CaseIterable, Identifiable {
        case rand = "R"
        case dollar = "$"
        case euro = "€"
        case pound = "£"
        var id: Self { self }
    }
    
    
    @State private var selectedCurrency: Currency = .rand
    
    
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
    
    @State private var selectedEmoji = ""
    @State private var showEmojiModal = false
    @State private var selectedColor: String = "BrandRed"
    
    
    var body: some View {
        ScrollView {
            ZStack {
                VStack {
                    VStack(spacing: 20) {
                        
                        HStack {
                            Button {
                                showModal = false
                            } label: {
                                Image(systemName: "xmark")
                                    .foregroundStyle(.treAlertnateBackground)
                            }
                            
                            Spacer()
                            Text("Edit Goal")
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
                                    
                                    Text(selectedEmoji)
                                        .font(.system(size: 50))
                                        .frame(width: 80, height: 80)
                                    
                                    
                                }
                                
                                Text("Change Cover")
                                    .foregroundStyle(.gray)
                            }
                        }
                        
                        Divider()
                        
                        
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
                                            .stroke(selectedColor == goalColor ? .gray : .radioButtonBackground, lineWidth: 8)
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
                                    viewModel.updateGoal(id: id, updateGoal: UpdateGoalBody(coverImage: selectedEmoji, goalName: goalName, goalAmount: amountDbl, goalCurrency: selectedCurrency.rawValue, goalDeadline: date, goalColour: selectedColor, goalNote: note))
                                }
                                
                                
                                
                                
                            } label: {
                                Text("Save")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(TreButtonStyle(backgroundColor: .primaryPurple, textColor: .white))
                            .disabled(viewModel.isLoading)
                        }
                        

                        
                        
                    }

                }
                .onTapGesture {
                    UIApplication.shared.endEditing()
                }
                
                if viewModel.isLoading {
                    Color.black.opacity(0.5)
                        .edgesIgnoringSafeArea(.all)
                        .transition(.opacity) // Smooth fade-in effect
                    
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                }
                
                
            }
            .animation(.easeInOut, value: viewModel.isLoading)
            .padding(.horizontal)
            .onChange(of: viewModel.isUpdated) { oldValue, newValue in
                if newValue {
                    
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        showModal = false
                        viewModel.isUpdated = false
                        shouldRefetch = true
                    }
                }
            }
            .onReceive(viewModel.$goal) { goal in
                goalName = goal.goalName
                amount = String(goal.goalAmount)
                date = goal.goalDeadline
                note = goal.goalNote
                selectedEmoji = goal.coverImage
            }
            .alert("Error", isPresented: $viewModel.showAlert) {
                Button("OK", role: .cancel) { } // Correct, single button
            } message: {
                Text(viewModel.errorMessage ?? "Unknown error") // Prevents force unwrap
            }
            .sheet(isPresented: $showEmojiModal) {
                EmojiGrid(showModal: $showEmojiModal, selectedEmoji: $selectedEmoji)
            }
            .padding()
        }
    }
}

//#Preview {
//    // Helper to see the fullscreen modal in Preview
//    ContentPreviewWrapperr()
//}
//
//
//private struct ContentPreviewWrapperr: View {
//    @State private var showModal = true // Set to true for preview
//
//    var body: some View {
//        ContentView()
//            .fullScreenCover(isPresented: $showModal) {
//                EditGoalView(id: "6739aad1fd11df244f4f1bd8", shouldRefetch: $showModal, viewModel: <#GoalViewModel#>, showModal: $showModal)
//            }
//    }
//}
