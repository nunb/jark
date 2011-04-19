
DOC="Module for working with cljr build system"

. ${JARK_BIN}/shflags

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
    echo -e ""
    echo -e "jark package latest (--package -p PACKAGE)"
    echo -e "\tPrint the latest version of the package."
    echo -e ""
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
        $JARK_CLIENT jark.package install ${FLAGS_package}
    else
        $JARK_CLIENT jark.package install ${FLAGS_package} ${FLAGS_version}
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
    exit 0
}

versions() {
    DEFINE_string 'package' '0' 'package' 'p'
    FLAGS "$@" || exit 1
    eval set -- "${FLAGS_ARGV}"
    if [ ${FLAGS_package} == "0" ]; then
        echo "USAGE: jark package versions --package PACKAGE"
        exit 1
    fi
    $JARK_CLIENT jark.package versions ${FLAGS_package}
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
    $JARK_CLIENT jark.package search ${FLAGS_package}
    exit 0
}

installed() {
    $JARK_CLIENT jark.package list | uniq
    exit 0
}

list() {
    $JARK_CLIENT jark.package list | uniq
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
    $JARK jark.package latest-version ${FLAGS_package}
    exit 0
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
        $JARK jark.package dependencies ${FLAGS_package} $ver
    else
        $JARK jark.package dependencies ${FLAGS_package} ${FLAGS_version}
    fi
    exit 0
}

