//Cheng Shi

import SwiftUI

struct ContentView: View {
    @State private var randomNumber = Int.random(in: 1...100) // Random number between 1 and 100
    @State private var correctCount = 0 // To track the correct answers
    @State private var wrongCount = 0 // To track the wrong answers
    @State private var feedback: String? = nil // To show feedback (green tick or red cross)
    @State private var attempts = 0 // Track number of attempts
    @State private var timer: Timer? = nil // Timer to change number every 5 seconds
    @State private var showDialog = false // To show dialog after 10 attempts
    
    var body: some View {
        VStack {
            // Display Random Number
            Text("\(randomNumber)")
                .font(.system(size: 50))
                .fontWeight(.bold)
                .padding()

            // Feedback (Green Tick or Red Cross)
            if let feedback = feedback {
                Text(feedback)
                    .font(.system(size: 30))
                    .foregroundColor(feedback == "✅" ? .green : .red)
                    .padding()
            }
            
            // Prime or Not Prime Buttons
            HStack {
                Button(action: {
                    checkAnswer(isPrime: true)
                }) {
                    Text("Prime")
                        .font(.title)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    checkAnswer(isPrime: false)
                }) {
                    Text("Not Prime")
                        .font(.title)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()

            // Show dialog after 10 attempts
            if showDialog {
                VStack {
                    Text("Game Over!")
                        .font(.title)
                        .padding()
                    Text("Correct Answers: \(correctCount)")
                    Text("Wrong Answers: \(wrongCount)")
                    Button("Reset") {
                        resetGame()
                    }
                    .padding()
                }
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 10)
                .padding()
            }
        }
        .onAppear(perform: startTimer)
        .alert(isPresented: $showDialog) {
            Alert(title: Text("Results"), message: Text("Correct Answers: \(correctCount)\nWrong Answers: \(wrongCount)"), dismissButton: .default(Text("OK")))
        }
    }
    
    // Function to check if the number is prime
    func isPrime(number: Int) -> Bool {
        if number <= 1 { return false }
        for i in 2..<number {
            if number % i == 0 { return false }
        }
        return true
    }
    
    // Function to check the user's answer
    func checkAnswer(isPrime: Bool) {
        let correctAnswer = isPrime(number: randomNumber)
        if isPrime == correctAnswer {
            feedback = "✅"
            correctCount += 1
        } else {
            feedback = "❌"
            wrongCount += 1
        }
        attempts += 1
        if attempts >= 10 {
            showDialog = true
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                feedback = nil
                randomNumber = Int.random(in: 1...100)
            }
        }
    }
    
    // Start the timer to change the number every 5 seconds
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            randomNumber = Int.random(in: 1...100)
            feedback = nil // Reset feedback each time the number changes
            if attempts < 10 {
                wrongCount += 1 // If no answer is selected, count as wrong
            }
        }
    }
    
    // Reset the game
    func resetGame() {
        correctCount = 0
        wrongCount = 0
        attempts = 0
        randomNumber = Int.random(in: 1...100)
        showDialog = false
        feedback = nil
        startTimer()
    }
}