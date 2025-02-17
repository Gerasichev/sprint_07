//import Foundation
//import UIKit
//
//final class MovieQuizPresenter: QuestionFactoryDelegate {
//    private weak var viewController: MovieQuizViewControllerProtocol?
//    private var questionFactory: QuestionFactoryProtocol?
//    private var statisticService: StatisticServiceProtocol?
//
//    private var currentQuestion: QuizQuestion?
//    private let questionsAmount: Int = 10
//    private var currentQuestionIndex: Int = 0
//    private var correctAnswers: Int = 0
//
//    init(viewController: MovieQuizViewControllerProtocol) {
//        self.viewController = viewController
//    }
//
//    func configure(with questionFactory: QuestionFactoryProtocol, statisticService: StatisticServiceProtocol) {
//        self.questionFactory = questionFactory
//        self.statisticService = statisticService
//        questionFactory.loadData()
//        viewController?.showLoadingIndicator()
//    }
//
//    func didLoadDataFromServer() {
//        viewController?.hideLoadingIndicator()
//        questionFactory?.requestNextQuestion()
//    }
//
//    func didFailToLoadData(with error: Error) {
//        let message = error.localizedDescription
//        viewController?.showNetworkError(message: message)
//    }
//
//    func didReceiveNextQuestion(question: QuizQuestion?) {  // Исправлено с didRecieve на didReceive
//        guard let question = question else {
//            return
//        }
//
//        currentQuestion = question
//        let viewModel = convert(model: question)
//        DispatchQueue.main.async { [weak self] in
//            self?.viewController?.show(quiz: viewModel)
//        }
//    }
//
//    func isLastQuestion() -> Bool {
//        return currentQuestionIndex == questionsAmount - 1
//    }
//
//    func didAnswer(isCorrectAnswer: Bool) {
//        if isCorrectAnswer {
//            correctAnswers += 1
//        }
//    }
//
//    func restartGame() {
//        currentQuestionIndex = 0
//        correctAnswers = 0
//        questionFactory?.requestNextQuestion()
//    }
//
//    func switchToNextQuestion() {
//        currentQuestionIndex += 1
//    }
//
//    func convert(model: QuizQuestion) -> QuizStepViewModel {
//        return QuizStepViewModel(
//            image: UIImage(data: model.image) ?? UIImage(),
//            question: model.text,
//            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
//        )
//    }
//
//    func yesButtonClicked() {
//        didAnswer(isYes: true)
//    }
//
//    func noButtonClicked() {
//        didAnswer(isYes: false)
//    }
//
//    private func didAnswer(isYes: Bool) {
//        guard let currentQuestion = currentQuestion else {
//            return
//        }
//
//        let givenAnswer = isYes
//
//        proceedWithAnswer(isCorrect: givenAnswer == currentQuestion.correctAnswer)
//    }
//
//    private func proceedWithAnswer(isCorrect: Bool) {
//        didAnswer(isCorrectAnswer: isCorrect)
//
//        viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
//            guard let self = self else { return }
//            self.proceedToNextQuestionOrResults()
//        }
//    }
//
//    private func proceedToNextQuestionOrResults() {
//        if self.isLastQuestion() {
//            let text = correctAnswers == self.questionsAmount ?
//            "Поздравляем, вы ответили на 10 из 10!" :
//            "Вы ответили на \(correctAnswers) из 10, попробуйте ещё раз!"
//
//            let viewModel = QuizResultsViewModel(
//                title: "Этот раунд окончен!",
//                text: text,
//                buttonText: "Сыграть ещё раз",
//                completion: { [weak self] in
//                    self?.restartGame()
//                }) 
//            viewController?.show(quiz: viewModel)
//        } else {
//            self.switchToNextQuestion()
//            questionFactory?.requestNextQuestion()
//        }
//    }
//
//
//    func makeResultsMessage() -> String {
//        statisticService?.store(correct: correctAnswers, total: questionsAmount)
//
//        let bestGame = statisticService?.bestGame
//
//        let totalPlaysCountLine = "Количество сыгранных квизов: \(statisticService?.gamesCount ?? 0)"
//        let currentGameResultLine = "Ваш результат: \(correctAnswers)\\\(questionsAmount)"
//        let bestGameInfoLine = "Рекорд: \(bestGame?.correct ?? 0)\\\(bestGame?.total ?? 0)"
//        + " (\(bestGame?.date.dateTimeString ?? ""))"
//        let averageAccuracyLine = "Средняя точность: \(String(format: "%.2f", statisticService?.totalAccuracy ?? 0))%"
//
//        let resultMessage = [
//        currentGameResultLine, totalPlaysCountLine, bestGameInfoLine, averageAccuracyLine
//        ].joined(separator: "\n")
//
//        return resultMessage
//    }
//}
