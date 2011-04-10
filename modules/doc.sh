DOC="clojuredocs module"

commands() {
    echo -e "search examples comments"
}

_doc() {
    echo -e "jark doc search function"
    echo -e "\tFind the docstring for function."
    echo -e ""
    echo -e "jark doc examples function"
    echo -e "jark doc examples function namespace"
    echo -e ""
    echo -e "jark doc comments function"
    echo -e "jark doc comments function namespace"
}

examples() {
    if [ ! -n "${PAGER+x}" ]; then 
        $JARK_CLIENT jark.doc examples $* 
    else
        $JARK_CLIENT jark.doc examples $* | $PAGER
    fi
}

search() {
    if [ ! -n "${PAGER+x}" ]; then 
        $JARK_CLIENT jark.doc search $* 
    else
        $JARK_CLIENT jark.doc search $* | $PAGER
    fi
}

comments() {
    if [ ! -n "${PAGER+x}" ]; then 
        $JARK_CLIENT jark.doc comments $* 
    else
        $JARK_CLIENT jark.doc comments $* | $PAGER
    fi
}
