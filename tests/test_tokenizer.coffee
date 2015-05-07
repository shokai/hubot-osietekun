path = require 'path'
require path.resolve 'tests', 'test_helper'

assert    = require 'assert'
Tokenizer = require path.resolve 'libs', 'tokenizer'

describe 'tokenizer', ->

  it 'sohuld have methods "getTokens", "getNouns"', ->
    @timeout 5000

    Tokenizer.build().then (tokenizer) ->
      assert.equal typeof tokenizer['getTokens'], 'function'
      assert.equal typeof tokenizer['getNouns'], 'function'

  describe 'method "getToken"', ->

    it 'should returns tokens', ->
      Tokenizer.build()
      .then (tokenizer) ->
        tokens = tokenizer.getTokens "kuromoji、最初から辞書が内蔵されてるからrequireしてすぐ使えて凄い"
        assert.equal true, tokens instanceof Array

  describe 'method "getNouns"', ->

    it 'should returns nouns', ->
      Tokenizer.build()
      .then (tokenizer) ->
        nouns = tokenizer.getNouns "すもももももももものうち"
        console.log nouns
        assert.deepEqual nouns, ['すもも','もも','うち']

    it 'should returns joined nouns', ->
      Tokenizer.build()
      .then (tokenizer) ->
        nouns = tokenizer.getNouns 'hubot、なんかメモリリークしてる。'
        console.log nouns
        assert.deepEqual nouns, ['hubot','メモリ','リーク','メモリリーク']

    it 'should register URL', ->
      Tokenizer.build()
      .then (tokenizer) ->
        nouns = tokenizer.getNouns 'ここから https://www.npmjs.com/package/hubot-osietekun インストールできる'
        console.log nouns
        assert.deepEqual nouns, ['ここ','インストール']
