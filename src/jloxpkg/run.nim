proc run(source: string) =
  discard

proc runPrompt* =
  while true:
    stdout.write "> "
    stdout.flushFile()
    try:
      let line = stdin.readLine()
      run(line)
    except EOFError:
      stdout.writeLine("")
      break

proc runFile*(path: string) =
  let source = open(path, fmRead).readAll()
  run(source)
