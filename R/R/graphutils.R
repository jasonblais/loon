
## Helper functions to create simple graphs


#' @export
loongraph <- function(nodes, from=character(0), to=character(0), isDirected=FALSE) {

    if (length(nodes) != length(unique(nodes)))
        warning("node names are not unique")
    
    if (length(from) != length(to))
        stop(paste0("'from' and 'to' differ in length: ",
                    length(from), ' vs. ', length(to)))
    
    if (length(from) != 0  && !all(from %in% nodes))
        stop(paste("the following nodes in 'from' do not exist:",
                   paste(from[!(from %in% nodes)], collapse=', ')))
    
    if (length(to) != 0 && !all(to %in% nodes))
        stop(paste("the following nodes in 'to' do not exist:",
                   paste(to[!(to %in% nodes)], collapse=', ')))

    graph <- list(nodes=nodes, from=from, to=to, isDirected=isDirected)
    
    class(graph) <- "loongraph"
    
    return(graph)
}


#' @export
as.loongraph <- function(graph) {
    if (!is(graph, "graph")) {
        stop("graph argument is not of class graph.")
    }
    
    nodes <- nodes(graph)
    ft <- edgeMatrix(graph)
    
    loongraph(nodes=nodes, from=nodes[ft[1,]], to=nodes[ft[2,]],
              isDirected=isDirected(graph))    
}

#' @export
as.graph <- function(loongraph) {
    if (!is(loongraph, "loongraph")) {
        stop("loongraph argument is not of class loongraph.")
    }

    n <- length(loongraph$nodes)
    edL <- vector("list", length = n)
    names(edL) <- loongraph$nodes

    if(loongraph$isDirected) {
        for(i in 1:n) {
            edL[[i]] <- loongraph$to[loongraph$from==loongraph$nodes[i]]
        }
    } else {
        for(i in 1:n) {
            
            edL[[i]] <- unique(c(loongraph$to[loongraph$from==loongraph$nodes[i]],
                          loongraph$from[loongraph$to==loongraph$nodes[i]]))
        }
    }

    new("graphNEL", nodes = loongraph$nodes,
        edgeL=edL,
        edgemode= ifelse(loongraph$isDirected,"directed","undirected"))
    
}


#' @export
plot.loongraph <- function(x, ...) {
    plot(as.graph(x), ...)
}


#' @export
completegraph <- function(nodes, isDirected=FALSE) {

    n <- length(nodes)
    if (n < 2) {
        stop("number of nodes must be > 2.")
    }
    if (isDirected) {
        co <- expand.grid(nodes, nodes, stringsAsFactors=FALSE)[-seq(1, n*n, by=n+1),]
        from <- as.vector(co[,1])
        to <- co[,2]
    } else {
        co <- combn(nodes, 2)
        from <- co[1,]
        to <- co[2,]
    }
    return(loongraph(nodes=nodes, from=from, to=to, isDirected=isDirected))

}


#' @export
linegraph <- function(x, ...) {
    UseMethod("linegraph")
}

#' @export
linegraph.loongraph <- function(x, separator=":") {
    nodes <- x$nodes
    from <- x$from
    to <- x$to
    
    n <- length(nodes) 
    p <- length(from)
    
    if (x$isDirected) {

        stop("not implemented for directed graphs yet.")
       
#        foreach nfrom1 $from nto1 $to {
#            foreach nfrom2 $from nto2 $to {
#                if {!($nfrom1 eq $nfrom2 && $nto1 eq $nto2)} {
#                    ## Do they share a node?
#                    if {$nfrom1 eq $nfrom2 || $nfrom1 eq $nto2 ||\
#                        $nto1 eq $nfrom2 || $nto1 eq $nto2} {
#			    lappend newfrom [format "%s%s%s"\
#                                             $nfrom1 $separator $nto1]
#			    lappend newto [format "%s%s%s"\
#                                           $nfrom2 $separator $nto2]
#			}
#                }
#            }
#        }

        
    } else {

        newfrom <- character(0)
        newto <- character(0)
        
        for (i in 1:p) {
            for (j in i:p) {
                if (i!=j && !(from[i] == from[j] && to[i] == to[j])) {
                    ## Do they share a node?
                    if (from[i]==from[j] || from[i]==to[j] || to[i]==from[j] || to[i]==to[j]) {
                       # cat(paste0('linegraph --   i: ', i,', j: ',j, '\n'))
                        newfrom <- c(newfrom, paste(from[i], separator, to[i], sep=''))
                        newto <- c(newto, paste(from[j], separator, to[j], sep=''))
                    }
                }
            }
        }
    }
    
    newnodes <- unique(c(newfrom, newto))

    G <- loongraph(nodes=newnodes, from=newfrom,
                   to=newto, isDirected=x$isDirected)
    
    attr(G, "separator") <- separator
    
    return(G)
}


