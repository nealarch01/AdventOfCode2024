# Advent of Code 2024 🎄

## Useful commands

Compile & run (if successful)
```shell
swiftc -o a main.swift && ./a
```


## Template code

To open and read a file

```swift
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

let path = "./Input.txt"

guard let input = read(file: path) else {
    print("Failed to open")
    exit(1)
}

```

