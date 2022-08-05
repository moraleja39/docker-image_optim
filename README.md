# docker-image_optim

### Docker image

A docker image giving the built version of the best image optimizing CLI apps together with `image_optim` to rule them all

## Credits
95% of this work it's from [rhardih][2]'s [first attempt at dockerizing this project][1].

[1]: https://github.com/rhardih/image_optim_pack/blob/master/Dockerfile
[2]: https://github.com/rhardih

## Changes
* Maintaining an additional Dockerfiles with fewer layers for production purposes
* creating more layers, so if you need to test different versions you can avoid full rebuilds.
* Versions have been bumped, and ordered alphabetically

## Minimal usage
Execute image_optim in your current dir:
```shell
docker run --rm -ti -v $(pwd):/images/ moraleja39/image_optim image_optim -r .
```

## How To Use
```shell
docker run --rm -ti \
  # Add whatever image directory you like
  # -v $(cd && cd images && pwd):/images/ \
  -v $(pwd)/config:/root/.config/ \
  moraleja39/image_optim sh
```

Then a simple `cd /images && image_optim -r .` would optimize all the images in the mounted path.

## How to Build
`docker build -t image_optim .`
and (after a while) you can run your custom-built image
```shell
docker run --rm -ti \
  # Add whatever image directory you like
  # -v $(cd && cd images && pwd):/images/ \
  -v $(pwd)/config:/root/.config/ \
  docker-image_optim sh
```

## Configuration
A demo configuration (LOSSY!) can be found in [config/image_optim.yml][config], all the options are [listed here](http://www.rubydoc.info/gems/image_optim/)

[config]: config/image_optim.yml

