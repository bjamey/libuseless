// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Sort a List using a Heap Sort Routine
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

// array of integers to hold values
private int[] a = new int[100];

// number of elements in array
private int x;

// Heap Sort Algorithm
public void sortArray()
{
  int i;
  int temp;

  for( i = (x/2)-1; i >= 0; i-- )
  {
    siftDown( i, x );
  }

  for( i = x-1; i >= 1; i-- )
  {
    temp = a[0];
    a[0] = a[i];
    a[i] = temp;
    siftDown( 0, i-1 );
  }
}

public void siftDown( int root, int bottom )
{
  bool done = false;
  int maxChild;
  int temp;

  while( (root*2 <= bottom) && (!done) )
  {
    if( root*2 == bottom )
      maxChild = root * 2;
    else if( a[root * 2] > a[root * 2 + 1] )
      maxChild = root * 2;
    else
      maxChild = root * 2 + 1;

    if( a[root] < a[maxChild] )
    {
      temp = a[root];
      a[root] = a[maxChild];
      a[maxChild] = temp;
      root = maxChild;
    }
    else
    {
      done = true;
    }
  }
}
