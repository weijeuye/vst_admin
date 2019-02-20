package com.lvmama.vst.back.utils;

import com.lvmama.vst.comm.vo.ResultHandleT;

public class MiscUtils {
	
	@SuppressWarnings("unchecked")
	public static <T> T autoUnboxing(Object result) {
		if(result == null) {
			return (T)result;
		}
		if(result instanceof ResultHandleT) {
			ResultHandleT<T> tempT = (ResultHandleT<T>) result;
			T  realValue = tempT == null || tempT.isFail() ? null : tempT.getReturnContent();
			return realValue;
		} else {
			return (T)result;
		}
	}
}
