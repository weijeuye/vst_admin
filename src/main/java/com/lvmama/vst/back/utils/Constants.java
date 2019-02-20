package com.lvmama.vst.back.utils;

import com.lvmama.vst.comm.utils.ExceptionFormatUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.HashMap;
import java.util.Map;

public final class Constants {

	private static Logger LOGGER = LoggerFactory.getLogger(Constants.class);

	private Constants() {

	}

	public static final String SYSTEM = "SYSTEM"; // system

	public static final String INVALID_STATUS = "N"; // 无效
	public static final String VALID_STATUS = "Y"; // 有效

	public static final int FIRST_ORG_LEVEL = 1; // 一级部门level

	public static final Long ORG_ID_CTI = 55L; // 呼叫中心orgId值 55

	/**
	 * EBOOKING 管理员用户FLAG
	 */
	public static final String EBOOKING_ADMIN_USER_FLAG = "Y";

	public static final String ORDER_CANCEL_TYPE = "ORDER_CANCEL_TYPE"; // 订单取消类型

	public static final String NO_PERSON = "NO_PERSON"; // 分单无人

	public static final boolean ORDER_REFUND_FALSE = false; // 没有
	public static final boolean ORDER_REFUND_TRUE = true; // 有退款

	public static final Long ORDER_CANCEL_TYPE_RESOURCE_NO_CONFIM = 200L; // 订单取消类型-资源不确定
	public static final Long ORDER_CANCEL_TYPE_INFO_NO_PASS = 201L; // 订单取消类型-信息不通过
	public static final Long ORDER_CANCEL_TYPE_CUSTOMER_NOTICE = 202L; // 订单取消类型-客户通知取消
	public static final Long ORDER_CANCEL_TYPE_OTHER_REASON = 203L; // 订单取消类型-其它取消
	public static final Long ORDER_CANCEL_TYPE_ABANDON_ORDER_REPEAT = 204L; // 订单取消类型-废单重下

	/**
	 * EBK是否发送传真Y:{发送传真}
	 */
	public static final String FAX_FLAG_Y = "Y";

	/**
	 * EBK是否发送传真N:{不发送传真}
	 */
	public static final String FAX_FLAG_N = "N";

	// 订单来源 对应表数据 dist_distributor
	public static final Long DISTRIBUTOR_1 = 1L; // 暂无用
	public static final Long DISTRIBUTOR_2 = 2L; // 驴妈妈后台
	public static final Long DISTRIBUTOR_3 = 3L; // 驴妈妈前台
	public static final Long DISTRIBUTOR_4 = 4L; // 分销商
	public static final Long DISTRIBUTOR_5 = 5L; // 兴旅同业中心
	
	public static final Long DISTRIBUTOR_10 = 10L; // 兴旅同业中心

	public static final Map<String, Object> emptyMap = new HashMap<String, Object>();
	
	public enum EBK_ERR_MESSAGE_STATUS {
		PROCESSING,
		FINISH
	}

    public enum SHOW_BRANCH_ID_TYPE{
        EVENT,
        REGION
    }

	/**
	 * 字符串转换成Long
	 */
	public static Long str2Long(String strVal){
		Long longVal = null;
		try {
			longVal = Long.valueOf(strVal);
		}catch (Exception e){
			LOGGER.error(ExceptionFormatUtil.getTrace(e));
		}
		return longVal;
	}

	/**
	 * Object转换成Long
	 */
	public static Long obj2Long(Object objVal){
		Long longVal = null;
		try {
			longVal = objVal == null ? null : Long.valueOf(String.valueOf(objVal));
		}catch (Exception e){
			LOGGER.error(ExceptionFormatUtil.getTrace(e));
		}
		return longVal;
	}


}