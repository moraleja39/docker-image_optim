FROM alpine

ENV \
  # https://github.com/amadvance/advancecomp/releases
  ADVANCECOMP_VERSION=2.3 \
  # https://github.com/kohler/gifsicle/releases
  GIFSICLE_VERSION=1.93 \
  # http://www.ijg.org/
  IJG_VERSION=9e \
  JHEAD_VERSION=3.04 \
  # https://github.com/danielgtaylor/jpeg-archive/releases
  JPEGARCHIVE_VERSION=2.2.0 \
  # https://www.kokkonen.net/tjko/projects.html#jpegoptim
  JPEGOPTIM_VERSION=1.4.6 \
  # https://github.com/mozilla/mozjpeg/releases
  MOZJPEG_VERSION=4.0.3 \
  # https://sourceforge.net/projects/optipng/files/OptiPNG/
  OPTIPNG_VERSION=0.7.7 \
  # https://sourceforge.net/projects/pmt/files/pngcrush/
  PNGCRUSH_VERSION=1.8.13 \
  PNGOUT_VERSION=20150319 \
  # https://github.com/pornel/pngquant/releases
  PNGQUANT_VERSION=2.17.0 \
  # https://github.com/ImageOptim/libimagequant/releases
  LIBIMAGEQUANT_VERSION=2.17.0

WORKDIR /tmp

# This step installs all external utilities, leaving only the
# compiled/installed binaries behind in order minimize the
# footprint of the image layer.
RUN apk update && apk add \
  # runtime dependencies

  # advcomp (libstdc++.so, libgcc_s.so)
  libstdc++ \

  # jpegoptim (libjpeg.so)
  libjpeg-turbo \

  # mozjpeg
  libpng-static zlib-static \

  # pngquant
  libpng \

  # svgo
  nodejs yarn \

  # image_optim
  ruby \

  # build dependencies
  && apk add --virtual build-dependencies \
  build-base \

  # jpegoptim
  libjpeg-turbo-dev \

  # advancecomp
  zlib-dev \

  # pngquant
  bash libpng-dev \

  # gifsicle
  pkgconfig autoconf automake \

  # mozjpeg
  libtool nasm cmake \

  # oxipng \
  cargo \

  # utils
  curl \

  # image_optim
  ruby-irb \

  # advancecomp
  && curl -L -O https://github.com/amadvance/advancecomp/releases/download/v$ADVANCECOMP_VERSION/advancecomp-$ADVANCECOMP_VERSION.tar.gz \
  && tar zxf advancecomp-$ADVANCECOMP_VERSION.tar.gz \
  && cd advancecomp-$ADVANCECOMP_VERSION \
  && ./configure && make -j$(nproc) && make install \

  # gifsicle
  && curl -L -O https://github.com/kohler/gifsicle/archive/v$GIFSICLE_VERSION.tar.gz \
  && tar zxf v$GIFSICLE_VERSION.tar.gz \
  && cd gifsicle-$GIFSICLE_VERSION \
  && autoreconf -i && ./configure && make -j$(nproc) && make install \

  # jhead
  && curl -O https://www.sentex.net/~mwandel/jhead/jhead-$JHEAD_VERSION.tar.gz \
  && tar zxf jhead-$JHEAD_VERSION.tar.gz \
  && cd jhead-$JHEAD_VERSION \
  && make -j$(nproc) && make install \

  # jpegoptim
  && curl -O https://www.kokkonen.net/tjko/src/jpegoptim-$JPEGOPTIM_VERSION.tar.gz \
  && tar zxf jpegoptim-$JPEGOPTIM_VERSION.tar.gz \
  && cd jpegoptim-$JPEGOPTIM_VERSION \
  && ./configure && make -j$(nproc) && make install \

  # jpeg-recompress (from jpeg-archive along with mozjpeg dependency)
  && curl -L -O https://github.com/mozilla/mozjpeg/archive/v$MOZJPEG_VERSION.tar.gz \
  && tar zxf v$MOZJPEG_VERSION.tar.gz \
  && cd mozjpeg-$MOZJPEG_VERSION \
  && cmake -G"Unix Makefiles" -DENABLE_STATIC=TRUE -DPNG_SUPPORTED=TRUE -DWITH_JPEG8=1 . && make -j$(nproc) && make install \
  && curl -L -O https://github.com/danielgtaylor/jpeg-archive/archive/v$JPEGARCHIVE_VERSION.tar.gz \
  && tar zxf v$JPEGARCHIVE_VERSION.tar.gz \
  && cd jpeg-archive-$JPEGARCHIVE_VERSION \
  && CFLAGS="-fcommon" make -j$(nproc) && make install \

  # jpegtran (from Independent JPEG Group)
  && curl -O http://www.ijg.org/files/jpegsrc.v$IJG_VERSION.tar.gz \
  && tar zxf jpegsrc.v$IJG_VERSION.tar.gz \
  && cd jpeg-$IJG_VERSION \
  && ./configure && make -j$(nproc) && make install \

  # optipng
  && curl -L -O http://downloads.sourceforge.net/project/optipng/OptiPNG/optipng-$OPTIPNG_VERSION/optipng-$OPTIPNG_VERSION.tar.gz \
  && tar zxf optipng-$OPTIPNG_VERSION.tar.gz \
  && cd optipng-$OPTIPNG_VERSION \
  && ./configure && make -j$(nproc) && make install \

  # pngcrush
  && curl -L -O http://downloads.sourceforge.net/project/pmt/pngcrush/$PNGCRUSH_VERSION/pngcrush-$PNGCRUSH_VERSION.tar.gz \
  && tar zxf pngcrush-$PNGCRUSH_VERSION.tar.gz \
  && cd pngcrush-$PNGCRUSH_VERSION \
  && make -j$(nproc) && cp -f pngcrush /usr/local/bin \

  # pngout (binary distrib)
  && curl -O https://www.jonof.id.au/files/kenutils/pngout-$PNGOUT_VERSION-linux-static.tar.gz \
  && tar zxf pngout-$PNGOUT_VERSION-linux-static.tar.gz \
  && cd pngout-$PNGOUT_VERSION-linux-static \
  && cp -f x86_64/pngout-static /usr/local/bin/pngout \

  # pngquant
  && curl -L -O https://github.com/ImageOptim/libimagequant/archive/$LIBIMAGEQUANT_VERSION.tar.gz \
  && tar xzf $LIBIMAGEQUANT_VERSION.tar.gz \
  && curl -L -O https://github.com/pornel/pngquant/archive/$PNGQUANT_VERSION.tar.gz \
  && tar xzf $PNGQUANT_VERSION.tar.gz \
  && mv libimagequant-$LIBIMAGEQUANT_VERSION/* pngquant-$PNGQUANT_VERSION/lib/ \
  && cd pngquant-$PNGQUANT_VERSION \
  && ./configure && make -j$(nproc) && make install \

  # svgo
  && yarn global add svgo --prefix /usr/local \

  # oxipng
  && cargo install oxipng && mv /root/.cargo/bin/oxipng /usr/local/bin \

  # image_optim
  && echo -e 'install: --no-document\nupdate: --no-document' > "$HOME/.gemrc" \
  && gem install --no-document image_optim \

  # cleanup
  && rm -rf /tmp/* \
  && rm -rf /root/.cargo \
  && apk del build-dependencies

WORKDIR /images
