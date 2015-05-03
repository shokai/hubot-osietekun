
path      = require 'path'
Promise   = require 'bluebird'
debug     = require('debug')('hubot:osietekun:core')
_         = require 'lodash'
Tokenizer = require path.join __dirname, 'tokenizer'

module.exports = class Osietekun

  constructor: (@robot) ->
    return new Promise (resolve, reject) =>
      debug 'loading tokenizer..'
      Tokenizer.build()
      .then (@tokenizer) =>
        debug 'ready'
        resolve @


  getCounts: (word) ->
    word = word.toLowerCase()
    counts = @robot.brain.get "osiete_word_#{word}"
    return {} unless counts
    try
      JSON.parse counts
    catch
      {}

  setCounts: (word, counts) ->
    word = word.toLowerCase()
    @robot.brain.set "osiete_word_#{word}", JSON.stringify(counts)

  register: (who, text) ->
    nouns = @tokenizer.getNouns text
    return if nouns.length < 1
    debug "register #{JSON.stringify nouns} - @#{who}"
    for noun in nouns
      counts = @getCounts noun
      counts[who] ||= 0
      counts[who] += 1
      @setCounts noun, counts


