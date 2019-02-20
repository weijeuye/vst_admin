
package com.lvmama.vst.back.superfreetour.util;
import java.util.Enumeration;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.RandomAccess;



public class PrUtil {
	/**
	 * <p>
	 * <li>判断对象是否为空</li>
	 * <li>一般对象为null返回true</li>
	 * <li>String对象为null或空字符串（不去空格）返回ture</li>
	 * <li>集合,数组,Map为空，或没有元素，或元素值全部为空，返回ture</li>
	 * </p>
	 * @param obj
	 * @return
	 */
	public static boolean isEmpty(Object obj){
		if(obj == null)
			return true;
		if(obj instanceof String){
			if(!"".equals(obj))
				return false;
		}else if(obj instanceof StringBuffer){
			return isEmpty(obj.toString());
		}else if(obj instanceof Map){
			if(!isEmpty(((Map)obj).values()))
				return false;
		}else if(obj instanceof Enumeration){
			Enumeration enumeration = (Enumeration) obj;
			while(enumeration.hasMoreElements()){
				if(!isEmpty(enumeration.nextElement()))
					return false;
			}
		}else if(obj instanceof Iterable){
			if(obj instanceof List && obj instanceof RandomAccess){
				List<Object> objList = (List)obj;
				for(int i = 0 ; i < objList.size() ; i ++ ){
					if(!isEmpty(objList.get(i)))
						return false;
				}

			}else if(!isEmpty(((Iterable)obj).iterator()))
				return false;
		}else if(obj instanceof Iterator){
			Iterator it = (Iterator)obj;
			while(it.hasNext()){
				if(!isEmpty(it.next()))
					return false;
			}
		}else if(obj instanceof Object[]){
			Object[] objs = (Object[])obj;
			for(Object elem : objs){
				if(!isEmpty(elem))
					return false;
			}
		}else if(obj instanceof int[]){
			for(Object elem : (int[])obj){
				if(!isEmpty(elem))
					return false;
			}
		}else{
			return false;
		}
		return true;
	}
}
