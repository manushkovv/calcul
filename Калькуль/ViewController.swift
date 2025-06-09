import UIKit

class ViewController: UIViewController {

    // Элементы интерфейса
    var resultLabel = UILabel()
    var buttons: [UIButton] = []

    // Переменные для логики калькулятора
    var currentInput = ""
    var firstNumber: Double = 0
    var currentOperation: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // Настройка интерфейса
    func setupUI() {
        // Настройка фона
        view.backgroundColor = .white

        // Настройка resultLabel
        resultLabel.text = "0"
        resultLabel.textAlignment = .right
        resultLabel.font = UIFont.systemFont(ofSize: 40)
        resultLabel.backgroundColor = .white
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(resultLabel)

        // Добавление ограничений для resultLabel
        NSLayoutConstraint.activate([
            resultLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            resultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            resultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            resultLabel.heightAnchor.constraint(equalToConstant: 80)
        ])

        // Создание кнопок
        let buttonTitles = ["7", "8", "9", "/",
                            "4", "5", "6", "*",
                            "1", "2", "3", "-",
                            "C", "0", "=", "+"]
        var row = 0
        var column = 0

        for title in buttonTitles {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 24)
            button.backgroundColor = .darkGray
            button.setTitleColor(.white, for: .normal)
            button.layer.cornerRadius = 10
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)

            view.addSubview(button)
            buttons.append(button)

            // Добавление ограничений для кнопок
            NSLayoutConstraint.activate([
                button.widthAnchor.constraint(equalToConstant: 80),
                button.heightAnchor.constraint(equalToConstant: 80),
                button.topAnchor.constraint(equalTo: resultLabel.bottomAnchor, constant: 20 + CGFloat(row) * 90),
                button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: CGFloat(column) * 90 + 20)
            ])

            column += 1
            if column > 3 {
                column = 0
                row += 1
            }
        }
    }

    // Обработка нажатий на кнопки
    @objc func buttonTapped(_ sender: UIButton) {
        guard let title = sender.titleLabel?.text else { return }

        if let number = Int(title) {
            // Обработка цифр
            currentInput += String(number)
            resultLabel.text = currentInput
        } else if ["+", "-", "*", "/"].contains(title) {
            // Обработка операций
            if !currentInput.isEmpty {
                firstNumber = Double(currentInput) ?? 0
                currentOperation = title
                currentInput = ""
            }
        } else if title == "=" {
            // Обработка результата
            if !currentInput.isEmpty {
                let secondNumber = Double(currentInput) ?? 0
                var result = 0.0

                switch currentOperation {
                case "+": result = firstNumber + secondNumber
                case "-": result = firstNumber - secondNumber
                case "*": result = firstNumber * secondNumber
                case "/": result = firstNumber / secondNumber
                default: break
                }

                resultLabel.text = String(result)
                currentInput = ""
                firstNumber = 0
                currentOperation = ""
            }
        } else if title == "C" {
            // Очистка поля
            currentInput = ""
            firstNumber = 0
            currentOperation = ""
            resultLabel.text = "0"
        }
    }
}