#' @export
complement <- function(x, ...) {
    UseMethod("complement")
}

#' @export
complement.loongraph <- function(x, ...) {
    nodes <- x$nodes
    from <- x$from
    to <- x$to
    n <- length(nodes)

    newfrom <- character(0)
    newto <- character(0)
    
    if (x$isDirected) {
        
        stop("not implemented for directed graphs yet.")

    } else {
        if(n > 0) {
            for (i in 1:n) {
                for (j in i:n) {
                    if(i!=j && !(any(from==nodes[i] & to==nodes[j]) ||
                                     any(from==nodes[j] & to==nodes[i]))) {
                       # cat(paste0('complement --   i:', i,', j:',j, '\n'))
                        newfrom <- c(newfrom, nodes[i])
                        newto <- c(newto, nodes[j])
                    }
                }
            }
        }
    }

    
    
    G <- loongraph(nodes=nodes, from=newfrom, to=newto,
                   isDirected=x$isDirected)
    
    attributes(G) <- attributes(x)
    return(G)
}


##
graphproduct <- function(U,V, type=c("product", "tensor", "strong"), separator=':') {

    stop("not implemented yet.")
    
    type <- match.arg(type)

    switch(type,
           product = {
               NULL
           },
           tensor = {
               NULL
           },
           strong = {
               NULL
           })
}



#' Make each space in a node apprear only once
#'
#' @details Note this is a string based operation.
#' Node names must not contain the separator character!
#'
#' @export
#'
#' @examples 
#' 
#' G <- completegraph(nodes=LETTERS[1:4])
#' LG <- linegraph(G)
#' 
#' LLG <- linegraph(LG)
#'
#' graphreduce(LLG)
#' 
#' library(Rgraphviz)  
#' plot(graphreduce(LLG))
graphreduce <- function(graph, separator) {

    if(!is(graph, 'loongraph'))
        stop('graphreduce is only implemented for objects of class loongraph')
    
    if (graph$isDirected == TRUE)
        stop("graphreduce is not implemented for directed graphs")
    
    
    if (missing(separator)) {
        if (!is.null(attr(graph, "separator"))) {
            separator <- attr(graph, "separator")
        } else {
            stop('separator not known')
        }
    }
    
    
    nodes_reduce <- function(nodes) {
        nodes_vars <- lapply(strsplit(nodes, separator, fixed = TRUE), unique)
        unlist(lapply(nodes_vars, function(vars)paste(sort(vars), collapse = separator)))
    }
    
    ## quick way to get to result of removing duplicate edges
    
    from <- nodes_reduce(graph$from)
    to <- nodes_reduce(graph$to)
    
    sep_nodes <- paste0(separator, separator)
    if(any(grepl(sep_nodes, from)) || any(grepl(sep_nodes, to)))
       stop(paste0('nodes can not contain the string (twice the separator):', sep_nodes ))
    
    edges <- unique(apply(cbind(from,to), 1, function(nodes)paste(sort(nodes), collapse = sep_nodes)))
    
    edges_split <- strsplit(edges, sep_nodes, fixed = TRUE)
    
    new_from <- vapply(edges_split, function(x)x[1], FUN.VALUE = character(1))
    new_to <- vapply(edges_split, function(x)x[2], FUN.VALUE = character(1))
    
    
    loongraph(nodes = unique(nodes_reduce(graph$nodes)),
              from = new_from,
              to = new_to,
              isDirected = FALSE)
}


#' @export
ndtransitiongraph <- function(nodes, n, separator=":") {

    nnodes <- length(nodes)

    nodes_vars <- strsplit(nodes, separator, fixed = TRUE)

    from <- character(0)
    to <- character(0)

    if (nnodes > 0) {
        for (i in 1:nnodes) {
            for (j in i:nnodes) {
                if (i!=j && length(unique(unlist(nodes_vars[c(i,j)]))) %in% n) {
                    from <- c(from, nodes[[i]])
                    to <- c(to, nodes[[j]])
                }
            }
        }
    }

    loongraph(nodes, from, to, isDirected=FALSE)
}
