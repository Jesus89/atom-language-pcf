describe 'PCF grammar', ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage('language-pcf')
    runs ->
      grammar = atom.grammars.grammarForScopeName('source.pcf')

  it 'parses the grammar', ->
    expect(grammar).toBeTruthy()
    expect(grammar.scopeName).toBe 'source.pcf'

  it 'tokenizes comments', ->
    tokens = grammar.tokenizeLines('# comment\n set_io # other comment')
    expect(tokens[0][0]).toEqual value: '# comment', scopes: ['source.pcf', 'comment.line.number-sign.pcf']
    expect(tokens[1][2]).toEqual value: '# other comment', scopes: ['source.pcf', 'comment.line.number-sign.pcf']

  it 'tokenizes set_io', ->
    {tokens} = grammar.tokenizeLine('set_io')
    expect(tokens[0]).toEqual value: 'set_io', scopes: ['source.pcf', 'keyword.other.pcf']

    {tokens} = grammar.tokenizeLine('set_io --warn-no-port')
    expect(tokens[0]).toEqual value: 'set_io', scopes: ['source.pcf', 'keyword.other.pcf']
    expect(tokens[2]).toEqual value: '--warn-no-port', scopes: ['source.pcf', 'entity.name.tag.pcf']

    {tokens} = grammar.tokenizeLine('set_io CLK 21')
    expect(tokens[0]).toEqual value: 'set_io', scopes: ['source.pcf', 'keyword.other.pcf']
    expect(tokens[2]).toEqual value: 'CLK', scopes: ['source.pcf', 'variable.parameter.pcf']
    expect(tokens[4]).toEqual value: '21', scopes: ['source.pcf', 'constant.numeric.pcf']

    {tokens} = grammar.tokenizeLine('set_io --warn-no-port CLK 21')
    expect(tokens[0]).toEqual value: 'set_io', scopes: ['source.pcf', 'keyword.other.pcf']
    expect(tokens[2]).toEqual value: '--warn-no-port', scopes: ['source.pcf', 'entity.name.tag.pcf']
    expect(tokens[4]).toEqual value: 'CLK', scopes: ['source.pcf', 'variable.parameter.pcf']
    expect(tokens[6]).toEqual value: '21', scopes: ['source.pcf', 'constant.numeric.pcf']
