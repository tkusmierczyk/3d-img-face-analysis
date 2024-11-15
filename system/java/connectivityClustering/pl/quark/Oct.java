package pl.quark;

import java.util.*;

class Oct 
{
	private double minx;
	private double miny;
	private double minz;
	
	private double maxx;
	private double maxy;
	private double maxz;
	
	private LinkedList<Integer> elIx = new LinkedList<Integer>();
	
	public Oct(double _minx, double _miny, double _minz, 
			double _maxx, double _maxy, double _maxz,
			int noOfElements)
	{
		minx = _minx;
		miny = _miny;
		minz = _minz;
		
		maxx = _maxx;
		maxy = _maxy;
		maxz = _maxz;
		
		for (int i = 0; i < noOfElements; ++i)
		{
			elIx.add(i);
		}
	}
	
	public Oct(double _minx, double _miny, double _minz, 
			double _maxx, double _maxy, double _maxz)
	{
		minx = _minx;
		miny = _miny;
		minz = _minz;
		
		maxx = _maxx;
		maxy = _maxy;
		maxz = _maxz;
	}
	
	public int size()
	{
		return elIx.size();		
	}
	
	public void add(int ix)
	{
		elIx.add(ix);
	}
	
	public double getDiscance(Oct c)
	{		
		double x = 0.5 * (maxx + minx);
		double y = 0.5 * (maxy + miny);
		double z = 0.5 * (maxz + minz);
		
		double cx = 0.5 * (c.maxx + c.minx);
		double cy = 0.5 * (c.maxy + c.miny);
		double cz = 0.5 * (c.maxz + c.minz);
		
		return Math.sqrt( (cx-x)*(cx-x) + (cy-y)*(cy-y) + (cz-z)*(cz-z) );    
	}
	
	public List<Integer> elements()
	{
		return elIx;
	}
	
	/**
	 * Dokleja klaster: 
	 */
	public void append(Oct c)
	{
		minx = Math.min(minx, c.minx);
		miny = Math.min(miny, c.miny);
		minz = Math.min(minz, c.minz);
		
		maxx = Math.max(maxx, c.maxx);
		maxy = Math.max(maxy, c.maxy);
		maxz = Math.max(maxz, c.maxz);
		
		for (Integer ix: c.elIx)
		{
			elIx.add(ix);
		}
	}

	/**
	 * Rozdziela klaster na 8 innych. 
	 */
	public LinkedList<Oct> split(double[] x, double[] y, double[] z)
	{
		//Przygotowanie danych:
		LinkedList<Oct> children = new LinkedList<Oct>();
		
		double meanx = 0.5 * (maxx + minx);
		double meany = 0.5 * (maxy + miny);
		double meanz = 0.5 * (maxz + minz);
		
		/* f1 f2  b1 b2 
		 * f3 f4  b3 b4 */
		
		Oct f1 = new Oct(minx, meany, minz,  meanx, maxy, meanz);
		Oct f2 = new Oct(minx, meany, meanz,  meanx, maxy, maxz );
		Oct f3 = new Oct(minx, miny, minz,  meanx, meany, meanz);
		Oct f4 = new Oct(minx, miny, meanz,  meanx, meany, maxz);

		Oct b1 = new Oct(meanx, meany, minz,  maxx, maxy, meanz);
		Oct b2 = new Oct(meanx, meany, meanz,  maxx, maxy, maxz);
		Oct b3 = new Oct(meanx, miny, minz,  maxx, meany, meanz);
		Oct b4 = new Oct(meanx, miny, meanz,  maxx, meany, maxz);
		
		//Podzielenie element�w mi�dzy dzieci
		for (Integer ix: elIx)
		{
			if (x[ix]<meanx)
			{
				if (y[ix]<meany)
				{
					if (z[ix]<meanz)
					{
						f3.add(ix);
					} else // z >= meanz
					{
						f4.add(ix);
					}
				} else //y >= meany
				{
					if (z[ix]<meanz)
					{
						f1.add(ix);
					} else // z >= meanz
					{
						f2.add(ix);
					}
				}
			} else  //x >= meanx
			{
				if (y[ix]<meany)
				{
					if (z[ix]<meanz)
					{
						b3.add(ix);
					} else // z >= meanz
					{
						b4.add(ix);
					}
				} else //y >= meany
				{
					if (z[ix]<meanz)
					{
						b1.add(ix);
					} else // z >= meanz
					{
						b2.add(ix);
					}
				}				
			}
		} //for
		
		//Przygotowanie zwracanej listy
		if (f1.size() > 0)
		{
			children.add(f1);
		}
		if (f2.size() > 0)
		{
			children.add(f2);
		}
		if (f3.size() > 0)
		{
			children.add(f3);
		}
		if (f4.size() > 0)
		{
			children.add(f4);
		}
		if (b1.size() > 0)
		{
			children.add(b1);
		}
		if (b2.size() > 0)
		{
			children.add(b2);
		}
		if (b3.size() > 0)
		{
			children.add(b3);
		}
		if (b4.size() > 0)
		{
			children.add(b4);
		}
		
		return children;
	}
}
