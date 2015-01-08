`permutatedSamples` <-
function(data, B, cl) {
  samples <- matrix(nrow=B, ncol=ncol(data))
  for(i in 1:B){
    samples[i,] <- sample(1:ncol(data))
  }
  return(samples)
}
