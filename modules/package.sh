
DOC="Module for working with cljr build system"

. ${CLJR_BIN}/shflags

commands() {
    echo -e "install uninstall versions describe deps search installed latest"
}

install() {
    DEFINE_string 'version' '0' 'version' 'v'
    DEFINE_string 'package' '0' 'package' 'p'
    FLAGS "$@" || exit 1
    eval set -- "${FLAGS_ARGV}"
    if [ ${FLAGS_package} == "0" ]; then
        echo "USAGE: jark package install --package [--version]"
        exit 1
    fi
        
    if [ ${FLAGS_version} == "0" ]; then
        $JARK_CLIENT cljr.App install ${FLAGS_package}
    else
        $JARK_CLIENT cljr.App install ${FLAGS_package} ${FLAGS_version}
    fi
    exit 0
}

uninstall() {
    $JARK_CLIENT cljr.App uninstall $*
}

versions() {
    $JARK_CLIENT cljr.App versions $*
}

describe() {
    $JARK_CLIENT cljr.App search $*
}

search() {
    $JARK_CLIENT cljr.App search $*
}

run() {
    $JARK_CLIENT cljr.App $*
}

installed() {
    $JARK_CLIENT cljr.App list
}

deps() {
    if [ -z $2 ]; then
        ver=`$JARK cljr.clojars get-latest-version $1`
        $JARK cljr.clojars print-library-dependencies $1 $ver
    else
        $JARK cljr.clojars print-library-dependencies $1 $2
    fi
}

latest() {
    $JARK cljr.clojars get-latest-version $*
}
