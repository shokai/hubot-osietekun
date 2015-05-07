path      = require 'path'
Promise   = require 'bluebird'
debug     = require('debug')('hubot:osietekun:core')
_         = require 'lodash'
Tokenizer = require path.join __dirname, 'tokenizer'

{EventEmitter2} = require 'eventemitter2'

module.exports = class Osietekun extends EventEmitter2

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

  suggest: (words) ->
    unless words instanceof Array
      @robot.logger.error "argument must be Array"
      return
    counts = words
      .map (word) =>
        @getCounts word
      .reduce (a,b) ->
        for name, count of a
          a[name] *= (b[name] or 0)
        return a

    masters = _.chain counts
      .pairs()
      .select (i) ->
        i[1] > 0
      .sort (a,b) ->
        a[1] < b[1]
      .value()
      .splice 0,3
      .map (i) ->
        i[0]

    teachers = words
      .map (word) =>
        @getTeachers word
      .reduce (a, b) ->
        _.reject a, (teacher) -> b.indexOf(teacher) < 0

    return {
      words: words
      masters: masters
      counts: counts
      teachers: teachers
    }

  getTeachers: (word) ->
    word = word.toLowerCase()
    teachers = @robot.brain.get "osieru_word_#{word}"
    return [] unless teachers
    try
      JSON.parse teachers
    catch
      []

  setTeachers: (word, teachers) ->
    word = word.toLowerCase()
    @robot.brain.set "osieru_word_#{word}", JSON.stringify(teachers)

  registerTeacher: (who, word) ->
    debug "registerTeacher @#{who}, #{word}"
    teachers = @getTeachers word
    teachers.push who
    teachers = _.uniq teachers
    @setTeachers word, teachers

  unregisterTeacher: (who, word) ->
    teachers = @getTeachers word
    teachers = _.reject teachers, (i) -> i is who
    @setTeachers word, teachers
