FROM balenalib/amd64-ubuntu-node:10-cosmic

RUN apt-get update && apt-get install -y libbluetooth-dev build-essential python-dev

COPY . . 

RUN npm install --build-from-source

RUN ./node_modules/.bin/node-pre-gyp build package
RUN find build/stage -iname "*.tar.gz" | sed 's/^.*@sixriver/@sixriver/' > binary_path.txt 
RUN find build/stage -iname "*.tar.gz" | sed 's/^.*sqlite3/sqlite3/' > target_path.txt

FROM google/cloud-sdk:alpine 
WORKDIR /
COPY --from=0 /binary_path.txt .
COPY --from=0 /target_path.txt .
COPY --from=0 /build/stage/ .
