FROM alpine:latest AS build

RUN apk update && apk upgrade \
    && apk add --update alpine-sdk linux-headers bash git make cmake clang

COPY ./ /code
WORKDIR /code

# make pacth for pylon
RUN sed -i 's|^#include <bits/types.h>|#include <sys/types.h>|' pylon.cpp
RUN sed -i 's|^#include <cstddef>|#include <stdexcept>\n#include <cstddef>|' ext/libzt/ext/ZeroTierOne/ext/prometheus-cpp-lite-1.0/core/include/prometheus/family.h

# build binary for pylon
RUN make release

FROM alpine:latest
COPY --from=build /code/pylon /usr/local/bin
EXPOSE 443
EXPOSE 9993/udp
# ENV ZT_PYLON_SECRET_KEY=
# ENV ZT_PYLON_WHITELISTED_PORT=
ENTRYPOINT [ "/usr/local/bin/pylon" ]
CMD ["reflect"]
