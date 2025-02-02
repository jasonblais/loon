
#' @export

l_data <- function(data) {

    ## Create a dict
    dict <- ""
    for (n in names(data)) {
        if (is.character(data[[n]])) {
            #print(paste(n,'character'))
            dict <- paste(dict, ' {', n, '} ' ,
                          "{ ", paste(sapply(data[[n]],
                                             function(s)paste("{",s,"}", sep='')),
                                      collapse=" "),
                          "}", sep="")
        } else if (is.factor(data[[n]])) {
            #print(paste(n,'factor'))
            dict <- paste(dict, ' {', n, '} ' ,
                          "{ ", paste(sapply(as.character(data[[n]]),
                                             function(s)paste("{",s,"}", sep='')),
                                      collapse=" "),
                          "}", sep="")
        } else {
            #print(paste(n,'numeric'))
            dict <- paste(dict, ' {', n, '} ' ,
                          "{ ", paste(data[[n]], collapse=" "),
                          "}", sep="")
        }
    }
    return(dict)
}
