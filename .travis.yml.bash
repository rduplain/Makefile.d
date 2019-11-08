#!/usr/bin/env bash
# Generate a Language x OS matrix for Travis CI.
#
# As of the end of 2018, Travis CI does not have any documentation on a matrix
# which is `language` x `os`, and putting `os` at the top-level of a matrix of
# language directives results in an error of "Could not parse .travis.yml".
#
# Accordingly, generate the matrix.
#
#     bash .travis.yml.bash > .travis.yml

main() {
    header
    cljs linux
    cljs osx
    ocaml linux
    ocaml osx
    python linux # general
    python osx # general
    ruby linux
    ruby osx
    footer
}

## .travis.yml content ##

header() {
cat                                                                       <<___
# GENERATED FILE - DO NOT EDIT
#
# Generate with \`bash .travis.yml.bash > .travis.yml\`.

matrix:
  include:
___
}

cljs() {
os=$1

all                                                            $os && cat <<___
    - os: $os
      language: node_js
      node_js: lts/*
      addons:
___
linux                                                          $os && cat <<___
        apt:
          packages: rlwrap
___
osx                                                            $os && cat <<___
        homebrew:
          packages: clojure
          update: true
___
all                                                            $os && cat <<___
      install:
___
linux                                                          $os && cat <<___
        - export PATH=/opt/clj/bin:"\$PATH"
        - if ! which clojure; then curl https://download.clojure.org/install/linux-install-1.9.0.358.sh | sudo bash -s - -p /opt/clj; fi
___
all                                                            $os && cat <<___
        - which make java clojure node npm
      script:
        - ./test/bin/test-suite cljs
      cache:
        directories:
          - ~/.m2
          - ~/.npm
          - ~/.pkg-cache
          - .cpcache
          - node_modules
___
linux                                                          $os && cat <<___
          - /opt/clj
___
osx                                                            $os && cat <<___
          - ~/Library/Caches/Homebrew
          - /usr/local/Homebrew
      before_cache:
        - brew cleanup
___
}

ocaml() {
os=$1

all                                                            $os && cat <<___
    - os: $os
      language: generic
___
linux                                                          $os && cat <<___
      before_install:
        - sudo add-apt-repository -y ppa:avsm/ppa
        - sudo apt-get -q update
        - sudo apt-get -y install opam
___
osx                                                            $os && cat <<___
      addons:
        homebrew:
          packages:
            - gpatch
            - opam
          update: true
___
all                                                            $os && cat <<___
      install:
        - which make opam
        - opam init --yes --bare --no-setup
      script:
        - ./test/bin/test-suite ocaml
      cache:
        directories:
          - ~/.opam
          - ./test/ocaml/_opam
___
osx                                                            $os && cat <<___
          - ~/Library/Caches/Homebrew
          - /usr/local/Homebrew
      before_cache:
        - brew cleanup
___
}

python() {
os=$1

all                                                            $os && cat <<___
    - os: $os
___
linux                                                          $os && cat <<___
      language: python
      python: 3.4
___
osx                                                            $os && cat <<___
      language: generic
      addons:
        homebrew:
          packages: python3
          update: true
___
all                                                            $os && cat <<___
      install:
        - make --version; true # GNU
        - make -V MAKE_VERSION 2>/dev/null; true # BSD (not supported)
      before_script:
        - type -t deactivate && deactivate || true # Deactivate virtualenv.
___
linux                                                          $os && cat <<___
        - export PATH=/opt/python/3.4/bin:\$PATH
___
all                                                            $os && cat <<___
        - which make python
      script:
        - ./test/bin/test-suite general python
      cache:
        directories:
___
linux                                                          $os && cat <<___
          - ~/.cache/pip
___
osx                                                            $os && cat <<___
          - ~/Library/Caches/pip
___
all                                                            $os && cat <<___
          - ./test/python/.reqd/src
___
osx                                                            $os && cat <<___
          - ~/Library/Caches/Homebrew
          - /usr/local/Homebrew
      before_cache:
        - brew cleanup
___
}

ruby() {
os=$1

all                                                            $os && cat <<___
    - os: $os
      language: ruby
      rvm: 2.6.3
      install:
        - make --version; true # GNU
        - make -V MAKE_VERSION 2>/dev/null; true # BSD (not supported)
      before_script:
        - which make ruby
      script:
        - ./test/bin/test-suite ruby
___
}

footer() {
cat                                                                       <<___
notifications:
  email:
    on_success: never
___
}

## predicate functions ##

all() {
    return 0
}

linux() {
    [ "$@" = "linux" ]
}

osx() {
    [ "$@" = "osx" ]
}

main "$@"
