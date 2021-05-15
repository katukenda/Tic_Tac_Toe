//
//  GameViewModel.swift
//  Tic-Tac-Toe
//
//  Created by Janitha Katukenda on 2021-05-15.
//

import SwiftUI

final class GameViewModel: ObservableObject {
    
    let columns : [GridItem] = [GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible()),]
    
    @Published var moves: [Move?] = Array(repeating: nil, count: 9)
    @Published var isGameBoardDisabled = false
    @Published var alertItem: AlertItem?
    
    
    func proccessPlayermove(for position :Int) {
        if isSquareOccupied(in: moves, forIndex: position) { return }
        moves[position] = Move(player: .human , boardIndex: position)
        
        //cgeck for win condition or drow
        
        if checkWindCondition(for: .human, in: moves) {
            alertItem = AlertContext.humanWin
            return
        }
        if checkForDrow(in: moves) {
            alertItem = AlertContext.drow
            return
        }
        isGameBoardDisabled = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { [self] in
            let computerPosition = determinComputerMovePosition(in: moves)
            moves[computerPosition] = Move(player: .computer , boardIndex: computerPosition)
            isGameBoardDisabled = false
            
            if checkWindCondition(for: .computer, in: moves) {
                alertItem = AlertContext.computerWin
                return
            }
            if checkForDrow(in: moves) {
                alertItem = AlertContext.drow
                return
            }
        }
    }
    func isSquareOccupied(in moves: [Move?], forIndex index: Int) -> Bool {
        return moves.contains(where: { $0?.boardIndex == index})
    }
    func determinComputerMovePosition(in moves: [Move?]) -> Int {
        
        //If AI can win , then win
        let winPatterns: Set<Set<Int>> = [[0,1,2], [3,4,5], [6,7,8], [0,3,6],[1,4,7], [2,5,8], [0,4,8], [2,4,6]]
        let computerMoves = moves.compactMap { $0 }.filter { $0.player == .computer }
        let computerPosition = Set(computerMoves.map { $0.boardIndex })
        
        for pattern in winPatterns {
            let winPosition = pattern.subtracting(computerPosition)
            
            if winPosition.count == 1 {
                let isAvailable = !isSquareOccupied(in: moves, forIndex: winPosition.first!)
                if isAvailable { return winPosition.first! }
            }
        }
        
        // If AI can't win, then block
        let humanMoves = moves.compactMap { $0 }.filter { $0.player == .human }
        let humanPosition = Set(humanMoves.map { $0.boardIndex })
        
        for pattern in winPatterns {
            let winPosition = pattern.subtracting(humanPosition )
            
            if winPosition.count == 1 {
                let isAvailable = !isSquareOccupied(in: moves, forIndex: winPosition.first!)
                if isAvailable { return winPosition.first! }
            }
        }
        //If Ai can't block, then take middle block
        let centerAquare = 4
        if !isSquareOccupied(in: moves, forIndex: centerAquare) {
            return centerAquare
        }
        
        //If AI can't take middle square, take random available square
        var movePosition = Int.random(in: 0..<9)
        
        while isSquareOccupied(in: moves, forIndex: movePosition) {
            movePosition = Int.random(in: 0..<9)
        }
        
        return movePosition
    }
    
    func checkWindCondition(for player: Player, in moves: [Move?]) -> Bool {
        let winPatterns: Set<Set<Int>> = [[0,1,2], [3,4,5], [6,7,8], [0,3,6],[1,4,7], [2,5,8], [0,4,8], [2,4,6]]
        
        let playerMoves = moves.compactMap { $0 }.filter { $0.player == player }
        let playerPosition = Set(playerMoves.map { $0.boardIndex })
        
        for pattern in winPatterns where pattern.isSubset(of: playerPosition) {
            return true
        }
        return false
    }
    
    func checkForDrow(in moves: [Move?]) -> Bool {
        return moves.compactMap { $0 }.count == 9
    }
    func resetGame() {
        moves = Array(repeating: nil, count: 9)
    }
    
    enum Player {
        case human, computer
    }
    
    struct Move {
        let player: Player
        let boardIndex: Int
        
        var indicator: String {
            return player == .human ? "xmark" : "circle"
        }
    }
}
