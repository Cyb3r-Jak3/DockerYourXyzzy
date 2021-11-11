// Special target: https://github.com/docker/metadata-action#bake-definition
target "docker-metadata-action" {
    platforms = [
        "linux/amd64",
        "linux/arm64",
    ]
}

target "pre-built" {
    dockerfile = "Dockerfile.built"
}

target "on-demand" {
    dockerfile = "Dockerfile"
}

target "pre-built-release" {
   inherits = ["docker-metadata-action", "pre-built"]
}

target "on-demand-release" {
    inherits = ["docker-metadata-action", "on-demand"]
}