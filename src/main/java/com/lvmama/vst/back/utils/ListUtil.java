package com.lvmama.vst.back.utils;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.collections.CollectionUtils;

public class ListUtil<E> {

	public List<List<E>> exciseList(
			List<E> excisionList) {
		
		List<List<E>> rtnList = new ArrayList<List<E>>();
		int count = excisionList.size();
		for(int i=0; i < count / 10 + 1 ; i++ ){
			
			int startIndex = i * 10;
			int endIndex = (i + 1) * 10 ;
			
			if(endIndex > count){
				endIndex = count;
			}
			
			if(endIndex < startIndex){
				continue;
			}
			
			List<E> tmpList = new ArrayList<E>();
			tmpList.addAll(excisionList.subList(startIndex, endIndex));
			
			if(CollectionUtils.isEmpty(tmpList)){
				continue;
			}
			
			rtnList.add(tmpList);
		}
		return rtnList;
	}


	public static <T> List<List<T>> splitList( List<T> oriList, int batchSize) {
		List<List<T>> rtnList = new ArrayList<List<T>>();
		int count = oriList.size();
		if(oriList==null || count<=0)   return rtnList;
		for(int i=0;i<count;i=i+batchSize){
			int end = i+batchSize;
			end = end<count?end:count;
			List<T> tmpList = new ArrayList<T>();
			tmpList.addAll(oriList.subList(i, end));
			if(CollectionUtils.isEmpty(tmpList)){
				continue;
			}
			rtnList.add(tmpList);
		}
		return rtnList;
	}

}
