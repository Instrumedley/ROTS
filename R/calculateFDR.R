`calculateFDR` <-
function(observed, permuted) {
  
   observed <- abs(observed)
   permuted <- abs(permuted)
   ord <- order(observed, decreasing = TRUE)
   a <- observed[ord]
   
   A <- matrix(NA, nrow=length(a), ncol=ncol(permuted))
   for(i in 1:ncol(A)) {
      a.rand <- sort(permuted[,i], decreasing = TRUE)
      n.bigger <- biggerN(a, a.rand)
      A[ord,i] <- n.bigger/(1:length(a))
   }

   FDR <- apply(A, 1, median)
   FDR[FDR>1] <- 1
	
   return(FDR)
}

