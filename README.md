# Advent of Code 2024 🎄

## Useful commands

Compile & run (if successful):

```shell
swiftc -o a main.swift && ./a
```


## Template code

Open and read a file's contents:

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

enum InputType: String {
    case full = "./Input.txt"
    case sample = "./SampleInput.txt"
}

let file: InputType = .full

guard let inputs = read(file: file.rawValue) else {
    print("Failed to open")
    exit(1)
}

```

## Other

CoC settings to enable Swift and Objective-C (clang) LSPs

```json
{
    "languageserver": {
        "clangd": {
            "command": "clangd",
            "rootPatterns": ["compile_flags.txt", "compile_commands.json"],
            "filetypes": ["c", "cc", "cpp", "c++", "objc", "objcpp"]
        },
	"swift": {
		"command": "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/sourcekit-lsp",
		"rootPatterns": ["Package.swift"],
		"filetypes": ["swift"]
	}
    }
}
```
