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
    
    @StateObject private var viewModel = GoalViewModel()
    
    var swiftTV = 556959600;
    
    @Binding var showModal: Bool
    
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
    
    var body: some View {
        
        VStack {
            if viewModel.isLoading {
                ProgressView("Loading...") // Show loading indicator
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            } else {
                
                
                VStack(spacing: 20) {
                    
                    if viewModel.isLoading {
                        ProgressView()
                    }
                    
                    HStack {
                        Button {
                            showModal = false
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundStyle(.black)
                        }
                        
                        Spacer()
                        Text("Edit Goal")
                            .font(.system(size: 20, weight: .semibold))
                        Spacer()
                    }
                    
                    Button {
                        
                    } label: {
                        VStack(spacing: 10) {
                            ZStack {
                                Circle()
                                    .strokeBorder(.gray, lineWidth: 1)
                                    .frame(width: 100, height: 100)
                                    .background(Color(.systemBackground))
                                
                                
                                Image("Plus")
                                
                            }
                            
                            Text("Change Cover")
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
                                        print(goalColor)
                                    } label: {
                                        Circle()
                                            .fill(Color(goalColor))
                                            .frame(width: 48, height: 48)
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading) // Expands HStack and aligns contents to the left
                            
                        }
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
                                //                                viewModel.createNewGoal(goal: CreateGoal(coverImage: "😄", goalName: goalName, goalAmount: amountDbl, goalAmountContributed: 0, goalCurrency: selectedCurrency.rawValue, goalDeadline: , goalNote: note, goalColour: "BrandGreen", userId: userID!))
                                viewModel.updateGoal(id: id, updateGoal: UpdateGoalBody(coverImage: "😏", goalName: goalName, goalAmount: amountDbl, goalCurrency: selectedCurrency.rawValue, goalDeadline: date.timeIntervalSince1970 * 1000, goalColour: "BrandRed", goalNote: note))
                            }
                            
                            
                            
                            
                        } label: {
                            Text("Save")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(TreButtonStyle(backgroundColor: .primaryPurple, textColor: .white))
                    }
                    
                    
                }
                .padding(.horizontal)
                .onChange(of: viewModel.isUpdated) { oldValue, newValue in
                    print("onChange triggered: isCreated changed from \(oldValue) to \(newValue)")
                    if newValue {
                        showModal = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            viewModel.isUpdated = false
                        }
                    }
                }
                .onAppear() {
                    viewModel.fetchGoal(id: id)
                }
                .onReceive(viewModel.$goal) { goal in
                    goalName = goal.goalName
                    amount = String(goal.goalAmount)
                    date = goal.goalDeadline ?? Date.now
                    note = goal.goalNote ?? ""
                }
            }
        }
    }
}

#Preview {
    // Helper to see the fullscreen modal in Preview
    ContentPreviewWrapperr()
}


private struct ContentPreviewWrapperr: View {
    @State private var showModal = true // Set to true for preview
    
    var body: some View {
        ContentView()
            .fullScreenCover(isPresented: $showModal) {
                EditGoalView(id: "6739aad1fd11df244f4f1bd8", showModal: $showModal)
            }
    }
}
