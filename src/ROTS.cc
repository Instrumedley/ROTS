#include<iostream>
#include<vector>
#include<cmath>
#include<algorithm>

using namespace std;

// Sort array b based on the array a (decreasingly)
void sort2( double* a, double* b, int n ) {
  // Create vector of pairs.
  static vector< pair<double, double> > pairs;
  pairs.reserve( n );
  for( int i = 0; i < n; ++i)
    pairs.push_back( pair<double, double>(a[i], b[i]) );
  // Sort the pairs (inc). By default pairs are sorted by the first value and
  // in the case of a tie, the second values are used.
  sort( pairs.begin(), pairs.end());
  // Split the pairs back into the original vectors (dec).
  for( int i = 0; i < n; ++i ) {
    a[ n-1-i ] = pairs[i].first;
    b[ n-1-i ] = pairs[i].second;
  }
	// Empty the vector
	pairs.clear();
}

// Array printing routine for debugging.
template<class T> void printArray( T *a, int a_len ){
  for( int i = 0; i < a_len; ++i ) 
    cout << a[i] << " ";
  cout << endl;
}

// Calculate the overlap
void calculateOverlap( double *r1, double *r2, int r_len, int *N, int N_len,
		       int b, int B, double *result ){
  // Copy r2 and sort the copy.
  double *r3 = new double[ r_len ];
	for( int i = 0; i < r_len; ++i )
    r3[i] = r2[i];
  sort(r3, r3 + r_len );
  reverse(r3, r3 + r_len );
  
  // Sort r2 by r1
  sort2( r1, r2, r_len );
  
  // Calculate the overlap
  for( int i = 0; i < N_len; ++i ){
    static double sum = 0;
    for( int j = 0; j <= ( N[i] - 1 ); ++j )
      sum += ( r2[j] >= r3[ N[i] - 1 ] );
    result[ (b-1) + i*B ] = sum / N[i];
    sum = 0;
  }
	delete[] r3;
}

// Loop1
extern "C" {
  void NeedForSpeed1(double *D, double *S, double *pD, double *pS, int *nrow,
		     int *N, int *N_len, double *ssq, int *i, int *B,
		     double *overlaps, double *overlaps_P){
    double *res1 = new double[ *nrow ];
    double *res2 = new double[ *nrow ];
    double *pres1 = new double[ *nrow ];
    double *pres2 = new double[ *nrow ];

    for( int b = 1; b <= *B; ++b ){
      for( int i = 0; i < *nrow; ++i ){
				res1[i] = fabs( D[ ( b - 1 ) * (*nrow) + i ] /
												( S[(b - 1) * (*nrow) + i] + (*ssq) ) );
				res2[i] = fabs( D[ ( b + (*B) - 1 ) * (*nrow) + i ] /
												( S[ ( b + (*B) - 1 ) * (*nrow) + i ] + (*ssq) ) );
				pres1[i] = fabs( pD[ ( b - 1 ) * (*nrow) + i ] /
												 ( pS[(b - 1) * (*nrow) + i] + (*ssq) ) );
				pres2[i] = fabs( pD[ ( b + (*B) - 1 ) * (*nrow) + i ] /
												 ( pS[ ( b + (*B) - 1 ) * (*nrow) + i ] + (*ssq) ) );
      }	
      calculateOverlap( res1, res2, *nrow, N, *N_len, b, *B, overlaps );
      calculateOverlap( pres1, pres2, *nrow, N, *N_len, b, *B, overlaps_P );
    }
		delete[] res1; delete[] res2; delete[] pres1; delete[] pres2;
	}
}

// Loop2
extern "C" {
  void NeedForSpeed2(double *D, double *pD, int *nrow, int *N, int *N_len,
		     int *B, double *overlaps, double *overlaps_P){
    double *res1 = new double[ *nrow ];
    double *res2 = new double[ *nrow ];
    double *pres1 = new double[ *nrow ];
    double *pres2 = new double[ *nrow ];
    
    for( int b = 1; b <= *B; ++b ){
      for( int i = 0; i < *nrow; ++i ){
				res1[i] = fabs( D[ ( b - 1 ) * (*nrow) + i ] );
				res2[i] = fabs( D[ ( b + (*B) - 1 ) * (*nrow) + i ] );
				pres1[i] = fabs( pD[ ( b - 1 ) * (*nrow) + i ] );
				pres2[i] = fabs( pD[ ( b + (*B) - 1 ) * (*nrow) + i ] );
      }
      calculateOverlap( res1, res2, *nrow, N, *N_len, b, *B, overlaps );
      calculateOverlap( pres1, pres2, *nrow, N, *N_len, b, *B, overlaps_P );
    }
		delete[] res1; delete[] res2; delete[] pres1; delete[] pres2;
  }
}
