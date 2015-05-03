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

    robot.respond /教えて ([^\s]+)$/i, (msg) ->
      word = msg.match[1]
      counts = osietekun.getCounts word

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

    robot.emit 'osietekun:ready', osietekun

  .catch (err) ->
    if err
      robot.logger.error "osietekun - tokenizer load error - #{err}"
      return
