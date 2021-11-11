# Docker Your Xyzzy

[![Docker](https://github.com/Cyb3r-Jak3/DockerYourXyzzy/actions/workflows/docker.yml/badge.svg)](https://github.com/Cyb3r-Jak3/DockerYourXyzzy/actions/workflows/docker.yml)

Get your Xyzzy on: `docker pull ghcr.io/cyb3r-jak3/dockeryourxyzzy`

- Github: [ghcr.io/cyb3r-jak3/dockeryourxyzzy](https://github.com/Cyb3r-Jak3/DockerYourXyzzy/pkgs/container/dockeryourxyzzy)
- Docker Hub: [cyb3rjak3/dockeryourxyzzy](https://hub.docker.com/r/cyb3rjak3/dockeryourxyzzy/)

## What is Docker Your Xyzzy?

This is a containerized build of the [Pretend You're Xyzzy](https://github.com/ajanata/PretendYoureXyzzy) Cards Against Humanity clone.

## Usage

The PYX project can be used in Docker format for development, outputting the built files, or running in production.

The `prebuilt` tag is an image that already has built pxy war file but offers no customization. It is quicker to deploy.

The `on-demand` tag is an image that contains the tools to build the pxy war file. Takes longer to deploy but is smaller and offers customization.

## Run with Docker-Compose (fastest)

### Ngrok

An example stack of PYX with a Postgres database and an [Ngrok](https://ngrok.com/) tunnel can be found in [examples/ngrok/docker-compose.yml](./examples/ngrok/docker-compose.yml):

Once the containers are running, you can:

- Visit http://localhost:8080/game.jsp to play locally
- Visit http://localhost:4040/status to find your Ngrok URL
- Visit https://#####.ngrok.io to share publicly

### Cloudflared

An example stack of PYX with a Postgres database and an [cloudflared](https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/installation) tunnel can be found in [example/cloudflare/docker-compose.yml](./examples/cloudflared/docker-compose.yml)

Requires having a tunnel created and configured. [Guide](https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide)

## Run Prebuilt Container

Keep the container up with SQLite and `war:exploded jetty:run`:

```sh
docker run -d \
  -p 8080:8080 \
  --name pyx-dev \
  ghcr.io/cyb3r-jak3/dockeryourxyzzy:latest

# Visit http://localhost:8080 in your browser
# Or, start a bash session within the container:
docker exec -it pyx-dev bash
```

## Run With Overrides

Settings in `build.properties` can be modified by passing them in the container CMD:

```sh
docker run -d \
  -p 8080:8080 \
  ghcr.io/cyb3r-jak3/dockeryourxyzzy:on-demand \
  mvn clean package war:war \
    -Dhttps.protocols=TLSv1.2 \
    -Dmaven.buildNumber.doCheck=false \
    -Dmaven.buildNumber.doUpdate=false \
    -Dmaven.hibernate.url=jdbc:postgresql://postgres/pyx
```

Also are able to do more complex overrides by making a copy of [build.properties](./overrides/build.properties) and mounting that in overrides.

```sh
docker run -d \
  -p 8080:8080 \
  -v $(pwd)/build.properties:/overrides/build.properties \
  ghcr.io/cyb3r-jak3/dockeryourxyzzy:on-demand
```

## Building

This project can be built and run by any of the 2 following methods: CLI `docker build` commands, CLI `docker buildx bake` commands.

### Build with `docker build`

```sh
# Build pre-built image
docker build --target pre-built -t pyx .
```

```sh
# Build on-demand image
docker build --target on-demand -t pyx .
```

### Build via `docker buildx bake`

**Requires [Buildx](https://docs.docker.com/buildx/working-with-buildx/)**

Bake target can be found in [docker-bake.hcl](./docker-bake.hcl):

```sh
# Build pre-built image
docker buildx bake pre-built
```

```sh
# Build on-demand image
docker buildx bake on-demand
```

## ToDo

- [x] Figure out how to run `:latest` properly with a Postgres db
- [ ] Import & run sql files if specified for the Postgres db
- [ ] Buildtime config customization via Maven flags
- [ ] Runtime config customization via Maven flags
- [ ] Fetch GeoIP database in entrypoint.sh

## Notes

- Versioning and tagging isn't done well here because [Pretend You're Xyzzy](https://github.com/ajanata/PretendYoureXyzzy) doesn't seem to tag or version.
