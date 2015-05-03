# Description:
#   Hubot Osietekun
#
# Commands:
#   hubot 教えて [word]
#
# Author:
#   @shokai

'use strict'

path    = require 'path'
Promise = require 'bluebird'
debug   = require('debug')('hubot:osietekun')
_       = require 'lodash'

tokenizer = require path.join __dirname, '../libs/tokenizer'

module.exports = (robot) ->

  debug 'loading tokenizer..'
  tokenizer.build()
  .then (tokenizer) ->
    debug 'start'

    getCounts = (word) ->
      word = word.toLowerCase()
      counts = robot.brain.get "osiete_word_#{word}"
      return {} unless counts
      try
        JSON.parse counts
      catch
        {}

    setCounts = (word, counts) ->
      word = word.toLowerCase()
      robot.brain.set "osiete_word_#{word}", JSON.stringify(counts)

    register = (who, text) ->
      nouns = tokenizer.getNouns text
      return if nouns.length < 1
      debug "register #{JSON.stringify nouns} - @#{who}"
      for noun in nouns
        counts = getCounts noun
        counts[who] ||= 0
        counts[who] += 1
        setCounts noun, counts

    robot.hear /^(.+)$/, (msg) ->
      who  = msg.message.user.name
      text = msg.match[1]
      if new RegExp("^#{robot.name} 教えて", 'i').test text
        return
      debug text
      register who, text

    robot.respond /教えて ([^\s]+)$/i, (msg) ->
      word = msg.match[1]
      counts = getCounts word

      if Object.keys(counts).length < 1
        msg.send "「#{word}」に詳しい人はいないみたいです"
        return

      masters = _.chain counts
        .pairs()
        .sort (a,b) ->
          a[1] < b[1]
        .value()
        .splice 0,3
        .map (i) ->
          i[0]

      text = "「#{word}」については "
      text += masters
        .map (master) ->
          switch robot.adapter
            when 'slack' then "@#{master}:"
            else "@#{master}:"
        .join ' '
      text += " が詳しいので教えてもらって下さい"

      msg.send text

  .catch (err) ->
    if err
      robot.logger.error "osietekun - tokenizer load error - #{err}"
      return
