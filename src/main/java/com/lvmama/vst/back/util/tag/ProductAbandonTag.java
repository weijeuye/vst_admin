/**
 * 
 */
package com.lvmama.vst.back.util.tag;

import java.util.Arrays;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.TagSupport;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.lvmama.comm.pet.po.perm.PermUser;
import com.lvmama.comm.utils.ServletUtil;
import com.lvmama.vst.back.biz.po.BizEnum;
import com.lvmama.vst.comm.enumeration.CommEnumSet;
import com.lvmama.vst.comm.utils.ExceptionFormatUtil;
import com.lvmama.vst.comm.vo.Constant;

/**
 * 产品废弃 2016-09-19
 */
public class ProductAbandonTag extends TagSupport {

	/**
	 * 
	 */
	private static final long	serialVersionUID	= -681331906261416615L;
	private static final Log	LOG	= LogFactory.getLog(ProductAbandonTag.class);
	protected PermUser permUser;

	//权限id,逗号隔开
	private String managerIdPerm;
	private String categoryId;
	private String bu;
	private String suppGoodsBu;

	@Override
	public int doStartTag() throws JspException {
		HttpServletRequest req = (HttpServletRequest) pageContext.getRequest();
		HttpServletResponse resp = (HttpServletResponse) pageContext
				.getResponse();
		permUser = (PermUser) ServletUtil.getSession(req, resp,
				Constant.SESSION_BACK_USER);

		if (isPermission()) {
			return EVAL_BODY_INCLUDE;
		}
		return SKIP_BODY;
	}

	/**
	 * 是否有操作权限
	 * @return
	 */
	public boolean isPermission() {
		if (!isAuthentication()) return true;// 不走鉴权
		return authentication();
	}

	/**
	 * 鉴权是否成功
	 * @return
	 */
	public boolean authentication() {
		if (permUser == null || categoryId == null) return false;
		try {
			// 所能操作(产品/商品/订单) 的经理权限
			if (StringUtils.isNotBlank(managerIdPerm) 
			    && Arrays.asList(managerIdPerm.split(Constant.COMMA))
			    .contains(String.valueOf(permUser.getUserId()))) {
					return true;
			}
		} catch (Exception e) {
			LOG.error("【ProductAbandonTag】 Exception：" + ExceptionFormatUtil.getTrace(e));
		}
		return false;
	}

	/**
	 * 是否鉴权
	 * @return
	 */
	public boolean isAuthentication() {
		if (permUser ==null || categoryId == null) return true;
		if (permUser.isAdministrator()) return false;
		// 酒店套餐，自由行
		if (BizEnum.BIZ_CATEGORY_TYPE.category_route_hotelcomb.getCategoryId().equals(Long.valueOf(categoryId))
				|| BizEnum.BIZ_CATEGORY_TYPE.category_route_freedom.getCategoryId().equals(Long.valueOf(categoryId))) {
			// 目的地，国内，出境
			if(bu!=null && !bu.equals("")){
				if (CommEnumSet.BU_NAME.OUTBOUND_BU.name().equals(bu)
						|| CommEnumSet.BU_NAME.DESTINATION_BU.name().equals(bu)
						|| CommEnumSet.BU_NAME.LOCAL_BU.name().equals(bu)) {
					return true;
				}
			}else if (suppGoodsBu!=null && !suppGoodsBu.equals("")){ //供应商打包
				if (CommEnumSet.BU_NAME.OUTBOUND_BU.name().equals(suppGoodsBu)
						|| CommEnumSet.BU_NAME.DESTINATION_BU.name().equals(suppGoodsBu)
						|| CommEnumSet.BU_NAME.LOCAL_BU.name().equals(suppGoodsBu)) {
					return true;
				}

			}

		} else if (BizEnum.BIZ_CATEGORY_TYPE.category_hotel.getCategoryId()
				.equals(categoryId)) {// 酒店
			return true;
		}
		return false;
	}

	public String getManagerIdPerm() {
		return managerIdPerm;
	}

	public void setManagerIdPerm(String managerIdPerm) {
		this.managerIdPerm = managerIdPerm;
	}

	public String getCategoryId() {
		return categoryId;
	}

	public void setCategoryId(String categoryId) {
		this.categoryId = categoryId;
	}

	public String getBu() {
		return bu;
	}

	public void setBu(String bu) {
		this.bu = bu;
	}

	public String getSuppGoodsBu() {
		return suppGoodsBu;
	}

	public void setSuppGoodsBu(String suppGoodsBu) {
		this.suppGoodsBu = suppGoodsBu;
	}
}
