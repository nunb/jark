
DOC="Module for working with cljr build system"

commands() {
    echo -e "list add remove"
}

_doc() {
    echo -e "jark repo list"
    echo -e "\tList current repositories."
    echo -e ""
    echo -e "jark repo add URL"
    echo -e "\tAdd repository."
    echo -e ""
    echo -e "jark repo remove URL"
    echo -e "\tRemove repository"
}

list() {
    $JARK_CLIENT jark.package repo-list
    exit 0
}

add() {
    $JARK_CLIENT jark.package repo-add $*
    exit 0
}

remove() {
    $JARK_CLIENT jark.package repo-remove $*
    exit 0
}
