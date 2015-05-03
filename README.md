Hubot Oisietekun
================
詳しい人を教えてくれるhubot script

[![Build Status](https://travis-ci.org/shokai/hubot-osietekun.svg?branch=travis_ci)](https://travis-ci.org/shokai/hubot-osietekun)

- https://www.npmjs.com/package/hubot-osietekun
- https://github.com/shokai/hubot-osietekun


![screen shot](https://i.gyazo.com/0fd0401ce5fdc78725a9076eb630ad66.png)


Install
-------

    % npm i hubot-osietekun -save

### edit `external-script.json`

```json
["hubot-osietekun"]
```


Requirements
------------

- coffee-script 1.8+
- hubot-brain
  - recommend [brain-redis-hash](https://www.npmjs.com/package/hubot-brain-redis-hash). normal redis-brain is not good.


Usage
-----

### 教わる

    % hubot 教えて react


Extend
------

hook "osietekun:ready" and "response" event.

```coffee
robot.on 'osietekun:ready', (osietekun) ->

  osietekun.on 'response' (msg, res) ->
    if res.masters.length < 1
      msg.send "#{res.word}については http://your-great-wiki-site.com/#{res.word} を見るといいかも"
```

Test
----

    % npm test
    # or
    % npm run watch
