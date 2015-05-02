'use strict'

path    = require 'path'
Promise = require 'bluebird'
_       = require 'lodash'

kuromoji = require 'kuromoji'
DIC_PATH = path.join(__dirname,'../node_modules/kuromoji/dist/dict')+'/'

_tokenizer = null

module.exports =

  build: (dicPath = DIC_PATH) ->
    return new Promise (resolve, reject) ->
      return resolve _tokenizer if _tokenizer isnt null

      kuromoji.builder
        dicPath: dicPath
      .build (err, tokenizer) ->
        return reject err if err

        tokenizer.getTokens = (text) ->
          tokenizer.tokenize text

        tokenizer.getNouns = (text) ->
          _.chain tokenizer.getTokens(text)
          .filter (i) ->
            /名詞/.test i.pos
          .map (i) ->
            i.surface_form
          .value()

        _tokenizer = tokenizer
        return resolve tokenizer
