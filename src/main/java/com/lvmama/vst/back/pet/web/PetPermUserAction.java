package com.lvmama.vst.back.pet.web;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.lvmama.comm.utils.ServletUtil;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lvmama.comm.pet.po.perm.PermUser;
import com.lvmama.vst.comm.utils.json.JSONOutput;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.pet.adapter.PermUserServiceAdapter;


/**
 * 获取老系统用户action
 * @param <E>
 * 
 */
@Controller
@RequestMapping("/pet/permUser")
public class PetPermUserAction extends BaseActionSupport {

	@Autowired
	private PermUserServiceAdapter permUserServiceAdapter;

	/**
	 * 搜索用户列表
	 */
	@RequestMapping(value = "/searchUser")
	@ResponseBody
	/**
	 * 
	 * 
	 * 2013-11-22
	 * @param search : realName
	 * @param resp
	 */
	public void searchPermUsers(String search, HttpServletResponse resp){
		if (log.isDebugEnabled()) {
			log.debug("start method<searchPermUsers>");
		}
		List<PermUser> list = permUserServiceAdapter.findPermUser(search);
		JSONArray array = new JSONArray();
		if(list != null && list.size() > 0){
			for(PermUser user:list){
				JSONObject obj=new JSONObject();
				obj.put("id", user.getUserId());
				obj.put("text", user.getRealName());
				array.add(obj);
			}
		}
		JSONOutput.writeJSON(resp, array);
	}

	/**
	 * 获取当前登录用户
	 * @param resp
	 */
	@RequestMapping(value = "/getLoginUser")
	@ResponseBody
	public void getLoginUser(HttpServletRequest requ, HttpServletResponse resp){
		if (log.isDebugEnabled()) {
			log.debug("start method<getLoginUser>");
		}
		PermUser user = (PermUser) ServletUtil.getSession(requ, resp, SESSION_BACK_USER);
		JSONOutput.writeJSON(resp, user);
	}

}
