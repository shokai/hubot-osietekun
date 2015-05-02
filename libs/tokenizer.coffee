'use strict'

path    = require 'path'
Promise = require 'bluebird'
_       = require 'lodash'

kuromoji = require 'kuromoji'
DIC_PATH = path.join(__dirname,'../node_modules/kuromoji/dist/dict')+'/'

IGNORE_WORDS = [
  '、'
  /https?:\/\/[^\s]+/ig
]

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
          for word in IGNORE_WORDS
            reg =
              if word instanceof RegExp
                word
              else
                new RegExp word, 'ig'
            text = text.replace reg, ' '

          nouns = tokenizer.getTokens text
            .map (i) ->
              if /名詞/.test i.pos
                i.surface_form
              else
                null

          joined_nouns = nouns
            .map (i) ->
              if typeof i is 'string' then i else ' '
            .join ''
            .match(/([^\s])+/g) or []

          nouns = _.select nouns, (i) -> typeof i is 'string'
          nouns = nouns.concat joined_nouns if joined_nouns?.length > 0

          return _.uniq nouns

        _tokenizer = tokenizer
        return resolve tokenizer
