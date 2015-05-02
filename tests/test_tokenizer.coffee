path = require 'path'
require path.resolve 'tests', 'test_helper'

assert     = require 'assert'
tokenizer  = require path.resolve 'libs', 'tokenizer'

describe 'Tokenizer', ->

  it 'sohuld have methods "getTokens", "getNouns"', (done) ->
    @timeout 5000

    tokenizer.build().then (tokenizer) ->
      assert.equal typeof tokenizer['getTokens'], 'function'
      assert.equal typeof tokenizer['getNouns'], 'function'
      done()

  describe 'method "getToken"', ->

    it 'should returns tokens', (done) ->
      tokenizer.build()
      .then (tokenizer) ->
        tokens = tokenizer.getTokens "kuromoji、最初から辞書が内蔵されてるからrequireしてすぐ使えて凄い"
        console.log tokens.length
        assert.equal true, tokens instanceof Array
        done()

  describe 'method "getNouns"', ->

    it 'should returns nouns', (done) ->
      tokenizer.build()
      .then (tokenizer) ->
        nouns = tokenizer.getNouns "合宿参加者各位\n宿泊しない日やご飯いらない時あったら連絡ください"
        console.log nouns
        done()
