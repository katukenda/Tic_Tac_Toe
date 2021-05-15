    //
    //  GameView.swift
    //  Tic-Tac-Toe
    //
    //  Created by Janitha Katukenda on 2021-05-15.
    //
    
    import SwiftUI
    
    struct GameView: View {
        
        @StateObject private var viewModel = GameViewModel()
        
        var body: some View {
            
            GeometryReader{ geometry in
                VStack{
                    Spacer()
                    LazyVGrid(columns: viewModel.columns, spacing: 5){
                        
                        ForEach(0..<9) { i in
                            ZStack {
                                Circle()
                                    .foregroundColor(.red)
                                    .opacity(0.5)
                                    .frame(width: geometry.size.width/3 - 15, height: geometry.size.width/3 - 15)
                                
                                Image(systemName: viewModel.moves[i]?.indicator ?? "")
                                    .resizable()
                                    .frame(width: 40, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                    .foregroundColor(.white)
                            }
                            .onTapGesture {
                                
                                viewModel.proccessPlayermove(for: i)
                            }
                        }
                    }
                    Spacer()
                }
                .disabled(viewModel.isGameBoardDisabled)
                .padding()
                .alert(item: $viewModel.alertItem, content: {
                    alertItem in
                    Alert(title: alertItem.title,
                          message: alertItem.message,
                          dismissButton: .default(alertItem.buttonTitle, action:  {viewModel.resetGame()} ))
                })
                
            }
            
        }
        
        struct ContentView_Previews: PreviewProvider {
            static var previews: some View {
                GameView()
                    .preferredColorScheme(.dark)
            }
        }
    }
