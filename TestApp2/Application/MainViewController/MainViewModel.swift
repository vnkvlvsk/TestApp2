import UIKit

final class MainViewModel {
    
    // MARK: - Public properties
    
    var isTimerEnabled = false
    var isStartButtonPressed = false
    
    var dataSource: [MainElementModel] = []
    
    // MARK: - Public methods
    
    func executeActions() throws {
        if dataSource.count < 5 {
            try appendElement()
        } else {
            let randomIndex = Int.random(in: 0..<dataSource.count)
            try executeRandomAction(index: randomIndex)
        }
    }
    
    func addValueOfElement(index: Int) {
        if index != 0 {
            let numberBefore = dataSource[index - 1].number
            dataSource[index].number += numberBefore
        }
    }
    
    // MARK: - Private methods
    
    private func executeRandomAction(index: Int) throws {
        let action = try getRandomAction()
        
        switch action {
        case .increment:
            incrementElement(index: index)
        case .reset:
            resetElement(index: index)
        case .delete:
            deleteElement(index: index)
        case .addValue:
            addValueOfElement(index: index)
        }
    }
    
    private func getRandomAction() throws -> ElementAction {
        var randomActions = [ElementAction]()
        
        randomActions += Array(repeating: .increment, count: 5)
        randomActions += Array(repeating: .reset, count: 3)
        randomActions += Array(repeating: .delete, count: 1)
        randomActions += Array(repeating: .addValue, count: 1)
        
        guard let randomElement = randomActions.randomElement() else {
            throw MainViewModelError.failToGetRandomElement
        }
        
        return randomElement
    }
    
    private func appendElement() throws {
        let newElement = try createNewElement()
        dataSource.append(newElement)
    }
    
    private func incrementElement(index: Int) {
        dataSource[index].number += 1
    }
    
    private func resetElement(index: Int) {
        dataSource[index].number = 0
    }
    
    private func deleteElement(index: Int) {
        dataSource.remove(at: index)
    }
    
    private func createNewElement() throws -> MainElementModel {
        let possibleColors = [UIColor.red, UIColor.blue]
        
        guard let randomColor = possibleColors.randomElement() else {
            throw MainViewModelError.failToGetRandomElement
        }
        
        let randomNumber = Int.random(in: 1...100)
        
        if randomColor == UIColor.red {
            let element = MainElementModel(number: 3 * randomNumber, color: randomColor)
            return element
        } else {
            let element = MainElementModel(number: randomNumber, color: randomColor)
            return element
        }
    }
}

extension MainViewModel {
    enum ElementAction {
        case increment, reset, delete, addValue
    }
    
    enum MainViewModelError: Error {
        case failToGetRandomElement
    }
}
