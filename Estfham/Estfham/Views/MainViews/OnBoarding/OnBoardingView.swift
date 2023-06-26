import SwiftUI
import Firebase
import GoogleSignIn
import FirebaseCore
import Lottie

struct OnBoardingView: View {
    // MARK: - INTROS
    @State var intros: [Intro] = [
        Intro(title: "Dive In!", subTitle: "Ignite your brain with Estfhsm.", lottieAnimationName: "quiz", color: Color("EPink")),
        Intro(title: "Flexibility at Its Best.", subTitle: "Quiz on any screen.", lottieAnimationName: "girl", color: Color("EOrange")),
        Intro(title: "Socialize Your Quizzes!", subTitle: "group Your activity.", lottieAnimationName: "online", color: Color("EPurple")),
    ]
    
    // MARK: - GESTURE PROPERTIES
    @GestureState var isDragging: Bool = false
    
    @State var fakeIndex: Int = 0
    @State var currentIndex: Int = 0
    
    @StateObject private var googleAuthViewModel = GoogleAuthViewModel() // Create an instance of the view model
    
    var body: some View {
        ZStack {
            ForEach(intros.indices.reversed(), id: \.self) { index in
                //Intro View
                IntroView(intro: intros[index])
                    .clipShape(LiquidShape(offset: intros[index].offset, curvePoint: fakeIndex == index ? 50 : 0))
                    .padding(.trailing, fakeIndex == index ? 15: 0)
                    .ignoresSafeArea()
            }
            
            HStack(spacing: 8) {
                ForEach(0..<intros.count - 2, id: \.self) { index in
                    Circle()
                        .fill(.black)
                        .frame(width: 8, height: 8)
                        .scaleEffect(currentIndex == index ? 1.15 : 0.85)
                        .opacity(currentIndex == index ? 1 : 0.25)
                }
                
                Spacer()
                
                // Google button
                Button(action: {
                    googleAuthViewModel.signInWithGoogle() // Call the signInWithGoogle() method of the view model
                }, label: {
                    HStack{
                        Image("google")
                            .resizable()
                            .frame(width: 25, height: 25)
                            

                        Text("continue with Google")
                            .foregroundColor(Color.black)
                            .bold()
                        
                    }   .padding()                    .background(Color.white)
                        .cornerRadius(20)
                        .shadow(color: Color.black.opacity(0.4), radius: 4, x: 0, y: 2)

                })
                .padding(.trailing, 20)
                .padding(.bottom, 20)
            }
            .padding()
            .padding(.horizontal)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        }
        .overlay(
            Button(action: {
                
            }, label: {
                Image(systemName: "chevron.right")
                    .font(.largeTitle)
                    .frame(width: 50, height: 50)
                    .foregroundColor(.black)
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture()
                            .updating($isDragging, body: {value, out, _ in
                                out = true
                            })
                            .onChanged({ value in
                                withAnimation(.interactiveSpring(response: 0.7, dampingFraction: 0.6, blendDuration: 0.6)){
                                    intros[fakeIndex].offset = value.translation
                                }
                            })
                            .onEnded({value in
                                withAnimation(.spring()){
                                    if -intros[fakeIndex].offset.width > getRect().width / 2 {
                                        intros[fakeIndex].offset.width = -getRect().height * 1.5
                                        
                                        fakeIndex += 1
                                        
                                        // MARK: - UPDATE ORIGINAL INDEX
                                        if currentIndex == intros.count - 3 {
                                            currentIndex = 0
                                        } else {
                                            currentIndex += 1
                                        }
                                        
                                        // MARK: - RESETING INDEX
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                            if fakeIndex == (intros.count - 2) {
                                                for index in 0..<intros.count - 2{
                                                    intros[index].offset = .zero
                                                }
                                                
                                                fakeIndex = 0
                                            }
                                        }
                                        
                                    } else {
                                        intros[fakeIndex].offset = .zero
                                    }
                                }
                            })
                    )
                
            })
            .offset(y: 53)
            .opacity(isDragging ? 0 : 1)
            .animation(.linear, value: isDragging),
            alignment: .topTrailing
        )
        .onAppear {
            guard let first = intros.first else {
                return
            }
            
            guard var last = intros.last else {
                return
            }
            
            last.offset.width = -getRect().height * 1.5
            
            intros.append(first)
            intros.insert(last, at: 0)
            
            fakeIndex = 1
        }
        .fullScreenCover(isPresented: $googleAuthViewModel.isLoginSuccessed) {
            ContentView() // Present ContentView when login is successful
        }
    }
}



struct OnBoardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingView()
    }
}

