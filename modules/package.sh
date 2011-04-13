
DOC="Module for working with cljr build system"

. ${CLJR_BIN}/shflags

commands() {
    echo -e "install uninstall versions deps search installed latest"
}

_doc() {
    echo -e "jark package install (--package -p PACKAGE) [--version -v]"
    echo -e "\tInstall the relevant version of package from clojars."
    echo -e ""
    echo -e "jark package uninstall (--package -p PACKAGE)"
    echo -e "\tUninstall the package."
    echo -e ""
    echo -e "jark package versions (--package -p PACKAGE)"
    echo -e "\tList the versions of package installed."
    echo -e ""
    echo -e "jark package deps (--package -p PACKAGE) [--version -v]"
    echo -e "\tPrint the library dependencies of package."
    echo -e ""
    echo -e "jark package search (--package -p PACKAGE)"
    echo -e "\tSearch clojars for package."
    echo -e ""
    echo -e "jark package installed"
    echo -e "\tList all packages installed."
}

install() {
    DEFINE_string 'version' '0' 'version' 'v'
    DEFINE_string 'package' '0' 'package' 'p'
    FLAGS "$@" || exit 1
    eval set -- "${FLAGS_ARGV}"
    if [ ${FLAGS_package} == "0" ]; then
        echo "USAGE: jark package install --package PACKAGE [--version]"
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
    DEFINE_string 'package' '0' 'package' 'p'
    FLAGS "$@" || exit 1
    eval set -- "${FLAGS_ARGV}"
    if [ ${FLAGS_package} == "0" ]; then
        echo "USAGE: jark package uninstall --package PACKAGE"
        exit 1
    fi
    $JARK_CLIENT cljr.App uninstall ${FLAGS_package}
}

versions() {
    DEFINE_string 'package' '0' 'package' 'p'
    FLAGS "$@" || exit 1
    eval set -- "${FLAGS_ARGV}"
    if [ ${FLAGS_package} == "0" ]; then
        echo "USAGE: jark package versions --package PACKAGE"
        exit 1
    fi
    $JARK_CLIENT cljr.App versions ${FLAGS_package}
    exit 0
}

search() {
    DEFINE_string 'package' '0' 'package' 'p'
    FLAGS "$@" || exit 1
    eval set -- "${FLAGS_ARGV}"
    if [ ${FLAGS_package} == "0" ]; then
        echo "USAGE: jark package search --package PACKAGE"
        exit 1
    fi
    $JARK_CLIENT cljr.App search ${FLAGS_package}
}

installed() {
    $JARK_CLIENT cljr.App list
    exit 0
}

latest() {
    DEFINE_string 'package' '0' 'package' 'p'
    FLAGS "$@" || exit 1
    eval set -- "${FLAGS_ARGV}"
    if [ ${FLAGS_package} == "0" ]; then
        echo "USAGE: jark package latest --package PACKAGE"
        exit 1
    fi
    $JARK cljr.clojars get-latest-version ${FLAGS_package}
}

deps() {
    DEFINE_string 'version' '0' 'version' 'v'
    DEFINE_string 'package' '0' 'package' 'p'
    FLAGS "$@" || exit 1
    eval set -- "${FLAGS_ARGV}"
    if [ ${FLAGS_package} == "0" ]; then
        echo "USAGE: jark package deps --package PACKAGE [--version]"
        exit 1
    fi

    if [ ${FLAGS_version} == "0" ]; then
        ver=`$JARK cljr.clojars get-latest-version ${FLAGS_package}`
        $JARK cljr.clojars print-library-dependencies ${FLAGS_package} $ver
    else
        $JARK cljr.clojars print-library-dependencies ${FLAGS_package} ${FLAGS_version}
    fi
    exit 0
}

