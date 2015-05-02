# Hubot Oisietekun

詳しい人を教えてくれるhubot script

![design](https://i.gyazo.com/d0f9aff007a7603760639df0192c5624.png)

## Install

    % npm i shokai/hubot-osietekun -save

### edit `external-script.json`

```json
["hubot-osietekun"]
```

## Requirements

- coffee-script 1.8+
- hubot-brain
  - recommend [brain-redis-hash](https://www.npmjs.com/package/hubot-brain-redis-hash). normal redis-brain is not good.


## Test

    % npm test
    # or
    % npm run watch
