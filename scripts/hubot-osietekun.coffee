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
        .map (master) ->
          switch robot.adapter
            when 'slack' then "@#{master}:"
            else "@#{master}:"
        .join ' '
      text += " が詳しいので教えてもらって下さい"

      msg.send text

      osietekun.emit 'response', msg, res
      return

    robot.emit 'osietekun:ready', osietekun

  .catch (err) ->
    if err
      robot.logger.error "osietekun - tokenizer load error - #{err}"
      return
