path = require 'path'
require path.resolve 'tests', 'test_helper'

assert    = require 'assert'
Tokenizer = require path.resolve 'libs', 'tokenizer'

describe 'tokenizer', ->

  it 'sohuld have methods "getTokens", "getNouns"', (done) ->
    @timeout 5000

    Tokenizer.build().then (tokenizer) ->
      assert.equal typeof tokenizer['getTokens'], 'function'
      assert.equal typeof tokenizer['getNouns'], 'function'
      done()

  describe 'method "getToken"', ->

    it 'should returns tokens', (done) ->
      Tokenizer.build()
      .then (tokenizer) ->
        tokens = tokenizer.getTokens "kuromoji、最初から辞書が内蔵されてるからrequireしてすぐ使えて凄い"
        assert.equal true, tokens instanceof Array
        done()

  describe 'method "getNouns"', ->

    it 'should returns nouns', (done) ->
      Tokenizer.build()
      .then (tokenizer) ->
        nouns = tokenizer.getNouns "すもももももももものうち"
        console.log nouns
        assert.deepEqual nouns, ['すもも','もも','うち']
        done()

    it 'should returns joined nouns', (done) ->
      Tokenizer.build()
      .then (tokenizer) ->
        nouns = tokenizer.getNouns 'hubot、なんかメモリリークしてる。'
        console.log nouns
        assert.deepEqual nouns, ['hubot','メモリ','リーク','メモリリーク']
        done()

    it 'should register URL', (done) ->
      Tokenizer.build()
      .then (tokenizer) ->
        nouns = tokenizer.getNouns 'ここから https://www.npmjs.com/package/hubot-osietekun インストールできる'
        console.log nouns
        assert.deepEqual nouns, ['ここ','インストール']
        done()
