import Foundation

func read(file: String) -> [String]? {
    guard let fileContents = try? String(contentsOfFile: file, encoding: .utf8) else {
        print("Failed to read file")
            return nil
    }

    var lines = fileContents.components(separatedBy: "\n")

    if let lastLine = lines.last, lastLine.isEmpty {
        lines.removeLast()
    }

    return lines
}

enum InputType: String {
    case full = "./Input.txt"
    case sample = "./SampleInput.txt"
}

let file = InputType.full

guard let inputs = read(file: file.rawValue) else {
    print("Failed to open")
    exit(1)
}

let numberPattern = "[0-9]+"

let numbers = inputs.map { input in
    let regex = try! NSRegularExpression(pattern: numberPattern)

    let matches = regex.matches(in: input, range: NSRange(input.startIndex..., in: input))

    return matches.map { match in
        let range = Range(match.range, in: input)!
        return Int(input[range])!
    }
}

// MARK: - Helpers

func isReportSafe(scores: [Int]) -> Bool {
    scores.allSatisfy { level in
        level <= 3 && level >= 1
    }
}

func getReportScores(_ report: [Int]) -> [Int] {
    let scores = report.indices.dropLast().map { index -> Int in
        report[index + 1] - report[index]
    }

    if scores.allSatisfy({ $0 < 0 }) { 
        return scores.map { $0 * -1 }
    }

    return scores
}

func getReports() -> (safe: [[Int]], unsafe: [[Int]]) {
    let safeReports = numbers.filter { report in
        let reportScore = getReportScores(report)
        return isReportSafe(scores: reportScore)
    }

    let unsafeReports = numbers.filter { report in
        let reportScore = getReportScores(report)
        return !isReportSafe(scores: reportScore)
    }

    return (safe: safeReports, unsafe: unsafeReports)
}

// MARK: - Part One

func partOne() {
    let reports = getReports()
    print(reports.safe.count)
}

partOne()

// MARK: - Part Two

func partTwo() {
    // This is very inefficient but I'm a patient person :))
    let reports = getReports()

    var safeReports = reports.safe.count

    reports.unsafe.forEach { report in
        for index in report.indices {
            var mutableReport = report

            mutableReport.remove(at: index)

            let reportScores = getReportScores(mutableReport)

            if isReportSafe(scores: reportScores) {
                safeReports += 1
                return
            }
        }
    }

    print(safeReports)
}

partTwo()

