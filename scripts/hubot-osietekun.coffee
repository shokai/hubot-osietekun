# Description:
#   Hubot Osietekun
#
# Commands:
#   hubot 教えて [word]
#   hubot 教えます [word]
#   hubot 教えません [word]
#
# Author:
#   @shokai

'use strict'

path    = require 'path'
Promise = require 'bluebird'
debug   = require('debug')('hubot:osietekun')
_       = require 'lodash'

Osietekun = require path.join __dirname, '../libs/osietekun'

module.exports = (robot) ->

  new Osietekun robot
  .then (osietekun) ->

    robot.hear /^(.+)$/, (msg) ->
      who  = msg.message.user.name
      text = msg.match[1]
      if new RegExp("^#{robot.name} 教えて", 'i').test text
        return
      debug text
      osietekun.register who, text

    robot.respond /教えて\s+(.+)$/i, (msg) ->
      words = msg.match[1].split(/\s+/)
      res = osietekun.suggest words
      words_str = words
        .map (word) -> "「#{word}」"
        .join ''

      if Object.keys(res.masters).length < 1
        msg.send "#{words_str}に詳しい人はいないみたいです"
        osietekun.emit 'response', msg, res
        return

      text = "#{words_str}については "
      text += res.masters
        .map (master) -> "@#{master}"
        .join ' '
      text += " が詳しいので教えてもらって下さい"
      if res.teachers.length > 0
        text += "\nあと、"
        text += res.teachers
          .map (teacher) -> "@#{teacher}"
          .join ' '
        text += "は#{words_str}について教えたいと言っていました"

      msg.send text

      osietekun.emit 'response', msg, res
      return

    robot.respond /教えます\s+([^\s]+)$/i, (msg) ->
      who  = msg.message.user.name
      word = msg.match[1]
      osietekun.registerTeacher who, word
      msg.send "へえ、@#{who} は「#{word}」に詳しいんだ"

      osietekun.emit 'register:teacher', msg, {who: who, word: word}
      return

    robot.respond /教えません\s+([^\s]+)$/i, (msg) ->
      who  = msg.message.user.name
      word = msg.match[1]
      osietekun.unregisterTeacher who, word
      msg.send "@#{who} は「#{word}」を教えたくないらしい"
      osietekun.emit 'unregister:teacher', msg, {who: who, word: word}
      return

    robot.emit 'osietekun:ready', osietekun

  .catch (err) ->
    if err
      robot.logger.error "osietekun - tokenizer load error - #{err}"
      return
