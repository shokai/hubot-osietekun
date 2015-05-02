Hubot Oisietekun
================
詳しい人を教えてくれるhubot script

![screen shot](https://i.gyazo.com/0fd0401ce5fdc78725a9076eb630ad66.png)

- https://github.com/shokai/hubot-osietekun

[![Build Status](https://travis-ci.org/shokai/hubot-osietekun.svg?branch=travis_ci)](https://travis-ci.org/shokai/hubot-osietekun)


Install
-------

    % npm i shokai/hubot-osietekun -save

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


## Test

    % npm test
    # or
    % npm run watch
