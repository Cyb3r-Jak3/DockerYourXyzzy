variable "DOCKER_META_VERSION" {
    default = "dev"
}

// Special target: https://github.com/docker/metadata-action#bake-definition
target "docker-metadata-action" {
    platforms = [
        "linux/amd64",
        "linux/arm64",
    ]
}

target "prebuilt" {
    dockerfile = "Dockerfile"
    target = "prebuilt"
    tags = [
        "cyb3rjak3/dockeryourxyzzy:prebuilt",
        "cyb3rjak3/dockeryourxyzzy:latest",
        "cyb3rjak3/dockeryourxyzzy:${DOCKER_META_VERSION}",
        "cyb3rjak3/dockeryourxyzzy:prebuilt-${DOCKER_META_VERSION}",
        "ghcr.io/cyb3r-jak3/dockeryourxyzzy:prebuilt",
        "ghcr.io/cyb3r-jak3/dockeryourxyzzy:latest",
        "ghcr.io/cyb3r-jak3/dockeryourxyzzy:${DOCKER_META_VERSION}",
        "ghcr.io/cyb3r-jak3/dockeryourxyzzy:prebuilt-${DOCKER_META_VERSION}"
    ]
}

target "on-demand" {
    dockerfile = "Dockerfile"
    target = "on-demand"
    tags = [
        "cyb3rjak3/dockeryourxyzzy:on-demand",
        "cyb3rjak3/dockeryourxyzzy:on-demand-${DOCKER_META_VERSION}",
        "ghcr.io/cyb3r-jak3/dockeryourxyzzy:on-demand",
        "ghcr.io/cyb3r-jak3/dockeryourxyzzy:on-demand-${DOCKER_META_VERSION}"
    ]
}

target "prebuilt-release" {
   inherits = ["prebuilt", "docker-metadata-action"]
}

target "on-demand-release" {
    inherits = ["on-demand", "docker-metadata-action"]
}