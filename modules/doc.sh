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
        $JARK _doc examples $* 
    else
        $JARK _doc examples $* | $PAGER
    fi
}

search() {
    if [ ! -n "${PAGER+x}" ]; then 
        $JARK _doc search $* 
    else
        $JARK _doc search $* | $PAGER
    fi
}

comments() {
    if [ ! -n "${PAGER+x}" ]; then 
        $JARK _doc comments $* 
    else
        $JARK _doc comments $* | $PAGER
    fi
}
