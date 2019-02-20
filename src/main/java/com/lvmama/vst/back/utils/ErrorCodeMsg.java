package com.lvmama.vst.back.utils;

public final class ErrorCodeMsg {

	//
	private ErrorCodeMsg() {

	}

	public static final String ERR_FAIL = "失败";
	// 系统内部异常
	public static final String ERR_SYS = "系统内部异常！";

	// 产品errorCode
	public static final String ERR_PRODUCT_00001 = "产品名字：%s,已存在！"; // 不能重名；
	public static final String ERR_PRODUCT_00002 = "产品ID：%s,对象不存在！"; // 对象不存在；

	// 规格属性errorCode
	public static final String ERR_BRANCH_PROP_00001 = "规格属性：%s,已存在！"; // 不能重名；
	public static final String ERR_BRANCH_PROP_00002 = "规格属性ID：%s,对象不存在！"; // 对象不存在；

	// 规格errorCode
	public static final String ERR_BRANCH_00001 = "规格：%s,已存在！"; // 不能重名；
	public static final String ERR_BRANCH_00002 = "规格ID：%s,对象不存在！"; // 对象不存在；

	// 品类属性组errorCode
	public static final String ERR_CATE_PROP_GROUP_00001 = "品类属性组：%s,已存在！"; // 不能重名；
	public static final String ERR_CATE_PROP_GROUP_00002 = "品类属性组ID：%s,对象不存在！"; // 对象不存在；
	public static final String ERR_CATE_PROP_GROUP_00003 = "品类属性组ID：%s,存在属性关联！"; // 存在属性关联；

	// 品类属性errorCode
	public static final String ERR_CATE_PROP_00001 = "品类属性：%s,已存在！"; // 不能重名；
	public static final String ERR_CATE_PROP_00002 = "品类属性ID：%s,对象不存在！"; // 对象不存在；

	// 属性池errorCode
	public static final String ERR_BIZ_PROP_POOL_00001 = "属性或CODE：已存在！"; // 不能重名；
	public static final String ERR_BIZ_PROP_POOL_00002 = "属性池ID：%s,对象不存在！"; // 对象不存在；

	// 品类errorCode
	public static final String ERR_CATE_00001 = "品类：%s,已存在！"; // 不能重名；
	public static final String ERR_CATE_00002 = "品类ID：%s,对象不存在！"; // 对象不存在；

	// 字典定义errorCode
	public static final String ERR_DICT_DEF_00001 = "字典定义：%s,已存在！"; // 不能重名；
	public static final String ERR_DICT_DEF_00002 = "字典定义ID：%s,对象不存在！"; // 对象不存在；

	// 字典属性定义errorCode
	public static final String ERR_DICT_PROP_DEF_00001 = "字典属性定义：%s,已存在！"; // 不能重名；
	public static final String ERR_DICT_PROP_DEF_00002 = "字典属性定义ID：%s,对象不存在！"; // 对象不存在；

	// 字典属性内容errorCode
	public static final String ERR_DICT_PROP_00001 = "字典属性内容：%s,已存在！"; // 不能重名；
	public static final String ERR_DICT_PROP_00002 = "字典属性内容ID：%s,对象不存在！"; // 对象不存在；

	// 字典errorCode
	public static final String ERR_DICT_00001 = "字典：%s,已存在！"; // 不能重名；
	public static final String ERR_DICT_00002 = "字典ID：%s,对象不存在！"; // 对象不存在；
	
	// 关键字errorCode
	public static final String ERR_KEYWORD_00001 = "关键字：%s,已存在！"; // 不能重名；
	public static final String ERR_KEYWORD_00002 = "关键字ID：%s,对象不存在！"; // 对象不存在；
	
	// 关键字errorCode
	public static final String ERR_BRAND_00001 = "品牌：%s,已存在！"; // 不能重名；
	public static final String ERR_BRAND_00002 = "品牌ID：%s,对象不存在！"; // 对象不存在；

	// 区域ErrorCode
	public static final String ERR_DISTRICT_0001 = "区域名称:%s,已经存在";// 区域名称重复

	// 供应商ErrorCode
	public static final String ERR_SUPPLIER_0001 = "供应商名称:%s,已经存在"; // 供应商名称已经存在
	
	//供应商传真ErrorCode
		public static final String ERR_SUPP_FAX_RULE_0001 = "供应商传真名称: %s,已经存在"; //供应商传真名称已经存在
		
	//分销商ErrorCode
	public static final String ERR_DIST_DISTRIBUTOR_0001 = "分销商名称: %s,已经存在"; //分销商名称已经存在

	// 合同ErrorCode
	public static final String ERR_CONTRACT_0001 = "合同名称:%s,已经存在";// 合同名称已经存在

	// 时间价格表
	public static final String ERR_TIMEPRICE_001 = "请先选择商品";
	public static final String ERR_TIMEPRICE_002 = "商品名称:%s,新增库存不能小于0";
	public static final String ERR_TIMEPRICE_003 = "请设置商品的销售价";
	public static final String ERR_TIMEPRICE_004 = "请时间价格设置失败";
	public static final String ERR_TIMEPRICE_005 = "请设选择退改类型";
	
	public static final String ERR_TIMEPRICE_006 = "请设置商品的成人市场价,成人销售价或成人结算价";
	public static final String ERR_TIMEPRICE_007 = "请设置日库存数";
	
	//共享库存
	public static final String ERR_GROUPSTOCK_001 = "共享库存扣除失败，暂时不能脱离共享组";
	
	
	// EBOOKING用户ErrorCode
	public static final String ERR_EBOOKING_USER_CATE_00001="用户名：%s,已存在！";
	//发送短信失败
	public static final String ERR_SMS_SEND_0001 = "订单ID：%s,节点：%s,发送短信失败！"; 
	//发送短信失败
	public static final String ERR_SMS_SEND_0002 = "订单ID：%s,内容：%s,发送短信失败！"; 
	//发送短信失败
	public static final String ERR_SMS_SEND_0003 = "订单ID：%s,发送短信失败！"; 
	//发送短信失败
	public static final String ERR_SMS_SEND_0004 = "%s,发送短信失败！"; 
	
	//短信模板ErrorCode
	public static final String ERR_ORD_SMS_TEMPLATE_0001 = "短信模板: %s, 已经存在  ！"; 
	public static final String ERR_ORD_SMS_TEMPLATE_0002 = "短信模板:数据填充出错  ！"; 
	
	// SEO定义errorCode
	public static final String ERR_SEO_EXITE_00001 = "该编号ID:%s下已经存在该友情链接地址.";
	
	public static final String ERR_INSUR_0001 = "品类已绑定选择的保险  ！"; 
	
	//REST errorCode
	public static final String ERR_REST_0001 = "错误的商品ID:%s,错误的时间段:%s——%s";
	public static final String ERR_REST_0002 = "供应商商品ID：%s, 插入失败！";
	public static final String ERR_REST_0003 = "商品ID：%s, 更新失败！";
}
